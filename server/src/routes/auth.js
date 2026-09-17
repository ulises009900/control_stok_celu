const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const pool = require('../db/pool');
const config = require('../config');
const { requireAuth } = require('../middleware/auth');

const router = express.Router();

router.post('/login', async (req, res) => {
  const { username, password } = req.body || {};
  if (!username || !password) {
    return res.status(400).json({ error: 'Usuario y contraseña son obligatorios.' });
  }

  const { rows } = await pool.query(
    'SELECT * FROM users WHERE username = $1 LIMIT 1',
    [username],
  );
  const user = rows[0];
  if (!user || !user.is_active) {
    return res.status(401).json({ error: 'Usuario o contraseña incorrectos.' });
  }

  const matches = await bcrypt.compare(password, user.password_hash);
  if (!matches) {
    return res.status(401).json({ error: 'Usuario o contraseña incorrectos.' });
  }

  const token = jwt.sign(
    {
      sub: user.id,
      username: user.username,
      role: user.role,
      displayName: user.display_name,
    },
    config.jwtSecret,
    { expiresIn: config.jwtExpiresIn },
  );

  res.json({
    token,
    user: {
      id: user.id,
      username: user.username,
      displayName: user.display_name,
      role: user.role,
    },
  });
});

router.get('/me', requireAuth, (req, res) => {
  res.json({ user: req.user, deviceId: req.deviceId });
});

module.exports = router;
