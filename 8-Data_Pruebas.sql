-- Insertar clientes
INSERT INTO Cliente (nombre, apellido, telefono, correo) VALUES
('Carlos', 'Gómez', '04141234567', 'carlos.gomez@email.com'),
('Ana', 'Pérez', '04147894521', 'ana.perez@email.com'),
('Luis', 'Fernández', '04261239876', 'luis.fernandez@email.com');

-- Insertar pedidos
INSERT INTO Pedido (total_pedido, estado) VALUES
(35.00, 'En_proceso'),
(20.00, 'Listo'),
(15.00, 'Cancelado');

-- Insertar reservas
INSERT INTO Reserva (cliente_id, mesa_id, fecha_reserva, numero_personas, estado) VALUES
(1, 1, '2025-06-01 19:30:00', 4, 'Pendiente'),
(2, 2, '2025-06-01 20:00:00', 2, 'Confirmada'),
(3, 3, '2025-06-02 21:00:00', 3, 'Cancelada');

-- Insertar detalles de reserva-producto (comidas o bebidas pedidas en cada reserva)
INSERT INTO ReservaProducto (reserva_id, producto_id, cantidad, observacion) VALUES
(1, 1, 2, 'Sin pollo'),
(1, 6, 4, NULL),
(2, 3, 1, 'Extra queso'),
(3, 2, 1, NULL);



-- EJEMPLO DE UNA TRANSACCION

START TRANSACTION;

INSERT INTO Pedido (total_pedido, estado)
VALUES (50.00, 'En_proceso');

-- Obtener el id del pedido insertado
SET @pedido_id = LAST_INSERT_ID();

INSERT INTO Reserva (cliente_id, mesa_id, fecha_reserva, numero_personas, estado)
VALUES (1, 1, '2025-06-10 20:00:00', 4, 'Pendiente');

-- Obtener el id de la reserva insertada
SET @reserva_id = LAST_INSERT_ID();

INSERT INTO ReservaProducto (reserva_id, producto_id, cantidad, observacion)
VALUES (@reserva_id, 1, 2, 'Sin pollo'),
       (@reserva_id, 4, 1, NULL);

UPDATE Pedido
SET total_pedido = (
    SELECT SUM(p.precio * rp.cantidad)
    FROM ReservaProducto rp
    JOIN Producto p ON rp.producto_id = p.id
    WHERE rp.reserva_id = @reserva_id
)
WHERE id = @pedido_id;

COMMIT;
