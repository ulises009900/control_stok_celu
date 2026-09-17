const express = require('express');
const bcrypt = require('bcryptjs');
const { randomUUID } = require('crypto');
const pool = require('../db/pool');
const { requireAuth, requireRole } = require('../middleware/auth');

const router = express.Router();

// Todas las rutas de gestión de empleados/usuarios requieren autenticación y rol 'admin'
router.use(requireAuth);
router.use(requireRole('admin'));

// Listar todos los usuarios
router.get('/', async (req, res) => {
  try {
    const { rows } = await pool.query(
      `SELECT id, username, display_name, role, is_active, created_at, updated_at
       FROM users
       ORDER BY created_at ASC`,
    );
    res.json({ users: rows });
  } catch (err) {
    console.error('Error listando usuarios:', err);
    res.status(500).json({ error: 'Error al obtener la lista de usuarios.' });
  }
});

// Crear un nuevo usuario/empleado
router.post('/', async (req, res) => {
  const { username, password, displayName, role } = req.body || {};

  if (!username || !password || !role) {
    return res.status(400).json({ error: 'Usuario, contraseña y rol son obligatorios.' });
  }

  const cleanUsername = String(username).trim();
  if (cleanUsername.length < 3) {
    return res.status(400).json({ error: 'El nombre de usuario debe tener al menos 3 caracteres.' });
  }

  if (String(password).length < 4) {
    return res.status(400).json({ error: 'La contraseña debe tener al menos 4 caracteres.' });
  }

  if (!['admin', 'vendedor'].includes(role)) {
    return res.status(400).json({ error: 'El rol debe ser "admin" o "vendedor".' });
  }

  try {
    const exists = await pool.query('SELECT id FROM users WHERE username = $1 LIMIT 1', [cleanUsername]);
    if (exists.rows.length > 0) {
      return res.status(409).json({ error: `El usuario "${cleanUsername}" ya existe.` });
    }

    const passwordHash = await bcrypt.hash(password, 10);
    const id = randomUUID();
    const cleanDisplayName = displayName ? String(displayName).trim() : cleanUsername;

    const { rows } = await pool.query(
      `INSERT INTO users (id, username, password_hash, display_name, role, is_active, created_at, updated_at)
       VALUES ($1, $2, $3, $4, $5, TRUE, now(), now())
       RETURNING id, username, display_name, role, is_active, created_at, updated_at`,
      [id, cleanUsername, passwordHash, cleanDisplayName, role],
    );

    res.status(201).json({ user: rows[0] });
  } catch (err) {
    console.error('Error creando usuario:', err);
    res.status(500).json({ error: 'Error al crear el usuario.' });
  }
});

// Actualizar un usuario existente
router.put('/:id', async (req, res) => {
  const { id } = req.params;
  const { displayName, role, is_active, password } = req.body || {};

  try {
    const { rows: existing } = await pool.query('SELECT * FROM users WHERE id = $1 LIMIT 1', [id]);
    if (existing.length === 0) {
      return res.status(404).json({ error: 'Usuario no encontrado.' });
    }

    const targetUser = existing[0];
    const newDisplayName = displayName !== undefined ? String(displayName).trim() : targetUser.display_name;
    const newRole = role !== undefined ? role : targetUser.role;
    const newIsActive = is_active !== undefined ? Boolean(is_active) : targetUser.is_active;

    if (!['admin', 'vendedor'].includes(newRole)) {
      return res.status(400).json({ error: 'El rol debe ser "admin" o "vendedor".' });
    }

    // No permitir desactivar ni cambiar el rol del admin actual que hace la petición
    if (id === req.user.id && (!newIsActive || newRole !== 'admin')) {
      return res.status(400).json({ error: 'No podés desactivar o cambiar el rol de tu propia cuenta de administrador.' });
    }

    let passwordHash = targetUser.password_hash;
    if (password && String(password).trim().length > 0) {
      if (String(password).length < 4) {
        return res.status(400).json({ error: 'La nueva contraseña debe tener al menos 4 caracteres.' });
      }
      passwordHash = await bcrypt.hash(password, 10);
    }

    const { rows } = await pool.query(
      `UPDATE users
       SET display_name = $1, role = $2, is_active = $3, password_hash = $4, updated_at = now()
       WHERE id = $5
       RETURNING id, username, display_name, role, is_active, created_at, updated_at`,
      [newDisplayName, newRole, newIsActive, passwordHash, id],
    );

    res.json({ user: rows[0] });
  } catch (err) {
    console.error('Error actualizando usuario:', err);
    res.status(500).json({ error: 'Error al actualizar el usuario.' });
  }
});

// Eliminar un usuario
router.delete('/:id', async (req, res) => {
  const { id } = req.params;

  if (id === req.user.id) {
    return res.status(400).json({ error: 'No podés eliminar tu propia cuenta de administrador.' });
  }

  try {
    const result = await pool.query('DELETE FROM users WHERE id = $1 RETURNING id', [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Usuario no encontrado.' });
    }
    res.json({ success: true, message: 'Usuario eliminado correctamente.' });
  } catch (err) {
    console.error('Error eliminando usuario:', err);
    res.status(500).json({ error: 'Error al eliminar el usuario.' });
  }
});

module.exports = router;
