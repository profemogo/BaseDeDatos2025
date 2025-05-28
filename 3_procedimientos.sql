USE swimmingProject_v1;

-- Procedimiento para actualizar categorías de edad
DELIMITER $$

CREATE PROCEDURE actualizar_categorias_edad()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE nadador_id BIGINT;
    DECLARE fecha_nac DATE;
    DECLARE cat_actual BIGINT;
    DECLARE edad_actual INT;
    DECLARE categoria_correcta BIGINT;
    
    -- Variable para manejo de errores
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- Iniciar transacción
    START TRANSACTION;
    
    -- Declarar cursor
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
        
        -- Calcular edad actual
        SET edad_actual = TIMESTAMPDIFF(YEAR, fecha_nac, CURDATE());
        
        -- Buscar categoría correcta
        SELECT id INTO categoria_correcta
        FROM CategoriaEdad
        WHERE edad_actual BETWEEN edad_minima AND edad_maxima
        LIMIT 1;
        
        -- Actualizar si es necesario y si existe una categoría válida
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

-- Procedimiento para registrar nadador en competencia
DELIMITER $$

CREATE PROCEDURE registrar_nadador_competencia(
    IN p_nadador_id BIGINT,
    IN p_competencia_id BIGINT,
    IN p_serie_id BIGINT,
    IN p_carril INT
)
BEGIN
    -- Variables para validaciones
    DECLARE v_categoria_nadador BIGINT;
    DECLARE v_genero_nadador BIGINT;
    DECLARE v_categoria_serie BIGINT;
    DECLARE v_genero_serie BIGINT;
    DECLARE v_carril_ocupado INT;
    DECLARE v_fecha_competencia DATE;
    DECLARE v_error_msg TEXT;
    
    -- Variable para manejo de errores
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- Iniciar transacción
    START TRANSACTION;
    
    -- 1. Verificar que la competencia existe y está vigente
    SELECT fecha_inicio INTO v_fecha_competencia
    FROM Competencias 
    WHERE id = p_competencia_id 
    AND fecha_inicio >= CURDATE()
    FOR UPDATE;
    
    IF v_fecha_competencia IS NULL THEN
        SET v_error_msg = 'La competencia no existe o ya ha pasado';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_error_msg;
    END IF;

    -- 2. Obtener datos del nadador
    SELECT categoria_edad_id, genero_id 
    INTO v_categoria_nadador, v_genero_nadador
    FROM Nadadores
    WHERE id = p_nadador_id
    FOR UPDATE;
    
    IF v_categoria_nadador IS NULL THEN
        SET v_error_msg = 'El nadador no existe';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_error_msg;
    END IF;

    -- 3. Verificar que la serie corresponde a la categoría y género del nadador
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

    -- 4. Verificar que el carril esté disponible
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

    -- 5. Verificar que el nadador no esté ya inscrito en la misma serie
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

    -- 6. Realizar la inscripción
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