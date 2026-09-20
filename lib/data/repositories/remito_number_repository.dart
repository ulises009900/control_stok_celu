import 'package:control_stok_celu/data/db/app_database.dart';
import 'package:drift/drift.dart';

/// A remito keeps its number independently of subsequent sale edits/deletion.
/// Numbers are allocated locally so issuing a remito never requires a server.
class RemitoNumberRepository {
  RemitoNumberRepository(this.db);

  final AppDatabase db;

  Future<int?> _read(String saleId) async {
    final row = await db.customSelect(
      // Reuse numbers cached by earlier versions, too.
      "SELECT number FROM remito_numbers WHERE sale_id = ? ORDER BY CASE WHEN scope = 'local' THEN 0 ELSE 1 END, number LIMIT 1",
      variables: [Variable<String>(saleId)],
    ).getSingleOrNull();
    return row?.read<int>('number');
  }

  Future<int> getOrCreate(String saleId) async {
    return db.transaction(() async {
      final existing = await _read(saleId);
      if (existing != null) return existing;
      final row = await db
          .customSelect(
            'SELECT COALESCE(MAX(number), 0) + 1 AS next_number FROM remito_numbers',
          )
          .getSingle();
      final number = row.read<int>('next_number');
      await db.customStatement(
        'INSERT INTO remito_numbers(scope, sale_id, number) VALUES (?, ?, ?)',
        ['local', saleId, number],
      );
      return number;
    });
  }
}
