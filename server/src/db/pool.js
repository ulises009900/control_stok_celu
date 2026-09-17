const { Pool } = require('pg');
const config = require('../config');

const pool = new Pool({
  connectionString: config.databaseUrl,
});

pool.on('error', (err) => {
  // Un cliente ocioso del pool tiró un error de conexión: lo logueamos pero
  // no tumbamos el proceso, el pool reemplaza la conexión sola.
  console.error('Error inesperado en el pool de PostgreSQL', err);
});

module.exports = pool;
