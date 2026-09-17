// Uso: node scripts/create_user.js <username> <password> <admin|vendedor> ["Nombre a mostrar"]
require('dotenv').config();
const bcrypt = require('bcryptjs');
const { randomUUID } = require('crypto');
const pool = require('../src/db/pool');

async function main() {
  const [username, password, role, displayName] = process.argv.slice(2);
  if (!username || !password || !role) {
    console.error(
      'Uso: node scripts/create_user.js <username> <password> <admin|vendedor> ["Nombre a mostrar"]',
    );
    process.exit(1);
  }
  if (!['admin', 'vendedor'].includes(role)) {
    console.error('El rol debe ser "admin" o "vendedor".');
    process.exit(1);
  }

  const passwordHash = await bcrypt.hash(password, 10);
  await pool.query(
    `INSERT INTO users (id, username, password_hash, display_name, role, is_active, created_at, updated_at)
     VALUES ($1, $2, $3, $4, $5, TRUE, now(), now())
     ON CONFLICT (username) DO UPDATE
       SET password_hash = EXCLUDED.password_hash,
           display_name = EXCLUDED.display_name,
           role = EXCLUDED.role,
           updated_at = now()`,
    [randomUUID(), username, passwordHash, displayName || username, role],
  );
  console.log(`Usuario "${username}" (${role}) creado/actualizado correctamente.`);
  await pool.end();
}

main().catch((err) => {
  console.error('Error creando el usuario:', err);
  process.exit(1);
});
