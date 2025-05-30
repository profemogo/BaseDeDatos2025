USE swimmingProject_v1;

-- =============================================
-- Trigger: after_nadador_update
-- Descripción: Se ejecuta después de insertar un nuevo nadador para asignar
-- automáticamente su categoría de edad basada en su fecha de nacimiento.
--
-- Tabla afectada: Nadadores
-- Momento: AFTER INSERT
-- Por cada fila: Sí
--
-- Funcionamiento:
-- 1. Calcula la edad actual del nadador
-- 2. Busca la categoría correspondiente a esa edad
-- 3. Actualiza la categoría si es necesario
--
-- Manejo de errores:
-- - Lanza error si no encuentra una categoría apropiada
-- - Actualiza solo si la categoría es diferente a la asignada
--
-- Campos utilizados:
-- - NEW.fecha_nacimiento: Fecha de nacimiento del nuevo nadador
-- - NEW.categoria_edad_id: Categoría asignada inicialmente
-- - NEW.id: ID del nuevo nadador
-- =============================================
DELIMITER $$

CREATE TRIGGER after_nadador_update 
AFTER INSERT ON Nadadores 
FOR EACH ROW
BEGIN
    DECLARE edad_actual INT;
    DECLARE categoria_correcta BIGINT;
    
    -- Calcular edad actual del nadador
    SET edad_actual = TIMESTAMPDIFF(YEAR, NEW.fecha_nacimiento, CURDATE());
    
    -- Buscar la categoría que corresponde a la edad actual
    SELECT id INTO categoria_correcta
    FROM CategoriaEdad
    WHERE edad_actual BETWEEN edad_minima AND edad_maxima
    LIMIT 1;
    
    -- Validar que exista una categoría apropiada
    IF categoria_correcta IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se encontró categoría de edad apropiada para el nadador';
    ELSE
        -- Actualizar categoría solo si es diferente a la asignada
        IF NEW.categoria_edad_id != categoria_correcta THEN
            UPDATE Nadadores 
            SET categoria_edad_id = categoria_correcta
            WHERE id = NEW.id;
        END IF;
    END IF;
END$$

DELIMITER ;

-- =============================================
-- Trigger: after_tiempo_changes
-- Descripción: Gestiona los cambios en los tiempos de los nadadores, 
-- registra el historial de cambios y maneja los records.
--
-- Tabla afectada: Tiempos
-- Momento: AFTER UPDATE
-- Por cada fila: Sí
--
-- Funcionalidades principales:
-- 1. Registro de cambios en tiempos
-- 2. Seguimiento de cambios en records
-- 3. Actualización automática de la tabla Records
-- 4. Mantenimiento del historial de cambios
--
-- Campos monitoreados:
-- - tiempo: Registro del tiempo logrado
-- - es_record: Indicador de si es un record
-- - tipo_record: Categoría del record (personal/club/regional/nacional/mundial)
--
-- Tablas relacionadas:
-- - RegistroCompetencias: Para obtener datos del nadador y competencia
-- - historial_cambios: Para registro de modificaciones
-- - Records: Para nuevos records establecidos
-- =============================================
DELIMITER $$

CREATE TRIGGER after_tiempo_changes 
AFTER UPDATE ON Tiempos
FOR EACH ROW
BEGIN
    -- Variables para información del nadador y competencia
    DECLARE v_nadador_id BIGINT;
    DECLARE v_competencia_id BIGINT;
    
    -- Obtener datos relacionados del registro de competencias
    SELECT rc.nadador_id, rc.competencia_id 
    INTO v_nadador_id, v_competencia_id
    FROM RegistroCompetencias rc
    WHERE rc.id = NEW.registro_competencia_id;

    -- Registrar modificaciones en el tiempo
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

    -- Control y registro de cambios en records
    IF OLD.es_record != NEW.es_record OR 
       (OLD.tipo_record != NEW.tipo_record) OR 
       (OLD.tipo_record IS NULL AND NEW.tipo_record IS NOT NULL) OR
       (OLD.tipo_record IS NOT NULL AND NEW.tipo_record IS NULL) THEN
        
        -- Registrar cambio en el estado del record
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

        -- Registrar cambio en el tipo de record
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

        -- Gestión de nuevo record
        IF NEW.es_record = 1 AND NEW.tipo_record IS NOT NULL THEN
            -- Registrar el nuevo record en la tabla Records
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
            
            -- Registrar la creación del nuevo record en el historial
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