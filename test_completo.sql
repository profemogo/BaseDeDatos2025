DROP DATABASE IF EXISTS repuestos_merida_db;

SOURCE repuestos_merida_db.sql;
SOURCE indices.sql;
SOURCE roles.sql;
SOURCE vistas.sql;
SOURCE procedimientos.sql;
SOURCE trigger.sql;
SOURCE transaciones.sql;

USE repuestos_merida_db;

-- Insert data de prueba
INSERT INTO users (name, email, password, role, telefono) VALUES
  ('Juan Pérez', 'juan@correo.com', '1234', 'vendedor', '0414000001'),
  ('Ana Gómez',  'ana@correo.com',  '1234', 'cliente',  '0414000002');

INSERT INTO categorias (nombre) VALUES ('Motor'), ('Frenos');

INSERT INTO repuestos (vendedor_id, nombre, descripcion, precio, stock, categoria_id, tipos_vehiculos)
VALUES
  (1, 'Filtro de aceite',   'Filtro 2018-2022',    15.50, 10, 1, 'carro,moto'),
  (1, 'Pastillas de freno', 'Juego de pastillas',   30.00,  8, 2, 'carro');

INSERT INTO solicitudes (comprador_id, repuesto_id, cantidad, estado)
VALUES (2, 1, 2, 'pendiente');

INSERT INTO mensajes (emisor_id, receptor_id, contenido, leido)
VALUES (2, 1, 'Hola, ¿tienes stock?', FALSE);

INSERT INTO resenas (repuesto_id, comprador_id, calificacion, comentario)
VALUES (1, 2, 5, 'Excelente calidad');

-- Pruebas de transacciones
START TRANSACTION;
  INSERT INTO solicitudes (comprador_id, repuesto_id, cantidad, estado)
    VALUES (2, 2, 3, 'pendiente');
  UPDATE repuestos
    SET stock = stock - 3
    WHERE id = 2;
  SELECT id, nombre, stock FROM repuestos WHERE id = 2;
COMMIT;
SELECT id, nombre, stock FROM repuestos WHERE id = 2;

START TRANSACTION;
  INSERT INTO solicitudes (comprador_id, repuesto_id, cantidad, estado)
    VALUES (2, 2, 2, 'pendiente');
  UPDATE repuestos
    SET stock = stock - 2
    WHERE id = 2;
  SELECT id, nombre, stock FROM repuestos WHERE id = 2;
ROLLBACK;
SELECT id, nombre, stock FROM repuestos WHERE id = 2;

-- Pruebas de triggers
SELECT id, nombre, stock FROM repuestos WHERE id = 1;
UPDATE solicitudes SET estado = 'aprobado' WHERE id = 1;
SELECT id, nombre, stock FROM repuestos WHERE id = 1;
SELECT * FROM historial_stock WHERE repuesto_id = 1 ORDER BY fecha DESC LIMIT 1;

SELECT id, contenido, leido FROM mensajes WHERE id = 1;
UPDATE mensajes SET leido = TRUE WHERE id = 1;
SELECT id, contenido, leido FROM mensajes WHERE id = 1;

SELECT COUNT(*) AS antes_msgs FROM mensajes WHERE receptor_id = 1;
INSERT INTO solicitudes (comprador_id, repuesto_id, cantidad, estado)
  VALUES (2, 2, 1, 'pendiente');
SELECT COUNT(*) AS despues_msgs FROM mensajes WHERE receptor_id = 1;
SELECT * FROM mensajes WHERE receptor_id = 1 ORDER BY created_at DESC LIMIT 1;

-- Pruebas de vistas
SELECT * FROM ViewRepuestoBasic;
SELECT * FROM ViewSolicitudDetail;
SELECT * FROM ViewMessageDetail;

-- Pruebas de procedimientos
SET @out_stock = 0;
CALL proc_obtener_stock(1, @out_stock);
SELECT CONCAT('Stock actual de repuesto 1: ', @out_stock) AS Resultado;
CALL proc_crear_solicitud(2, 1, 1);
SELECT * FROM solicitudes WHERE comprador_id = 2 AND repuesto_id = 1 ORDER BY created_at DESC LIMIT 1;
