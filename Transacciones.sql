SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;

-- Insertar consulta
INSERT INTO Consulta (paciente_id, medico_id, fecha, motivo_consulta)
VALUES (1, 1, NOW(), 'Dolor de cabeza persistente');

-- Obtener el ID de la consulta
SET @consulta_id = LAST_INSERT_ID();

-- Insertar receta asociada
INSERT INTO Recipe (consulta_id, fecha)
VALUES (@consulta_id, NOW());

-- Obtener ID de receta
SET @recipe_id = LAST_INSERT_ID();

-- Insertar descripción de medicamentos
INSERT INTO DescripcionReceta (recipe_id, medicamento_id, dosis, frecuencia)
VALUES (@recipe_id, 1, '500mg', 'Cada 8 horas');

COMMIT;






DELIMITER $$

CREATE PROCEDURE RegistrarConsultaCompleta (
    IN p_paciente_id INT,
    IN p_medico_id INT,
    IN p_motivo TEXT,
    IN p_medicamento_id INT,
    IN p_dosis VARCHAR(50),
    IN p_frecuencia VARCHAR(50)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Rollback si hay error
        ROLLBACK;
    END;

    -- Nivel de aislamiento y transacción
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    START TRANSACTION;

    -- Insertar consulta
    INSERT INTO Consulta (paciente_id, medico_id, fecha, motivo_consulta)
    VALUES (p_paciente_id, p_medico_id, NOW(), p_motivo);

    SET @consulta_id = LAST_INSERT_ID();

    -- Insertar receta
    INSERT INTO Recipe (consulta_id, fecha)
    VALUES (@consulta_id, NOW());

    SET @recipe_id = LAST_INSERT_ID();

    -- Insertar detalle de medicamento
    INSERT INTO DescripcionReceta (recipe_id, medicamento_id, dosis, frecuencia)
    VALUES (@recipe_id, p_medicamento_id, p_dosis, p_frecuencia);

    COMMIT;
END$$

DELIMITER ;


CALL RegistrarConsultaCompleta(1, 1, 'Dolor de cabeza', 1, '500mg', 'Cada 8 horas');

