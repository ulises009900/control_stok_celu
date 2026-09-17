require('dotenv').config();

const required = (name, fallback) => {
  const value = process.env[name] ?? fallback;
  if (value === undefined) {
    throw new Error(`Falta la variable de entorno ${name}`);
  }
  return value;
};

module.exports = {
  apiPort: parseInt(process.env.API_PORT || '4000', 10),
  databaseUrl: required('DATABASE_URL'),
  jwtSecret: required('JWT_SECRET'),
  jwtExpiresIn: process.env.JWT_EXPIRES_IN || '30d',
  seedAdminUsername: process.env.SEED_ADMIN_USERNAME || 'jefe',
  seedAdminPassword: process.env.SEED_ADMIN_PASSWORD || 'cambiar123',
};
