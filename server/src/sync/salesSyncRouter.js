const express = require('express');
const pool = require('../db/pool');
const { getColumns } = require('./columns');

const DEFAULT_SINCE = '1970-01-01T00:00:00.000Z';
const DEFAULT_LIMIT = 200;
const MAX_LIMIT = 500;

/// Router a medida para ventas: a diferencia del resto de las tablas, cada
/// venta viaja junto con su lista de líneas (`sale_items`), que no tienen
/// columna propia de updated_at (son inmutables y dependen del ciclo de vida
/// de la venta). Se sincronizan siempre completas junto a su venta padre.
const router = express.Router();

router.get('/pull', async (req, res, next) => {
  try {
    const since = req.query.since || DEFAULT_SINCE;
    const limit = Math.min(parseInt(req.query.limit, 10) || DEFAULT_LIMIT, MAX_LIMIT);

    const { rows: sales } = await pool.query(
      `SELECT * FROM sales WHERE updated_at > $1 ORDER BY updated_at ASC LIMIT $2`,
      [since, limit],
    );

    if (sales.length === 0) {
      return res.json({ rows: [], nextSince: since, hasMore: false });
    }

    const saleIds = sales.map((s) => s.id);
    const { rows: items } = await pool.query(
      `SELECT * FROM sale_items WHERE sale_id = ANY($1::text[])`,
      [saleIds],
    );
    const itemsBySale = new Map();
    for (const item of items) {
      const list = itemsBySale.get(item.sale_id) || [];
      list.push(item);
      itemsBySale.set(item.sale_id, list);
    }

    const rows = sales.map((sale) => ({
      ...sale,
      items: itemsBySale.get(sale.id) || [],
    }));
    const nextSince = sales[sales.length - 1].updated_at.toISOString();
    res.json({ rows, nextSince, hasMore: sales.length === limit });
  } catch (err) {
    next(err);
  }
});

router.post('/push', async (req, res, next) => {
  const client = await pool.connect();
  try {
    const incoming = Array.isArray(req.body?.rows) ? req.body.rows : [];
    if (incoming.length === 0) {
      return res.json({ applied: 0 });
    }

    const saleColumns = new Set(await getColumns('sales'));
    const itemColumns = new Set(await getColumns('sale_items'));

    await client.query('BEGIN');
    let applied = 0;
    for (const sale of incoming) {
      if (!sale.id) continue;
      const columns = Object.keys(sale)
        .filter((c) => c !== 'items')
        .filter((c) => saleColumns.has(c));
      if (!columns.includes('id')) columns.unshift('id');
      const values = columns.map((c) => sale[c]);
      const placeholders = columns.map((_, i) => `$${i + 1}`);
      const updateColumns = columns.filter((c) => c !== 'id');
      const conflictAction =
        updateColumns.length === 0
          ? 'DO NOTHING'
          : `DO UPDATE SET ${updateColumns.map((c) => `${c} = EXCLUDED.${c}`).join(', ')}
             WHERE sales.updated_at <= EXCLUDED.updated_at`;

      await client.query(
        `INSERT INTO sales (${columns.join(', ')})
         VALUES (${placeholders.join(', ')})
         ON CONFLICT (id) ${conflictAction}`,
        values,
      );

      const items = Array.isArray(sale.items) ? sale.items : [];
      // Las líneas de venta son inmutables: se reemplazan por completo cada
      // vez que se sincroniza la venta padre.
      await client.query('DELETE FROM sale_items WHERE sale_id = $1', [sale.id]);
      for (const item of items) {
        if (!item.id) continue;
        const itemCols = Object.keys(item).filter((c) => itemColumns.has(c));
        if (!itemCols.includes('id')) itemCols.unshift('id');
        if (!itemCols.includes('sale_id')) itemCols.unshift('sale_id');
        const itemValues = itemCols.map((c) => (c === 'sale_id' ? sale.id : item[c]));
        const itemPlaceholders = itemCols.map((_, i) => `$${i + 1}`);
        await client.query(
          `INSERT INTO sale_items (${itemCols.join(', ')}) VALUES (${itemPlaceholders.join(', ')})
           ON CONFLICT (id) DO NOTHING`,
          itemValues,
        );
      }
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
