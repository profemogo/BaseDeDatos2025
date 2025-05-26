
// routes/transacciones.js
import express from 'express';
import { db } from '../db.js';

export const transaccionRoutes = express.Router();

function requireRole(roles) {
  return (req, res, next) => {
    if (!req.session.user || !roles.includes(req.session.user.role)) {
      return res.status(403).json({ error: 'Acceso denegado' });
    }
    next();
  };
}

// Cliente crea una transacción (compra)
transaccionRoutes.post('/comprar', requireRole(['cliente']), async (req, res) => {
  const comprador_id = req.session.user.id;
  const { repuesto_id, cantidad } = req.body;

  await db.execute(
    'INSERT INTO solicitudes (comprador_id, repuesto_id, cantidad) VALUES (?, ?, ?)',
    [comprador_id, repuesto_id, cantidad]
  );

  res.json({ message: 'Compra registrada' });
});

// Vendedor ve sus propias ventas
transaccionRoutes.get('/mis-ventas', requireRole(['vendedor']), async (req, res) => {
  const vendedor_id = req.session.user.id;
  const [rows] = await db.execute(
    `SELECT s.id, r.nombre AS repuesto, s.cantidad, s.estado, s.created_at
     FROM solicitudes s
     JOIN repuestos r ON s.repuesto_id = r.id
     WHERE r.vendedor_id = ?
     ORDER BY s.created_at DESC`,
    [vendedor_id]
  );
  res.json(rows);
});
