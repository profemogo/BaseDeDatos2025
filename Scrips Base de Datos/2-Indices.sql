-- Indices para la tabla Cliente
CREATE UNIQUE INDEX idx_cliente_correo ON Cliente(correo);

-- Indices para la tabla Mesa
CREATE INDEX idx_mesa_estado ON Mesa(estado);

-- Indices para la tabla Producto
CREATE INDEX idx_producto_nombre ON Producto(nombre);

-- Indices para la tabla Pedido
CREATE INDEX idx_pedido_estado ON Pedido(estado);

-- Indices para la tabla Reserva
CREATE INDEX idx_reserva_fecha ON Reserva(fecha_reserva);
CREATE INDEX idx_reserva_cliente_fecha ON Reserva(cliente_id, fecha_reserva);

-- Indices para la tabla ReservaProducto
CREATE INDEX idx_reserva_producto_producto_id ON ReservaProducto(producto_id);
