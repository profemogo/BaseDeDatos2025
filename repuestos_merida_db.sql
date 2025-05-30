
CREATE DATABASE IF NOT EXISTS repuestos_merida_db;
USE repuestos_merida_db;

-- Tabla de usuarios
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('administrador', 'vendedor', 'cliente') DEFAULT 'cliente',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de categorías
CREATE TABLE IF NOT EXISTS categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL
);

-- Tabla de repuestos
CREATE TABLE IF NOT EXISTS repuestos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    vendedor_id INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    imagenes JSON,
    categoria_id INT,
    tipos_vehiculos SET('moto', 'carro', 'anfibio', 'híbrido', 'eléctrico', 'bicicleta', 'triciclo'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (vendedor_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id)
);

-- Tabla de solicitudes de compra
CREATE TABLE IF NOT EXISTS solicitudes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    comprador_id INT,
    repuesto_id INT,
    cantidad INT,
    estado ENUM('pendiente', 'aprobado', 'rechazado') DEFAULT 'pendiente',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (comprador_id) REFERENCES users(id),
    FOREIGN KEY (repuesto_id) REFERENCES repuestos(id)
);

-- Tabla de mensajes
CREATE TABLE IF NOT EXISTS mensajes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    emisor_id INT,
    receptor_id INT,
    contenido TEXT NOT NULL,
    leido BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (emisor_id) REFERENCES users(id),
    FOREIGN KEY (receptor_id) REFERENCES users(id)
);

-- Vista: solo repuestos del vendedor conectado
DROP VIEW IF EXISTS vista_repuestos_personales;
CREATE VIEW vista_repuestos_personales AS
SELECT * FROM repuestos WHERE vendedor_id = (SELECT id FROM users WHERE email = SESSION_USER());

-- Crear usuarios MySQL con permisos por rol
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

-- Insertar usuario administrador inicial
INSERT INTO users (name, email, password, role)
VALUES ('Administrador BTM Studio', 'btmstudio@mail.com', 'byeliasmontilla', 'administrador')
ON DUPLICATE KEY UPDATE email=email;

-- Enviar notificación al vendedor cuando alguien solicita un repuesto
DELIMITER //
CREATE TRIGGER after_solicitud_insert
AFTER INSERT ON solicitudes
FOR EACH ROW
BEGIN
    DECLARE vendedor INT;
    SELECT vendedor_id INTO vendedor FROM repuestos WHERE id = NEW.repuesto_id;
    
    INSERT INTO mensajes (emisor_id, receptor_id, contenido)
    VALUES (NEW.comprador_id, vendedor, CONCAT('Nueva solicitud para el repuesto ID ', NEW.repuesto_id));
END;
//
DELIMITER ;

-- Transacción para finalizar una venta
DELIMITER //

CREATE PROCEDURE finalizar_venta(IN solicitud_id INT)
BEGIN
    DECLARE cantidad_solicitada INT;
    DECLARE repuesto_id_val INT;
    DECLARE stock_actual INT;
    DECLARE comprador_id_val INT;
    DECLARE vendedor_id_val INT;

    -- Paso 1: Obtener datos de la solicitud (si está pendiente)
    SELECT repuesto_id, cantidad, comprador_id
    INTO repuesto_id_val, cantidad_solicitada, comprador_id_val
    FROM solicitudes
    WHERE id = solicitud_id AND estado = 'pendiente';

    -- Paso 2: Obtener stock actual y vendedor
    SELECT stock, vendedor_id
    INTO stock_actual, vendedor_id_val
    FROM repuestos
    WHERE id = repuesto_id_val;

    -- Paso 3: Verificar si hay stock suficiente
    IF stock_actual >= cantidad_solicitada THEN

        -- Iniciar transacción
        START TRANSACTION;

        -- Descontar stock
        UPDATE repuestos
        SET stock = stock - cantidad_solicitada
        WHERE id = repuesto_id_val;

        -- Marcar la solicitud como aprobada
        UPDATE solicitudes
        SET estado = 'aprobado'
        WHERE id = solicitud_id;

        -- Confirmar la transacción
        COMMIT;

        -- Mostrar IDs involucrados
        SELECT 
            repuesto_id_val AS repuesto_id,
            vendedor_id_val AS vendedor_id,
            comprador_id_val AS comprador_id;

    ELSE
        -- Cancelar si no hay stock suficiente
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stock insuficiente para completar la venta.';
    END IF;
END;
//

DELIMITER ;

-- Índices adicionales para acelerar búsquedas frecuentes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_repuestos_vendedor ON repuestos(vendedor_id);
CREATE INDEX idx_repuestos_categoria ON repuestos(categoria_id);
CREATE INDEX idx_solicitudes_comprador ON solicitudes(comprador_id);
CREATE INDEX idx_mensajes_receptor ON mensajes(receptor_id);