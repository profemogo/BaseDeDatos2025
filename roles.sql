USE repuestos_merida_db;

CREATE USER IF NOT EXISTS 'admin_user'@'localhost' IDENTIFIED BY 'admin_pass';
GRANT ALL PRIVILEGES ON repuestos_merida_db.* TO 'admin_user'@'localhost';

CREATE USER IF NOT EXISTS 'vendedor_user'@'localhost' IDENTIFIED BY 'vendedor_pass';
GRANT SELECT, INSERT, UPDATE ON repuestos_merida_db.repuestos TO 'vendedor_user'@'localhost';
GRANT SELECT, INSERT ON repuestos_merida_db.categorias TO 'vendedor_user'@'localhost';
GRANT SELECT, INSERT, UPDATE ON repuestos_merida_db.mensajes TO 'vendedor_user'@'localhost';
GRANT SELECT ON repuestos_merida_db.solicitudes TO 'vendedor_user'@'localhost';

CREATE USER IF NOT EXISTS 'cliente_user'@'localhost' IDENTIFIED BY 'cliente_pass';
GRANT SELECT ON repuestos_merida_db.repuestos TO 'cliente_user'@'localhost';
GRANT SELECT ON repuestos_merida_db.categorias TO 'cliente_user'@'localhost';

FLUSH PRIVILEGES;
