const pool = require('../db/pool');

const cache = new Map();

/// Devuelve la lista de columnas reales de una tabla (nombre de columna en
/// snake_case), consultando information_schema una sola vez y cacheando el
/// resultado en memoria mientras el proceso esté vivo.
async function getColumns(tableName) {
  if (cache.has(tableName)) {
    return cache.get(tableName);
  }
  const { rows } = await pool.query(
    `SELECT column_name FROM information_schema.columns
     WHERE table_schema = 'public' AND table_name = $1
     ORDER BY ordinal_position`,
    [tableName],
  );
  const columns = rows.map((r) => r.column_name);
  cache.set(tableName, columns);
  return columns;
}

module.exports = { getColumns };
