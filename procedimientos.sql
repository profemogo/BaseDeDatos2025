-- Lorena Fernandez CI 28.440.154
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--     Crear Procedimientos de la base de datos
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

-- Procedimiento para registrar una nueva transacción con historial 
DELIMITER $$
CREATE PROCEDURE RegistrarTransaccion(
    IN p_usuario_id INT,
    IN p_tipo_transaccion_id INT,
    IN p_cuenta_bancaria_id INT,
    IN p_monto DECIMAL(12,2),
    IN p_fecha TIMESTAMP,
    IN p_categoria_id INT,
    IN p_descripcion TEXT
)
BEGIN
    DECLARE last_id INT;
    START TRANSACTION;
        INSERT INTO Transaccion (usuario_id, tipo_transaccion_id, cuenta_bancaria_id, monto, fecha, categoria_id, descripcion)
        VALUES (p_usuario_id, p_tipo_transaccion_id, p_cuenta_bancaria_id, p_monto, p_fecha, p_categoria_id, p_descripcion);
        SET last_id = LAST_INSERT_ID();
        INSERT INTO HistorialTransaccion (transaccion_id, cambio)
        VALUES (last_id, CONCAT('Creación de transacción: ', p_descripcion));
    COMMIT;
END $$
DELIMITER ;

-- Procedimiento para transferir entre cuentas del mismo usuario
DELIMITER $$
CREATE PROCEDURE TransferirEntreCuentas(
    IN p_usuario_id INT,
    IN p_cuenta_origen INT,
    IN p_cuenta_destino INT,
    IN p_monto DECIMAL(12,2),
    IN p_descripcion TEXT
)
BEGIN
    DECLARE id_gasto INT;
    DECLARE id_ingreso INT;
    START TRANSACTION;
        -- Registrar gasto en cuenta origen
        INSERT INTO Transaccion (usuario_id, tipo_transaccion_id, cuenta_bancaria_id, monto, fecha, categoria_id, descripcion)
        VALUES (p_usuario_id, 2, p_cuenta_origen, p_monto, NOW(), NULL, CONCAT('Transferencia a cuenta ', p_cuenta_destino, ': ', p_descripcion));
        SET id_gasto = LAST_INSERT_ID();
        INSERT INTO HistorialTransaccion (transaccion_id, cambio)
        VALUES (id_gasto, 'Transferencia salida');

        -- Registrar ingreso en cuenta destino
        INSERT INTO Transaccion (usuario_id, tipo_transaccion_id, cuenta_bancaria_id, monto, fecha, categoria_id, descripcion)
        VALUES (p_usuario_id, 1, p_cuenta_destino, p_monto, NOW(), NULL, CONCAT('Transferencia desde cuenta ', p_cuenta_origen, ': ', p_descripcion));
        SET id_ingreso = LAST_INSERT_ID();
        INSERT INTO HistorialTransaccion (transaccion_id, cambio)
        VALUES (id_ingreso, 'Transferencia entrada');
    COMMIT;
END $$
DELIMITER ;
