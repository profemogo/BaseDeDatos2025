USE repuestos_merida_db;

DROP VIEW IF EXISTS ViewRepuestoBasic;
CREATE VIEW ViewRepuestoBasic AS
SELECT
  r.id AS repuesto_id,
  r.nombre AS repuesto_nombre,
  r.descripcion,
  r.precio,
  r.stock,
  c.nombre AS categoria_nombre,
  u.name AS vendedor_nombre,
  r.created_at AS fecha_creacion
FROM
  repuestos r
JOIN
  users u ON r.vendedor_id = u.id
LEFT JOIN
  categorias c ON r.categoria_id = c.id;

DROP VIEW IF EXISTS ViewSolicitudDetail;
CREATE VIEW ViewSolicitudDetail AS
SELECT
  s.id AS solicitud_id,
  s.created_at AS fecha_solicitud,
  s.estado,
  comp.name AS comprador_nombre,
  vend.name AS vendedor_nombre,
  r.nombre AS repuesto_nombre,
  r.precio,
  s.cantidad,
  (r.precio * s.cantidad) AS total_pedido
FROM
  solicitudes s
JOIN
  users comp ON s.comprador_id = comp.id
JOIN
  repuestos r ON s.repuesto_id = r.id
JOIN
  users vend ON r.vendedor_id = vend.id;

DROP VIEW IF EXISTS ViewMessageDetail;
CREATE VIEW ViewMessageDetail AS
SELECT
  m.id AS mensaje_id,
  m.created_at AS fecha_envio,
  sender.name AS emisor_nombre,
  receiver.name AS receptor_nombre,
  m.contenido,
  m.leido
FROM
  mensajes m
JOIN
  users sender ON m.emisor_id = sender.id
JOIN
  users receiver ON m.receptor_id = receiver.id;
