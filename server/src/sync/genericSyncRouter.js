const express = require('express');
const pool = require('../db/pool');
const { TABLES } = require('./registry');
const { getColumns } = require('./columns');

const DEFAULT_SINCE = '1970-01-01T00:00:00.000Z';
const DEFAULT_LIMIT = 500;
const MAX_LIMIT = 1000;

function resolveTableConfig(req, res) {
  const config = TABLES[req.params.key];
  if (!config) {
    res.status(404).json({ error: `Tabla de sincronización desconocida: ${req.params.key}` });
    return null;
  }
  if (!config.allowedRoles.includes(req.user.role)) {
    res.status(403).json({ error: 'No tenés permisos para sincronizar esta tabla.' });
    return null;
  }
  return config;
}

/// Router genérico de sincronización: expone GET /:key/pull y
/// POST /:key/push para cualquier tabla registrada en `registry.js`, sin
/// necesitar un endpoint a medida por tabla.
const router = express.Router();

router.get('/:key/pull', async (req, res, next) => {
  try {
    const config = resolveTableConfig(req, res);
    if (!config) return;

    const since = req.query.since || DEFAULT_SINCE;
    const limit = Math.min(
      parseInt(req.query.limit, 10) || DEFAULT_LIMIT,
      MAX_LIMIT,
    );

    const params = [since];
    let scopeClause = '';
    if (config.scopeToDeviceForNonAdmin && req.user.role !== 'admin') {
      params.push(req.deviceId);
      scopeClause = ' AND device_id = $2';
    }
    params.push(limit);
    const limitPlaceholder = `$${params.length}`;

    const { rows } = await pool.query(
      `SELECT * FROM ${config.table}
       WHERE ${config.cursorColumn} > $1${scopeClause}
       ORDER BY ${config.cursorColumn} ASC
       LIMIT ${limitPlaceholder}`,
      params,
    );

    const nextSince =
      rows.length > 0
        ? rows[rows.length - 1][config.cursorColumn].toISOString()
        : since;

    res.json({ rows, nextSince, hasMore: rows.length === limit });
  } catch (err) {
    next(err);
  }
});

router.post('/:key/push', async (req, res, next) => {
  const client = await pool.connect();
  try {
    const config = resolveTableConfig(req, res);
    if (!config) return;

    const incomingRows = Array.isArray(req.body?.rows) ? req.body.rows : [];
    if (incomingRows.length === 0) {
      return res.json({ applied: 0 });
    }

    if (config.scopeToDeviceForNonAdmin && req.user.role !== 'admin') {
      const foreignRow = incomingRows.find((row) => row.device_id !== req.deviceId);
      if (foreignRow) {
        return res.status(403).json({
          error: 'No podés enviar filas de caja de otro dispositivo.',
        });
      }
    }

    const validColumns = new Set(await getColumns(config.table));

    await client.query('BEGIN');
    let applied = 0;
    for (const row of incomingRows) {
      if (!row.id) continue;
      const columns = Object.keys(row).filter((c) => validColumns.has(c));
      if (!columns.includes('id')) columns.unshift('id');
      const values = columns.map((c) => row[c]);
      const placeholders = columns.map((_, i) => `$${i + 1}`);
      const updateColumns = columns.filter((c) => c !== 'id');
      const conflictAction =
        updateColumns.length === 0
          ? 'DO NOTHING'
          : `DO UPDATE SET ${updateColumns.map((c) => `${c} = EXCLUDED.${c}`).join(', ')}
             WHERE ${config.table}.${config.cursorColumn} <= EXCLUDED.${config.cursorColumn}`;

      const sql = `
        INSERT INTO ${config.table} (${columns.join(', ')})
        VALUES (${placeholders.join(', ')})
        ON CONFLICT (id) ${conflictAction}
      `;
      await client.query(sql, values);
      applied += 1;
    }
    await client.query('COMMIT');
    res.json({ applied });
  } catch (err) {
    await client.query('ROLLBACK');
    next(err);
  } finally {
    client.release();
  }
});

module.exports = router;
