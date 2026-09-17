const fs = require('fs');
const path = require('path');
const bcrypt = require('bcryptjs');
const { randomUUID } = require('crypto');
const pool = require('./pool');
const config = require('../config');

async function runMigrations() {
  const migrationsDir = path.join(__dirname, 'migrations');
  const files = fs
    .readdirSync(migrationsDir)
    .filter((f) => f.endsWith('.sql'))
    .sort();

  for (const file of files) {
    const sql = fs.readFileSync(path.join(migrationsDir, file), 'utf8');
    console.log(`Aplicando migración ${file}...`);
    await pool.query(sql);
  }
  console.log('Migraciones aplicadas correctamente.');
}

async function seedAdminIfEmpty() {
  const { rows } = await pool.query('SELECT COUNT(*)::int AS count FROM users');
  if (rows[0].count > 0) {
    return;
  }
  const passwordHash = await bcrypt.hash(config.seedAdminPassword, 10);
  await pool.query(
    `INSERT INTO users (id, username, password_hash, display_name, role, is_active, created_at, updated_at)
     VALUES ($1, $2, $3, $4, 'admin', TRUE, now(), now())`,
    [randomUUID(), config.seedAdminUsername, passwordHash, 'Jefe'],
  );
  console.log(
    `Usuario admin inicial creado: usuario="${config.seedAdminUsername}". ` +
      'Cambiá la contraseña luego de iniciar sesión por primera vez.',
  );
}

async function main() {
  await runMigrations();
  await seedAdminIfEmpty();
  await pool.end();
}

if (require.main === module) {
  main().catch((err) => {
    console.error('Error corriendo las migraciones:', err);
    process.exit(1);
  });
}

module.exports = { runMigrations, seedAdminIfEmpty };
