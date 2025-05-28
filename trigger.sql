-- Lorena Fernandez CI 28.440.154
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--     Crear Triggers de la base de datos
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


-- Trigger para insertar registro en HistorialTransaccion al insertar una nueva transacción
DELIMITER $$
CREATE TRIGGER DespuesInsertarTransaccion
AFTER INSERT ON Transaccion
FOR EACH ROW
BEGIN
    INSERT INTO HistorialTransaccion (transaccion_id, cambio)
    VALUES (NEW.id, CONCAT('Creación de transacción: ', NEW.descripcion));
END $$
DELIMITER ;

-- Trigger para actualizar registro en HistorialTransaccion al actualizar una transacción
DELIMITER $$
CREATE TRIGGER DespuesActualizarTransaccion
AFTER UPDATE ON Transaccion
FOR EACH ROW
BEGIN
    INSERT INTO HistorialTransaccion (transaccion_id, cambio)
    VALUES (NEW.id, CONCAT('Actualización de transacción: ', NEW.descripcion));
END $$
DELIMITER ;

-- Trigger para validar presupuesto superado
DELIMITER $$
CREATE TRIGGER DespuesInsertarTransaccionPresupuesto
AFTER INSERT ON Transaccion
FOR EACH ROW
BEGIN
    DECLARE gasto_actual DECIMAL(12,2);
    DECLARE limite DECIMAL(12,2);
    DECLARE nombre_categoria VARCHAR(50);
    DECLARE periodo_presupuesto VARCHAR(20);
    DECLARE fecha_inicio DATE;
    DECLARE fecha_fin DATE;
    DECLARE mensaje_error VARCHAR(255);

    -- Solo aplica para gastos
    IF NEW.tipo_transaccion_id = 2 THEN
        -- Obtener información del presupuesto
        SELECT p.monto_limite, p.periodo, c.nombre 
        INTO limite, periodo_presupuesto, nombre_categoria
        FROM Presupuesto p
        JOIN Categoria c ON p.categoria_id = c.id
        WHERE p.usuario_id = NEW.usuario_id
          AND p.categoria_id = NEW.categoria_id
        LIMIT 1;

        -- Si existe presupuesto para esta categoría
        IF limite IS NOT NULL THEN
            -- Calcular fechas según el período
            CASE periodo_presupuesto
                WHEN 'Mensual' THEN
                    SET fecha_inicio = DATE_FORMAT(NEW.fecha, '%Y-%m-01');
                    SET fecha_fin = LAST_DAY(NEW.fecha);
                WHEN 'Anual' THEN
                    SET fecha_inicio = DATE_FORMAT(NEW.fecha, '%Y-01-01');
                    SET fecha_fin = DATE_FORMAT(NEW.fecha, '%Y-12-31');
                WHEN 'Semanal' THEN
                    SET fecha_inicio = DATE_SUB(NEW.fecha, INTERVAL WEEKDAY(NEW.fecha) DAY);
                    SET fecha_fin = DATE_ADD(fecha_inicio, INTERVAL 6 DAY);
                ELSE
                    SET mensaje_error = 'Período de presupuesto no válido';
                    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensaje_error;
            END CASE;

            -- Calcular gasto actual incluyendo la transacción actual
            SELECT COALESCE(SUM(monto), 0) + NEW.monto INTO gasto_actual
            FROM Transaccion
            WHERE usuario_id = NEW.usuario_id
              AND categoria_id = NEW.categoria_id
              AND tipo_transaccion_id = 2
              AND fecha BETWEEN fecha_inicio AND fecha_fin;

            -- Verificar si se supera el límite
            IF gasto_actual > limite THEN
                SET mensaje_error = CONCAT(
                    '¡Alerta! Has superado el presupuesto de ', nombre_categoria,
                    '. Límite: ', FORMAT(limite, 2),
                    ', Gastado: ', FORMAT(gasto_actual, 2),
                    ' (', FORMAT((gasto_actual/limite)*100, 1), '% del presupuesto)'
                );
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensaje_error;
            END IF;
        END IF;
    END IF;
END $$
DELIMITER ;