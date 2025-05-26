
// routes/mensajes.js
import express from 'express';
import { db } from '../db.js';

export const mensajeRoutes = express.Router();

function requireRole(roles) {
  return (req, res, next) => {
    if (!req.session.user || !roles.includes(req.session.user.role)) {
      return res.status(403).json({ error: 'Acceso denegado' });
    }
    next();
  };
}

// Enviar mensaje (vendedor y admin)
mensajeRoutes.post('/enviar', requireRole(['administrador', 'vendedor']), async (req, res) => {
  const { receptor_id, contenido } = req.body;
  const emisor_id = req.session.user.id;

  await db.execute(
    'INSERT INTO mensajes (emisor_id, receptor_id, contenido) VALUES (?, ?, ?)',
    [emisor_id, receptor_id, contenido]
  );

  res.json({ message: 'Mensaje enviado' });
});

// Ver mensajes del usuario actual
mensajeRoutes.get('/mis-mensajes', requireRole(['administrador', 'vendedor']), async (req, res) => {
  const user_id = req.session.user.id;
  const [rows] = await db.execute(
    'SELECT * FROM mensajes WHERE receptor_id = ? ORDER BY created_at DESC',
    [user_id]
  );
  res.json(rows);
});
