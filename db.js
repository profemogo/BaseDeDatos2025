import mysql from 'mysql2/promise';

export const db = await mysql.createConnection({
  host: 'localhost',
  user: 'root', // deberías cambiar esto por tu usuario de MySQL
  password: '', // y la clave correspondiente
  database: 'repuestos_merida_db'
});