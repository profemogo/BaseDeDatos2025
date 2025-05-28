USE swimmingProject_v1;

-- Trigger para actualizar categoría de edad al insertar un nadador
DELIMITER $$

CREATE TRIGGER after_nadador_update 
AFTER INSERT ON Nadadores 
FOR EACH ROW
BEGIN
    DECLARE edad_actual INT;
    DECLARE categoria_correcta BIGINT;
    
    -- Calcular edad actual
    SET edad_actual = TIMESTAMPDIFF(YEAR, NEW.fecha_nacimiento, CURDATE());
    
    -- Buscar categoría correspondiente
    SELECT id INTO categoria_correcta
    FROM CategoriaEdad
    WHERE edad_actual BETWEEN edad_minima AND edad_maxima
    LIMIT 1;
    
    -- Si no se encuentra categoría, registrar error
    IF categoria_correcta IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se encontró categoría de edad apropiada para el nadador';
    ELSE
        -- Actualizar categoría si es diferente
        IF NEW.categoria_edad_id != categoria_correcta THEN
            UPDATE Nadadores 
            SET categoria_edad_id = categoria_correcta
            WHERE id = NEW.id;
        END IF;
    END IF;
END$$

DELIMITER ;

-- Trigger para manejar cambios en tiempos y records
DELIMITER $$

CREATE TRIGGER after_tiempo_changes 
AFTER UPDATE ON Tiempos
FOR EACH ROW
BEGIN
    -- Variables para obtener información del nadador
    DECLARE v_nadador_id BIGINT;
    DECLARE v_competencia_id BIGINT;
    
    -- Obtener nadador_id y competencia_id desde RegistroCompetencias
    SELECT rc.nadador_id, rc.competencia_id 
    INTO v_nadador_id, v_competencia_id
    FROM RegistroCompetencias rc
    WHERE rc.id = NEW.registro_competencia_id;

    -- Registrar cambios en tiempo
    IF OLD.tiempo != NEW.tiempo THEN
        INSERT INTO historial_cambios (
            tabla_afectada,
            id_registro,
            tipo_cambio,
            campo_modificado,
            valor_anterior,
            valor_nuevo,
            usuario
        ) VALUES (
            'Tiempos',
            NEW.id,
            'UPDATE',
            'tiempo',
            CAST(OLD.tiempo AS CHAR),
            CAST(NEW.tiempo AS CHAR),
            CURRENT_USER()
        );
    END IF;

    -- Verificar y registrar cambios en es_record y tipo_record
    IF OLD.es_record != NEW.es_record OR 
       (OLD.tipo_record != NEW.tipo_record) OR 
       (OLD.tipo_record IS NULL AND NEW.tipo_record IS NOT NULL) OR
       (OLD.tipo_record IS NOT NULL AND NEW.tipo_record IS NULL) THEN
        
        -- Registrar cambio en es_record
        IF OLD.es_record != NEW.es_record THEN
            INSERT INTO historial_cambios (
                tabla_afectada,
                id_registro,
                tipo_cambio,
                campo_modificado,
                valor_anterior,
                valor_nuevo,
                usuario
            ) VALUES (
                'Tiempos',
                NEW.id,
                'UPDATE',
                'es_record',
                IF(OLD.es_record, 'true', 'false'),
                IF(NEW.es_record, 'true', 'false'),
                CURRENT_USER()
            );
        END IF;

        -- Registrar cambio en tipo_record
        IF (OLD.tipo_record != NEW.tipo_record) OR 
           (OLD.tipo_record IS NULL AND NEW.tipo_record IS NOT NULL) OR
           (OLD.tipo_record IS NOT NULL AND NEW.tipo_record IS NULL) THEN
            INSERT INTO historial_cambios (
                tabla_afectada,
                id_registro,
                tipo_cambio,
                campo_modificado,
                valor_anterior,
                valor_nuevo,
                usuario
            ) VALUES (
                'Tiempos',
                NEW.id,
                'UPDATE',
                'tipo_record',
                OLD.tipo_record,
                NEW.tipo_record,
                CURRENT_USER()
            );
        END IF;

        -- Si es un nuevo récord, actualizar la tabla Records
        IF NEW.es_record = 1 AND NEW.tipo_record IS NOT NULL THEN
            -- Insertar nuevo récord
            INSERT INTO Records (
                nadador_id,
                estilo_metraje_id,
                tiempo,
                fecha,
                competencia_id,
                tipo_record
            ) VALUES (
                v_nadador_id,
                NEW.estilo_metraje_id,
                NEW.tiempo,
                CURDATE(),
                v_competencia_id,
                NEW.tipo_record
            );
            
            -- Registrar la creación del nuevo récord
            INSERT INTO historial_cambios (
                tabla_afectada,
                id_registro,
                tipo_cambio,
                campo_modificado,
                valor_anterior,
                valor_nuevo,
                usuario
            ) VALUES (
                'Records',
                LAST_INSERT_ID(),
                'INSERT',
                'nuevo_record',
                NULL,
                CONCAT('Nuevo record ', NEW.tipo_record),
                CURRENT_USER()
            );
        END IF;
    END IF;
END$$

DELIMITER ; 