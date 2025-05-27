-- Lorena Fernandez CI 28.440.154
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--     Crear Triggers de la base de datos
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


-- Trigger para insertar registro en HistorialTransaccion al insertar una nueva transacción
DELIMITER $$
CREATE TRIGGER despues_insertar_transaccion
AFTER INSERT ON Transaccion
FOR EACH ROW
BEGIN
    INSERT INTO HistorialTransaccion (transaccion_id, cambio)
    VALUES (NEW.id, CONCAT('Creación de transacción: ', NEW.descripcion));
END $$
DELIMITER ;

-- Trigger para actualizar registro en HistorialTransaccion al actualizar una transacción
DELIMITER $$
CREATE TRIGGER despues_actualizar_transaccion
AFTER UPDATE ON Transaccion
FOR EACH ROW
BEGIN
    INSERT INTO HistorialTransaccion (transaccion_id, cambio)
    VALUES (NEW.id, CONCAT('Actualización de transacción: ', NEW.descripcion));
END $$
DELIMITER ;


-- Trigger para validar fecha futura en meta
DELIMITER $$
CREATE TRIGGER antes_insertar_meta
BEFORE INSERT ON Meta
FOR EACH ROW
BEGIN
    IF NEW.fecha_objetivo <= CURRENT_DATE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La fecha de la meta debe ser futura';
    END IF;
END $$
DELIMITER ;


-- Trigger para alerta de presupuesto superado
DELIMITER $$
CREATE TRIGGER despues_insertar_transaccion_presupuesto
AFTER INSERT ON Transaccion
FOR EACH ROW
BEGIN
    DECLARE gasto_actual DECIMAL(12,2);
    DECLARE limite DECIMAL(12,2);

    -- Solo aplica para gastos
    IF NEW.tipo_transaccion_id = 2 THEN
        SELECT COALESCE(SUM(monto),0) INTO gasto_actual
        FROM Transaccion
        WHERE usuario_id = NEW.usuario_id
          AND categoria_id = NEW.categoria_id
          AND tipo_transaccion_id = 2;

        SELECT monto_limite INTO limite
        FROM Presupuesto
        WHERE usuario_id = NEW.usuario_id
          AND categoria_id = NEW.categoria_id
        LIMIT 1;

        IF limite IS NOT NULL AND gasto_actual > limite THEN
            INSERT INTO AlertaPresupuesto (usuario_id, categoria_id, mensaje)
            VALUES (NEW.usuario_id, NEW.categoria_id, CONCAT('¡Alerta! Has superado el presupuesto de la categoría ', NEW.categoria_id));
        END IF;
    END IF;
END $$
DELIMITER ;