DELIMITER //

-- =============================================
-- SECCIÓN DE LIMPIEZA DE PROCEDIMIENTOS EXISTENTES
-- Esto permite re-ejecutar el script sin errores si los procedimientos ya existen
-- =============================================
DROP PROCEDURE IF EXISTS InscribirEstudiante //
DROP PROCEDURE IF EXISTS ActualizarNota //
DROP PROCEDURE IF EXISTS RegistrarNuevoEstudiante //
DROP PROCEDURE IF EXISTS AsignarAsignaturaGradoProfesor //
DROP PROCEDURE IF EXISTS ObtenerNotasEstudiante //
DROP PROCEDURE IF EXISTS InsertarMultiplesNotas //
DROP PROCEDURE IF EXISTS BorrarNotasAntiguas //

DELIMITER ; -- Restablecer el delimitador temporalmente antes de los CREATE PROCEDURE

DELIMITER //

-- =============================================
-- 1. Procedimiento almacenado para Inscribir/Actualizar un estudiante en una sección y grado
-- =============================================
CREATE PROCEDURE InscribirEstudiante(
    IN p_estudiante_id INT,
    IN p_grado_id INT,
    IN p_seccion_id INT -- CORREGIDO: Se eliminó el "IN" duplicado aquí
)
BEGIN
    DECLARE v_estudiante_existe INT;
    DECLARE v_grado_existe INT;
    DECLARE v_seccion_existe INT;

    SELECT COUNT(*) INTO v_estudiante_existe FROM Estudiante WHERE estudiante_id = p_estudiante_id;
    SELECT COUNT(*) INTO v_grado_existe FROM Grado WHERE grado_id = p_grado_id;
    SELECT COUNT(*) INTO v_seccion_existe FROM Seccion WHERE seccion_id = p_seccion_id;

    IF v_estudiante_existe = 0 THEN
        SELECT 'Error: El ID del estudiante no existe.' AS Resultado;
    ELSEIF v_grado_existe = 0 THEN
        SELECT 'Error: El ID del grado no existe.' AS Resultado;
    ELSEIF v_seccion_existe = 0 THEN
        SELECT 'Error: El ID de la sección no existe.' AS Resultado;
    ELSE
        UPDATE Estudiante
        SET grado_id = p_grado_id, seccion_id = p_seccion_id
        WHERE estudiante_id = p_estudiante_id;
        SELECT 'Estudiante inscrito/actualizado exitosamente.' AS Resultado;
    END IF;

END //

-- =============================================
-- 2. Procedimiento para Actualizar una nota existente
-- =============================================
CREATE PROCEDURE ActualizarNota(
    IN p_nota_id INT,
    IN p_nuevo_valor_nota DECIMAL(5,2),
    IN p_nueva_fecha_nota DATE
)
BEGIN
    DECLARE v_nota_existe INT;

    SELECT COUNT(*) INTO v_nota_existe FROM Nota WHERE nota_id = p_nota_id;

    IF v_nota_existe = 0 THEN
        SELECT 'Error: La nota especificada no existe.' AS Resultado;
    ELSE
        UPDATE Nota
        SET valor_nota = p_nuevo_valor_nota, fecha_nota = p_nueva_fecha_nota
        WHERE nota_id = p_nota_id;
        SELECT 'Nota actualizada exitosamente.' AS Resultado;
    END IF;

END //

-- =============================================
-- 3. Procedimiento para Registrar un nuevo estudiante
-- =============================================
CREATE PROCEDURE RegistrarNuevoEstudiante(
    IN p_nombre VARCHAR(255),
    IN p_apellido VARCHAR(255),
    IN p_fecha_nacimiento DATE,
    IN p_genero_id INT,
    IN p_grado_id INT,
    IN p_seccion_id INT,
    IN p_email VARCHAR(255)
)
BEGIN
    DECLARE v_genero_existe INT;
    DECLARE v_grado_existe INT;
    DECLARE v_seccion_existe INT;
    DECLARE v_email_existe INT;

    SELECT COUNT(*) INTO v_genero_existe FROM Genero WHERE genero_id = p_genero_id;
    SELECT COUNT(*) INTO v_grado_existe FROM Grado WHERE grado_id = p_grado_id;
    SELECT COUNT(*) INTO v_seccion_existe FROM Seccion WHERE seccion_id = p_seccion_id;
    SELECT COUNT(*) INTO v_email_existe FROM Estudiante WHERE email = p_email AND p_email IS NOT NULL;

    IF v_genero_existe = 0 THEN
        SELECT 'Error: El ID de género no existe.' AS Resultado;
    ELSEIF v_grado_existe = 0 THEN
        SELECT 'Error: El ID de grado no existe.' AS Resultado;
    ELSEIF v_seccion_existe = 0 THEN
        SELECT 'Error: El ID de sección no existe.' AS Resultado;
    ELSEIF v_email_existe > 0 THEN
        SELECT 'Error: El correo electrónico ya está registrado para otro estudiante.' AS Resultado;
    ELSE
        INSERT INTO Estudiante (nombre, apellido, fecha_nacimiento, genero_id, grado_id, seccion_id, email)
        VALUES (p_nombre, p_apellido, p_fecha_nacimiento, p_genero_id, p_grado_id, p_seccion_id, p_email);
        SELECT 'Estudiante registrado exitosamente.' AS Resultado, LAST_INSERT_ID() AS nuevo_estudiante_id;
    END IF;
END //

-- =============================================
-- 4. Procedimiento para Asignar una asignatura a un grado y un profesor
-- =============================================
CREATE PROCEDURE AsignarAsignaturaGradoProfesor(
    IN p_asignatura_id INT,
    IN p_grado_id INT,
    IN p_profesor_id INT
)
BEGIN
    DECLARE v_asignatura_existe INT;
    DECLARE v_grado_existe INT;
    DECLARE v_profesor_existe INT;
    DECLARE v_asignacion_existe INT;

    SELECT COUNT(*) INTO v_asignatura_existe FROM Asignatura WHERE asignatura_id = p_asignatura_id;
    SELECT COUNT(*) INTO v_grado_existe FROM Grado WHERE grado_id = p_grado_id;
    SELECT COUNT(*) INTO v_profesor_existe FROM Profesor WHERE profesor_id = p_profesor_id;
    SELECT COUNT(*) INTO v_asignacion_existe FROM AsignaturaGrado
    WHERE asignatura_id = p_asignatura_id AND grado_id = p_grado_id AND profesor_id = p_profesor_id;

    IF v_asignatura_existe = 0 THEN
        SELECT 'Error: El ID de la asignatura no existe.' AS Resultado;
    ELSEIF v_grado_existe = 0 THEN
        SELECT 'Error: El ID del grado no existe.' AS Resultado;
    ELSEIF v_profesor_existe = 0 THEN
        SELECT 'Error: El ID del profesor no existe.' AS Resultado;
    ELSEIF v_asignacion_existe > 0 THEN
        SELECT 'Error: Esta asignatura ya está asignada a este grado con este profesor.' AS Resultado;
    ELSE
        INSERT INTO AsignaturaGrado (asignatura_id, grado_id, profesor_id)
        VALUES (p_asignatura_id, p_grado_id, p_profesor_id);
        SELECT 'Asignación de asignatura-grado-profesor exitosa.' AS Resultado, LAST_INSERT_ID() AS nueva_asignacion_id;
    END IF;

END //

-- =============================================
-- 5. Procedimiento para Obtener todas las notas de un estudiante
-- =============================================
CREATE PROCEDURE ObtenerNotasEstudiante(
    IN p_estudiante_id INT
)
BEGIN
    SELECT
        n.nota_id,
        a.nombre_asignatura,
        CONCAT(p.nombre, ' ', p.apellido) AS nombre_profesor,
        n.valor_nota,
        n.fecha_nota
    FROM Nota n
    JOIN Asignatura a ON n.asignatura_id = a.asignatura_id
    JOIN Profesor p ON n.profesor_id = p.profesor_id
    WHERE n.estudiante_id = p_estudiante_id
    ORDER BY n.fecha_nota DESC, a.nombre_asignatura;

END //

-- =============================================
-- 6. Procedimiento para Insertar múltiples notas para un estudiante desde un JSON
-- Requiere MySQL 5.7+ para funciones JSON
-- =============================================
CREATE PROCEDURE InsertarMultiplesNotas(
    IN p_estudiante_id INT,
    IN p_profesor_id INT,
    IN p_asignaturas_notas JSON                     -- Formato esperado: [{"asignatura_id": 1, "valor_nota": 18.5}]
)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE num_asignaturas INT;
    DECLARE v_estudiante_existe INT;
    DECLARE v_profesor_existe INT;
    DECLARE v_current_asignatura_id INT;
    DECLARE v_current_valor_nota DECIMAL(5,2);
    DECLARE v_error_message VARCHAR(255);
    DECLARE v_success_flag BOOLEAN DEFAULT TRUE;
    DECLARE v_json_type_check VARCHAR(50);

    -- Verificar existencia de estudiante y profesor
    SELECT COUNT(*) INTO v_estudiante_existe FROM Estudiante WHERE estudiante_id = p_estudiante_id;
    SELECT COUNT(*) INTO v_profesor_existe FROM Profesor WHERE profesor_id = p_profesor_id;

    IF v_estudiante_existe = 0 THEN
        SELECT 'Error: El ID del estudiante no existe.' AS Resultado;
        SET v_success_flag = FALSE;
    ELSEIF v_profesor_existe = 0 THEN
        SELECT 'Error: El ID del profesor no existe.' AS Resultado;
        SET v_success_flag = FALSE;
    ELSEIF JSON_TYPE(p_asignaturas_notas) != 'ARRAY' THEN
        SELECT 'Error: El parámetro p_asignaturas_notas debe ser un array JSON válido.' AS Resultado;
        SET v_success_flag = FALSE;
    ELSE
        SET num_asignaturas = JSON_LENGTH(p_asignaturas_notas);

        WHILE i < num_asignaturas AND v_success_flag DO
            -- Extraer valores. Usamos CAST para asegurar el tipo y forzar el error si la conversión falla.
            SET v_current_asignatura_id = CAST(JSON_UNQUOTE(JSON_EXTRACT(p_asignaturas_notas, CONCAT('$[', i, '].asignatura_id'))) AS UNSIGNED);
            SET v_current_valor_nota = CAST(JSON_UNQUOTE(JSON_EXTRACT(p_asignaturas_notas, CONCAT('$[', i, '].valor_nota'))) AS DECIMAL(5,2));

            -- Comprobar si la extracción de asignatura_id resultó en NULL o 0
            IF v_current_asignatura_id IS NULL OR v_current_asignatura_id = 0 THEN
                SET v_error_message = CONCAT('Error: asignatura_id en el índice ', i, ' no es un número válido o está ausente en el JSON.');
                SELECT v_error_message AS Resultado;
                SET v_success_flag = FALSE;
            END IF;

            -- Comprobar si la extracción de valor_nota resultó en NULL o un tipo no numérico.
            SET v_json_type_check = JSON_TYPE(JSON_EXTRACT(p_asignaturas_notas, CONCAT('$[', i, '].valor_nota')));
            IF v_success_flag AND (v_current_valor_nota IS NULL AND v_json_type_check != 'NULL' AND v_json_type_check NOT IN ('INTEGER', 'DECIMAL', 'DOUBLE')) THEN
                 -- La condición 'v_current_valor_nota = 0.0' era problemática si el valor legitimo era 0.0.
                 -- Nos centramos en si es NULL y no es un tipo numérico válido en el JSON.
                SET v_error_message = CONCAT('Error: valor_nota en el índice ', i, ' no es un número válido o está ausente en el JSON.');
                SELECT v_error_message AS Resultado;
                SET v_success_flag = FALSE;
            END IF;

            -- Validar que la asignatura_id exista en la tabla Asignatura
            IF v_success_flag AND NOT EXISTS (SELECT 1 FROM Asignatura WHERE asignatura_id = v_current_asignatura_id) THEN
                SET v_error_message = CONCAT('Error: La asignatura_id ', v_current_asignatura_id, ' en el índice ', i, ' no existe en la base de datos.');
                SELECT v_error_message AS Resultado;
                SET v_success_flag = FALSE;
            END IF;

            -- Si no hubo errores hasta ahora, insertar la nota
            IF v_success_flag THEN
                INSERT INTO Nota (estudiante_id, asignatura_id, profesor_id, valor_nota, fecha_nota)
                VALUES (
                    p_estudiante_id,
                    v_current_asignatura_id,
                    p_profesor_id,
                    v_current_valor_nota,
                    CURDATE()
                );
                SET i = i + 1;
            END IF;
        END WHILE;

        -- El mensaje de éxito solo se muestra si todo el proceso fue exitoso
        IF v_success_flag THEN
            SELECT 'Notas insertadas exitosamente.' AS Resultado;
        END IF;

    END IF;
END //


-- =============================================
-- 7. Procedimiento para borrar notas de más de 12 meses de antigüedad.
-- =============================================
CREATE PROCEDURE BorrarNotasAntiguas()
BEGIN
    DECLARE notas_eliminadas INT;

    DELETE FROM Nota
    WHERE fecha_nota < DATE_SUB(CURDATE(), INTERVAL 12 MONTH);

    SET notas_eliminadas = ROW_COUNT();

    SELECT CONCAT('Se han eliminado ', notas_eliminadas, ' notas con más de 12 meses de antigüedad.') AS Resultado;
END //

DELIMITER ;