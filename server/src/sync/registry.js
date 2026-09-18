// Registro central de tablas sincronizables entre los teléfonos (SQLite) y
// el servidor (PostgreSQL). Para agregar una tabla nueva al motor de sync
// solo hay que sumar una entrada acá (ver README de `server/` para más
// detalle) y su contraparte en el cliente (lib/data/sync/sync_tables.dart).
//
// - table: nombre de la tabla en PostgreSQL (y en SQLite, se mantienen iguales).
// - cursorColumn: columna de fecha usada para paginar pull/push ("updated_at"
//   o "created_at" para tablas que son solo un log de eventos inmutable).
// - allowedRoles: qué roles pueden leer/escribir esta tabla.
// - scopeToDeviceForNonAdmin: si es true, un usuario con rol distinto de
//   "admin" solo puede pull/push las filas de SU PROPIO dispositivo
//   (X-Device-Id). Pensado para cash_sessions/cash_movements: cada vendedor
//   ve/gestiona su propia caja, el jefe (admin) ve todas.
const TABLES = {
  categories: {
    table: 'categories',
    cursorColumn: 'updated_at',
    allowedRoles: ['admin', 'vendedor'],
  },
  suppliers: {
    table: 'suppliers',
    cursorColumn: 'updated_at',
    allowedRoles: ['admin', 'vendedor'],
  },
  customers: {
    table: 'customers',
    cursorColumn: 'updated_at',
    allowedRoles: ['admin', 'vendedor'],
  },
  products: {
    table: 'products',
    cursorColumn: 'updated_at',
    allowedRoles: ['admin', 'vendedor'],
  },
  stock_movements: {
    table: 'stock_movements',
    cursorColumn: 'created_at',
    allowedRoles: ['admin', 'vendedor'],
  },
  expense_categories: {
    table: 'expense_categories',
    cursorColumn: 'updated_at',
    allowedRoles: ['admin', 'vendedor'],
  },
  expenses: {
    table: 'expenses',
    cursorColumn: 'updated_at',
    // Los empleados pueden rendir gastos; el administrador recibe todos al
    // sincronizar y conserva la auditoría de cada registro.
    allowedRoles: ['admin', 'vendedor'],
  },
  cash_sessions: {
    table: 'cash_sessions',
    cursorColumn: 'updated_at',
    allowedRoles: ['admin', 'vendedor'],
    scopeToDeviceForNonAdmin: true,
  },
  cash_movements: {
    table: 'cash_movements',
    cursorColumn: 'updated_at',
    allowedRoles: ['admin', 'vendedor'],
    scopeToDeviceForNonAdmin: true,
  },
};

module.exports = { TABLES };
