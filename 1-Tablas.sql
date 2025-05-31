-- Creación la base de datos
CREATE DATABASE IF NOT EXISTS restaurante

-- Creación de las tablas
CREATE TABLE Cliente (
  id INT(11) NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  apellido VARCHAR(100) NOT NULL,
  telefono VARCHAR(20) NOT NULL,
  correo VARCHAR(150) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY idx_cliente_correo (correo)
);

CREATE TABLE Mesa (
  id INT(11) NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(50) NOT NULL,
  capacidad INT(11) NOT NULL,
  ubicacion VARCHAR(100) NOT NULL,
  estado ENUM('Disponible', 'Ocupada', 'Reservada') NOT NULL DEFAULT 'Disponible',
  PRIMARY KEY (id),
  INDEX idx_mesa_estado (estado)
);

CREATE TABLE Producto (
  id INT(11) NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  descripcion VARCHAR(255) DEFAULT NULL,
  precio DECIMAL(10, 2) NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE Pedido (
  id INT(11) NOT NULL AUTO_INCREMENT,
  total_pedido DECIMAL(10, 2) NOT NULL,
  estado ENUM('En_proceso', 'Listo', 'Cancelado') NOT NULL DEFAULT 'En_proceso',
  PRIMARY KEY (id)
);

CREATE TABLE Reserva (
  id INT(11) NOT NULL AUTO_INCREMENT,
  cliente_id INT(11) NOT NULL,
  mesa_id INT(11) NOT NULL,
  fecha_reserva DATETIME NOT NULL,
  numero_personas INT(11) NOT NULL,
  estado ENUM('Pendiente', 'Confirmada', 'Cancelada') NOT NULL DEFAULT 'Pendiente',
  PRIMARY KEY (id),
  INDEX idx_reserva_fecha (fecha_reserva),
  INDEX idx_reserva_cliente_fecha (cliente_id, fecha_reserva),
  CONSTRAINT fk_reserva_cliente FOREIGN KEY (cliente_id) REFERENCES Cliente (id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_reserva_mesa FOREIGN KEY (mesa_id) REFERENCES Mesa (id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE ReservaProducto (
  reserva_id INT(11) NOT NULL,
  producto_id INT(11) NOT NULL,
  cantidad INT(11) NOT NULL,
  observacion VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (reserva_id, producto_id),
  CONSTRAINT fk_reserva_producto_reserva FOREIGN KEY (reserva_id) REFERENCES Reserva (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_reserva_producto_producto FOREIGN KEY (producto_id) REFERENCES Producto (id) ON DELETE CASCADE ON UPDATE CASCADE
);
