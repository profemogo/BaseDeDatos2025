import express from 'express';
import { db } from '../db.js';

export const repuestoRoutes = express.Router();

function requireRole(roles) {
  return (req, res, next) => {
    if (!req.session.user || !roles.includes(req.session.user.role)) {
      return res.status(403).json({ error: 'Acceso denegado' });
    }
    next();
  };
}

// Crear repuesto
repuestoRoutes.post('/crear', requireRole(['administrador', 'vendedor']), async (req, res) => {
  const { nombre, descripcion, precio, stock, categoria_id, tipos_vehiculos } = req.body;
  const vendedor_id = req.session.user.id;
  await db.execute(
    'INSERT INTO repuestos (vendedor_id, nombre, descripcion, precio, stock, categoria_id, tipos_vehiculos) VALUES (?, ?, ?, ?, ?, ?, ?)',
    [vendedor_id, nombre, descripcion, precio, stock, categoria_id, tipos_vehiculos.join(',')]
  );
  res.json({ message: 'Repuesto creado' });
});

// Obtener repuestos con filtros
repuestoRoutes.get('/', requireRole(['administrador', 'vendedor', 'cliente']), async (req, res) => {
  const { nombre, categoria_id, orden } = req.query;
  let query = 'SELECT * FROM repuestos WHERE 1=1';
  const params = [];
  if (nombre) {
    query += ' AND nombre LIKE ?';
    params.push(`%${nombre}%`);
  }
  if (categoria_id) {
    query += ' AND categoria_id = ?';
    params.push(categoria_id);
  }
  if (orden === 'asc') {
    query += ' ORDER BY precio ASC';
  } else if (orden === 'desc') {
    query += ' ORDER BY precio DESC';
  }
  const [rows] = await db.execute(query, params);
  res.json(rows);
});