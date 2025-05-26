import express from 'express';
import cors from 'cors';
import session from 'express-session';

import { authRoutes } from './routes/auth.js';
import { repuestoRoutes } from './routes/repuestos.js';

import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

app.use(session({
  secret: 'mi_clave_secreta',
  resave: false,
  saveUninitialized: false
}));

app.use('/api/auth', authRoutes);
app.use('/api/repuestos', repuestoRoutes);

app.listen(3000, () => {
  console.log('Servidor escuchando en http://localhost:3000');
});