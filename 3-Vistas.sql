-- Para ver los detalles de las reservas
CREATE OR REPLACE VIEW vista_reserva_detalle AS
SELECT
    r.id AS reserva_id,
    c.nombre AS cliente_nombre,
    c.apellido AS cliente_apellido,
    c.telefono AS cliente_telefono,
    m.nombre AS mesa_nombre,
    m.ubicacion AS mesa_ubicacion,
    r.fecha_reserva,
    r.numero_personas,
    r.estado AS estado_reserva
FROM Reserva r
LEFT JOIN Cliente c ON r.cliente_id = c.id
LEFT JOIN Mesa m ON r.mesa_id = m.id;

-- Para visualizar el historial de reservas confirmadas o canceladas
CREATE OR REPLACE VIEW vista_historial_reservas AS
SELECT
    r.id AS reserva_id,
    c.nombre AS cliente,
    r.fecha_reserva,
    r.estado
FROM Reserva r
LEFT JOIN Cliente c ON r.cliente_id = c.id
WHERE r.estado IN ('confirmada', 'cancelada')
ORDER BY r.fecha_reserva DESC;

-- Ver Mesas disponibles actualmente
CREATE OR REPLACE VIEW vista_mesas_disponibles AS
SELECT
    id AS mesa_id,
    nombre,
    capacidad,
    ubicacion
FROM Mesa
WHERE estado = 'Disponible';

-- Para Ver pedidos por reserva
CREATE OR REPLACE VIEW vista_pedidos_por_reserva AS
SELECT
    rp.reserva_id,
    p.id AS pedido_id,
    rp.cantidad,
    rp.observacion,
    p.total_pedido,
    p.estado AS estado_pedido
FROM ReservaPedido rp
LEFT JOIN Pedido p ON rp.pedido_id = p.id;
