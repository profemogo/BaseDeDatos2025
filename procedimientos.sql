USE swimmingProject_v1;

-- =============================================
-- Procedimiento: actualizar_categorias_edad
-- Descripción: Actualiza automáticamente las categorías de edad de todos los nadadores
-- basándose en su fecha de nacimiento actual.
--
-- Funcionamiento:
-- 1. Utiliza un cursor para procesar cada nadador
-- 2. Calcula la edad actual de cada nadador
-- 3. Busca la categoría correspondiente a la edad
-- 4. Actualiza la categoría si es necesario
--
-- Manejo de errores:
-- - Utiliza transacciones para garantizar la integridad
-- - Maneja excepciones SQL para rollback en caso de error
--
-- Uso: CALL actualizar_categorias_edad();
-- =============================================
DELIMITER $$

CREATE PROCEDURE actualizar_categorias_edad()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE nadador_id BIGINT;
    DECLARE fecha_nac DATE;
    DECLARE cat_actual BIGINT;
    DECLARE edad_actual INT;
    DECLARE categoria_correcta BIGINT;
    
    -- Manejador de errores para garantizar rollback en caso de excepción
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- Iniciar transacción 
    START TRANSACTION;
    
    -- Cursor para procesar todos los nadadores
    DECLARE cur CURSOR FOR 
        SELECT id, fecha_nacimiento, categoria_edad_id 
        FROM Nadadores
        FOR UPDATE;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cur;
    
    read_loop: LOOP
        FETCH cur INTO nadador_id, fecha_nac, cat_actual;
        
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Calcular edad actual del nadador
        SET edad_actual = TIMESTAMPDIFF(YEAR, fecha_nac, CURDATE());
        
        -- Buscar la categoría que corresponde a la edad actual
        SELECT id INTO categoria_correcta
        FROM CategoriaEdad
        WHERE edad_actual BETWEEN edad_minima AND edad_maxima
        LIMIT 1;
        
        -- Actualizar solo si es necesario y existe una categoría válida
        IF categoria_correcta IS NOT NULL AND categoria_correcta != cat_actual THEN
            UPDATE Nadadores 
            SET categoria_edad_id = categoria_correcta
            WHERE id = nadador_id;
        END IF;
    END LOOP;
    
    CLOSE cur;
    
    COMMIT;
END$$

DELIMITER ;

-- =============================================
-- Procedimiento: registrar_nadador_competencia
-- Descripción: Registra un nadador en una serie específica de una competencia
--
-- Parámetros:
--   p_nadador_id: ID del nadador a registrar
--   p_competencia_id: ID de la competencia
--   p_serie_id: ID de la serie específica
--   p_carril: Número de carril asignado
--
-- Validaciones:
-- 1. Competencia existente y vigente
-- 2. Nadador existente
-- 3. Correspondencia de categoría y género
-- 4. Disponibilidad del carril
-- 5. No duplicidad de inscripción
--
-- Manejo de errores:
-- - Utiliza transacciones para garantizar la integridad
-- - Validaciones específicas con mensajes de error claros
-- - Rollback automático en caso de error
--
-- Uso: CALL registrar_nadador_competencia(1, 1, 1, 4);
-- =============================================
DELIMITER $$

CREATE PROCEDURE registrar_nadador_competencia(
    IN p_nadador_id BIGINT,
    IN p_competencia_id BIGINT,
    IN p_serie_id BIGINT,
    IN p_carril INT
)
BEGIN
    -- Variables para almacenar datos de validación
    DECLARE v_categoria_nadador BIGINT;
    DECLARE v_genero_nadador BIGINT;
    DECLARE v_categoria_serie BIGINT;
    DECLARE v_genero_serie BIGINT;
    DECLARE v_carril_ocupado INT;
    DECLARE v_fecha_competencia DATE;
    DECLARE v_error_msg TEXT;
    
    -- Manejador de errores para garantizar rollback
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- Iniciar transacción para garantizar consistencia
    START TRANSACTION;
    
    -- 1. Validación: Competencia existe y está vigente
    SELECT fecha_inicio INTO v_fecha_competencia
    FROM Competencias 
    WHERE id = p_competencia_id 
    AND fecha_inicio >= CURDATE()
    FOR UPDATE;
    
    IF v_fecha_competencia IS NULL THEN
        SET v_error_msg = 'La competencia no existe o ya ha pasado';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_error_msg;
    END IF;

    -- 2. Validación: Nadador existe y obtención de sus datos
    SELECT categoria_edad_id, genero_id 
    INTO v_categoria_nadador, v_genero_nadador
    FROM Nadadores
    WHERE id = p_nadador_id
    FOR UPDATE;
    
    IF v_categoria_nadador IS NULL THEN
        SET v_error_msg = 'El nadador no existe';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_error_msg;
    END IF;

    -- 3. Validación: Serie corresponde a categoría y género
    SELECT categoria_edad_id, genero_id 
    INTO v_categoria_serie, v_genero_serie
    FROM Series
    WHERE id = p_serie_id
    FOR UPDATE;
    
    IF v_categoria_serie != v_categoria_nadador THEN
        SET v_error_msg = 'La categoría del nadador no corresponde a la serie';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_error_msg;
    END IF;
    
    IF v_genero_serie != v_genero_nadador THEN
        SET v_error_msg = 'El género del nadador no corresponde a la serie';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_error_msg;
    END IF;

    -- 4. Validación: Carril disponible
    SELECT COUNT(*) INTO v_carril_ocupado
    FROM RegistroCompetencias
    WHERE serie_id = p_serie_id 
    AND carril = p_carril
    AND estado != 'retirado'
    FOR UPDATE;
    
    IF v_carril_ocupado > 0 THEN
        SET v_error_msg = 'El carril ya está ocupado';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_error_msg;
    END IF;

    -- 5. Validación: Nadador no inscrito previamente
    SELECT COUNT(*) INTO v_carril_ocupado
    FROM RegistroCompetencias
    WHERE serie_id = p_serie_id 
    AND nadador_id = p_nadador_id
    AND estado != 'retirado'
    FOR UPDATE;
    
    IF v_carril_ocupado > 0 THEN
        SET v_error_msg = 'El nadador ya está inscrito en esta serie';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_error_msg;
    END IF;

    -- 6. Registro final: Inscripción del nadador
    INSERT INTO RegistroCompetencias (
        nadador_id,
        competencia_id,
        serie_id,
        carril,
        estado
    ) VALUES (
        p_nadador_id,
        p_competencia_id,
        p_serie_id,
        p_carril,
        'inscrito'
    );

    COMMIT;
END$$

DELIMITER ; 