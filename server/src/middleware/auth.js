const jwt = require('jsonwebtoken');
const config = require('../config');

/// Exige un JWT válido en el header Authorization: Bearer <token>.
/// Además exige el header X-Device-Id, que identifica al teléfono/instalación
/// (no al usuario) y se usa para filtrar cajas por dispositivo.
function requireAuth(req, res, next) {
  const header = req.headers.authorization || '';
  const [scheme, token] = header.split(' ');
  if (scheme !== 'Bearer' || !token) {
    return res.status(401).json({ error: 'Falta el token de autenticación.' });
  }
  try {
    const payload = jwt.verify(token, config.jwtSecret);
    req.user = {
      id: payload.sub,
      username: payload.username,
      role: payload.role,
      displayName: payload.displayName,
    };
  } catch (err) {
    return res.status(401).json({ error: 'Token inválido o expirado.' });
  }

  const deviceId = req.headers['x-device-id'];
  if (!deviceId) {
    return res.status(400).json({ error: 'Falta el header X-Device-Id.' });
  }
  req.deviceId = String(deviceId);
  next();
}

/// Restringe una ruta a determinados roles (p. ej. solo 'admin').
function requireRole(...roles) {
  return (req, res, next) => {
    if (!req.user || !roles.includes(req.user.role)) {
      return res.status(403).json({ error: 'No tenés permisos para esta acción.' });
    }
    next();
  };
}

module.exports = { requireAuth, requireRole };
