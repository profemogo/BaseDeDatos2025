import express from 'express';
import { db } from '../db.js';

export const authRoutes = express.Router();

authRoutes.post('/login', async (req, res) => {
  const { email, password } = req.body;
  const [rows] = await db.execute('SELECT * FROM users WHERE email = ? AND password = ?', [email, password]);

  if (rows.length === 0) {
    return res.status(401).json({ error: 'Credenciales incorrectas' });
  }

  const user = rows[0];
  req.session.user = { id: user.id, role: user.role };
  res.json({ message: 'Login exitoso', user: req.session.user });
});

authRoutes.post('/logout', (req, res) => {
  req.session.destroy(() => {
    res.json({ message: 'Sesión cerrada' });
  });
});