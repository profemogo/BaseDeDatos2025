-- Usuario para el administrador del sistema
CREATE USER IF NOT EXISTS 'admin_restaurante'@'%' IDENTIFIED BY 'AdminPass123!';
GRANT ALL PRIVILEGES ON restaurante.* TO 'admin_restaurante'@'%';

-- Usuario con permisos limitados para personal que registra reservas
CREATE USER IF NOT EXISTS 'recepcionista'@'%' IDENTIFIED BY 'RecepPass456!';
GRANT SELECT, INSERT, UPDATE ON restaurante.Reserva TO 'recepcionista'@'%';
GRANT SELECT ON restaurante.Mesa TO 'recepcionista'@'%';
GRANT SELECT, INSERT ON restaurante.Cliente TO 'recepcionista'@'%';

FLUSH PRIVILEGES;