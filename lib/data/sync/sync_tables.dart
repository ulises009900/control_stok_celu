/// Configuración de qué tablas participan del motor de sincronización
/// genérico (pull/push) contra el backend, y qué columnas de cada una son
/// booleanas o de fecha (SQLite las guarda como enteros: 0/1 y epoch
/// segundos respectivamente, así que hay que convertirlas al viajar como
/// JSON y al aplicarlas de vuelta).
///
/// Para sumar una tabla nueva al motor de sync:
///  1. Agregá su contraparte en `server/src/sync/registry.js`.
///  2. Agregá acá un [SyncTableSpec] con su nombre (igual en SQLite y
///     Postgres), la columna que actúa de cursor (`updated_at` o
///     `created_at` para tablas de solo alta) y sus columnas booleanas/fecha.
/// No hace falta tocar el resto del motor: `SyncEngine` es genérico.
class SyncTableSpec {
  const SyncTableSpec({
    required this.name,
    required this.cursorColumn,
    this.boolColumns = const <String>[],
    this.dateColumns = const <String>[],
  });

  final String name;
  final String cursorColumn;
  final List<String> boolColumns;
  final List<String> dateColumns;
}

/// Tablas sincronizadas con el motor genérico. `sales` se maneja aparte
/// (ver `SyncEngine._pushSales`/`_pullSales`) porque viaja junto con sus
/// líneas (`sale_items`), que no tienen columna propia de fecha.
const List<SyncTableSpec> kGenericSyncTables = <SyncTableSpec>[
  SyncTableSpec(
    name: 'categories',
    cursorColumn: 'updated_at',
    boolColumns: <String>['is_active'],
    dateColumns: <String>['created_at', 'updated_at'],
  ),
  SyncTableSpec(
    name: 'suppliers',
    cursorColumn: 'updated_at',
    boolColumns: <String>['is_active'],
    dateColumns: <String>['created_at', 'updated_at'],
  ),
  SyncTableSpec(
    name: 'customers',
    cursorColumn: 'updated_at',
    boolColumns: <String>['is_active'],
    dateColumns: <String>['created_at', 'updated_at'],
  ),
  SyncTableSpec(
    name: 'products',
    cursorColumn: 'updated_at',
    boolColumns: <String>['is_active'],
    dateColumns: <String>['created_at', 'updated_at'],
  ),
  SyncTableSpec(
    name: 'stock_movements',
    cursorColumn: 'created_at',
    dateColumns: <String>['created_at'],
  ),
  SyncTableSpec(
    name: 'expense_categories',
    cursorColumn: 'updated_at',
    boolColumns: <String>['is_active'],
    dateColumns: <String>['created_at', 'updated_at'],
  ),
  SyncTableSpec(
    name: 'expenses',
    cursorColumn: 'updated_at',
    boolColumns: <String>['is_active'],
    dateColumns: <String>['occurred_at', 'created_at', 'updated_at'],
  ),
  SyncTableSpec(
    name: 'cash_sessions',
    cursorColumn: 'updated_at',
    dateColumns: <String>['opened_at', 'closed_at', 'created_at', 'updated_at'],
  ),
  SyncTableSpec(
    name: 'cash_movements',
    cursorColumn: 'updated_at',
    dateColumns: <String>['created_at', 'updated_at'],
  ),
];

/// Spec especial para la tabla `sales` (usada por el push/pull a medida).
const SyncTableSpec kSalesSyncTable = SyncTableSpec(
  name: 'sales',
  cursorColumn: 'updated_at',
  dateColumns: <String>[
    'created_at',
    'updated_at',
    'confirmed_at',
    'canceled_at',
  ],
);
