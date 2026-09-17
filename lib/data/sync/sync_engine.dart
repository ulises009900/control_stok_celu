import 'package:control_stok_celu/data/db/app_database.dart';
import 'package:control_stok_celu/data/sync/sync_api_client.dart';
import 'package:control_stok_celu/data/sync/sync_tables.dart';
import 'package:drift/drift.dart';

class SyncResult {
  const SyncResult({required this.pushed, required this.pulled, this.error});

  final int pushed;
  final int pulled;
  final String? error;

  bool get hasError => error != null;
}

class _Cursor {
  const _Cursor({this.lastPushedAt, this.lastPulledAt});

  final DateTime? lastPushedAt;
  final DateTime? lastPulledAt;
}

final DateTime _epoch = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

/// Motor de sincronización offline-first: empuja los cambios locales
/// pendientes hacia el servidor y luego trae los cambios remotos, tabla por
/// tabla, usando el registro de [kGenericSyncTables] (más el caso especial
/// de `sales`, que viaja con sus líneas anidadas).
///
/// Es deliberadamente "genérico": no conoce los modelos de dominio de cada
/// tabla, solo trabaja con filas crudas (`Map<String, dynamic>`) leídas y
/// escritas con SQL directo, por lo que agregar una tabla nueva no requiere
/// tocar esta clase (ver `sync_tables.dart`).
class SyncEngine {
  SyncEngine({required AppDatabase db, required SyncApiClient client})
      : _db = db,
        _client = client;

  final AppDatabase _db;
  final SyncApiClient _client;

  Future<SyncResult> syncAll() async {
    var pushed = 0;
    var pulled = 0;
    String? firstError;

    Future<void> guarded(Future<int> Function() action, void Function(int) add) async {
      try {
        add(await action());
      } on SyncApiException catch (e) {
        // 403 significa que este rol no tiene acceso a esa tabla (p. ej. un
        // vendedor no sincroniza gastos): no es un error real, se omite esa
        // tabla y se sigue con las demás.
        if (e.statusCode != 403) {
          firstError ??= e.message;
        }
      } catch (e) {
        firstError ??= e.toString();
      }
    }

    for (final spec in kGenericSyncTables) {
      await guarded(() => _pushTable(spec), (v) => pushed += v);
    }
    await guarded(_pushSales, (v) => pushed += v);
    for (final spec in kGenericSyncTables) {
      await guarded(() => _pullTable(spec), (v) => pulled += v);
    }
    await guarded(_pullSales, (v) => pulled += v);

    return SyncResult(pushed: pushed, pulled: pulled, error: firstError);
  }

  Future<int> _pushTable(SyncTableSpec spec) async {
    final cursor = await _getCursor(spec.name);
    final since = cursor.lastPushedAt ?? _epoch;
    final rows = await _db.customSelect(
      'SELECT * FROM ${spec.name} WHERE ${spec.cursorColumn} > ? '
      'ORDER BY ${spec.cursorColumn} ASC LIMIT 200',
      variables: <Variable<Object>>[Variable<DateTime>(since)],
    ).get();
    if (rows.isEmpty) {
      return 0;
    }
    final payload = rows.map((r) => _rowToJson(r.data, spec)).toList();
    final applied = await _client.push(spec.name, payload);
    await _setCursor(
      spec.name,
      pushedAt: _maxColumnValue(rows, spec.cursorColumn),
    );
    return applied;
  }

  Future<int> _pullTable(SyncTableSpec spec) async {
    var pulled = 0;
    var since = (await _getCursor(spec.name)).lastPulledAt ?? _epoch;
    while (true) {
      final result = await _client.pull(spec.name, since: since.toIso8601String());
      if (result.rows.isEmpty) {
        break;
      }
      await _db.transaction(() async {
        for (final row in result.rows) {
          await _applyRow(row, spec);
        }
      });
      pulled += result.rows.length;
      since = DateTime.parse(result.nextSince);
      await _setCursor(spec.name, pulledAt: since);
      if (!result.hasMore) {
        break;
      }
    }
    return pulled;
  }

  Future<int> _pushSales() async {
    final cursor = await _getCursor(kSalesSyncTable.name);
    final since = cursor.lastPushedAt ?? _epoch;
    final saleRows = await _db.customSelect(
      'SELECT * FROM sales WHERE updated_at > ? ORDER BY updated_at ASC LIMIT 100',
      variables: <Variable<Object>>[Variable<DateTime>(since)],
    ).get();
    if (saleRows.isEmpty) {
      return 0;
    }
    final payload = <Map<String, dynamic>>[];
    for (final saleRow in saleRows) {
      final saleJson = _rowToJson(saleRow.data, kSalesSyncTable);
      final itemRows = await _db.customSelect(
        'SELECT * FROM sale_items WHERE sale_id = ?',
        variables: <Variable<Object>>[Variable<String>(saleRow.read<String>('id'))],
      ).get();
      saleJson['items'] = itemRows.map((r) => Map<String, dynamic>.from(r.data)).toList();
      payload.add(saleJson);
    }
    final applied = await _client.push('sales', payload);
    await _setCursor(
      kSalesSyncTable.name,
      pushedAt: _maxColumnValue(saleRows, 'updated_at'),
    );
    return applied;
  }

  Future<int> _pullSales() async {
    var pulled = 0;
    var since = (await _getCursor(kSalesSyncTable.name)).lastPulledAt ?? _epoch;
    while (true) {
      final result = await _client.pull('sales', since: since.toIso8601String());
      if (result.rows.isEmpty) {
        break;
      }
      await _db.transaction(() async {
        for (final row in result.rows) {
          final items = (row['items'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ??
              const <Map<String, dynamic>>[];
          final saleOnly = Map<String, dynamic>.from(row)..remove('items');
          await _applyRow(saleOnly, kSalesSyncTable);
          await _db.customStatement(
            'DELETE FROM sale_items WHERE sale_id = ?',
            <Object?>[saleOnly['id']],
          );
          for (final item in items) {
            final columns = item.keys.toList();
            final placeholders = List<String>.filled(columns.length, '?').join(', ');
            await _db.customStatement(
              'INSERT INTO sale_items (${columns.join(', ')}) VALUES ($placeholders) '
              'ON CONFLICT(id) DO NOTHING',
              columns.map((c) => item[c]).toList(),
            );
          }
        }
      });
      pulled += result.rows.length;
      since = DateTime.parse(result.nextSince);
      await _setCursor(kSalesSyncTable.name, pulledAt: since);
      if (!result.hasMore) {
        break;
      }
    }
    return pulled;
  }

  /// Convierte una fila cruda leída de SQLite (con fechas/booleanos como
  /// enteros) a un mapa JSON-friendly para mandar por HTTP.
  Map<String, dynamic> _rowToJson(Map<String, dynamic> data, SyncTableSpec spec) {
    final result = <String, dynamic>{};
    data.forEach((key, value) {
      if (spec.dateColumns.contains(key)) {
        result[key] = value == null ? null : _epochToIso(value as int);
      } else if (spec.boolColumns.contains(key)) {
        result[key] = value == null ? null : (value == 1 || value == true);
      } else {
        result[key] = value;
      }
    });
    return result;
  }

  /// Inserta o actualiza (upsert real, no delete+insert) una fila recibida
  /// del servidor. Usa "última escritura gana" comparando la columna cursor,
  /// igual que el servidor, y evita "INSERT OR REPLACE" para no disparar
  /// borrados en cascada de filas hijas (sale_items, cash_movements).
  Future<void> _applyRow(Map<String, dynamic> json, SyncTableSpec spec) async {
    final columns = json.keys.toList();
    final values = columns.map((col) {
      final raw = json[col];
      if (spec.dateColumns.contains(col)) {
        return raw == null
            ? null
            : DateTime.parse(raw as String).millisecondsSinceEpoch ~/ 1000;
      }
      if (spec.boolColumns.contains(col)) {
        return raw == null ? null : (raw == true ? 1 : 0);
      }
      return raw;
    }).toList();

    final placeholders = List<String>.filled(columns.length, '?').join(', ');
    final updateColumns = columns.where((c) => c != 'id').toList();
    final sql = updateColumns.isEmpty
        ? 'INSERT INTO ${spec.name} (${columns.join(', ')}) VALUES ($placeholders) '
            'ON CONFLICT(id) DO NOTHING'
        : '''
        INSERT INTO ${spec.name} (${columns.join(', ')}) VALUES ($placeholders)
        ON CONFLICT(id) DO UPDATE SET ${updateColumns.map((c) => '$c = excluded.$c').join(', ')}
        WHERE excluded.${spec.cursorColumn} >= ${spec.name}.${spec.cursorColumn}
        ''';
    await _db.customStatement(sql, values);
  }

  DateTime _maxColumnValue(List<QueryRow> rows, String column) {
    var max = _epoch;
    for (final row in rows) {
      final raw = row.data[column];
      if (raw == null) continue;
      final value = raw is int ? _epochToDateTime(raw) : max;
      if (value.isAfter(max)) {
        max = value;
      }
    }
    return max;
  }

  String _epochToIso(int raw) => _epochToDateTime(raw).toIso8601String();

  DateTime _epochToDateTime(int raw) {
    final absolute = raw.abs();
    if (absolute < 100000000000) {
      return DateTime.fromMillisecondsSinceEpoch(raw * 1000, isUtc: true);
    }
    if (absolute > 10000000000000) {
      return DateTime.fromMicrosecondsSinceEpoch(raw, isUtc: true);
    }
    return DateTime.fromMillisecondsSinceEpoch(raw, isUtc: true);
  }

  Future<_Cursor> _getCursor(String table) async {
    final row = await (_db.select(_db.syncCursors)
          ..where((t) => t.entityTable.equals(table)))
        .getSingleOrNull();
    return _Cursor(lastPushedAt: row?.lastPushedAt, lastPulledAt: row?.lastPulledAt);
  }

  Future<void> _setCursor(String table, {DateTime? pushedAt, DateTime? pulledAt}) async {
    final existing = await _getCursor(table);
    await _db.into(_db.syncCursors).insertOnConflictUpdate(
          SyncCursorsCompanion.insert(
            entityTable: table,
            lastPushedAt: Value(pushedAt ?? existing.lastPushedAt),
            lastPulledAt: Value(pulledAt ?? existing.lastPulledAt),
          ),
        );
  }
}
