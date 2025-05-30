-- 1. Obtener la cantidad de estudiantes en un grado específico.
DROP FUNCTION IF EXISTS ContarEstudiantesPorGrado;
DELIMITER //
CREATE FUNCTION ContarEstudiantesPorGrado(p_grado_id INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE total INT;
    SELECT COUNT(estudiante_id) INTO total
    FROM Estudiante
    WHERE grado_id = p_grado_id;
    RETURN IFNULL(total, 0);
END //
DELIMITER ;

-- 2. Verificar si un estudiante tiene correo electrónico registrado.
DROP FUNCTION IF EXISTS EstudianteTieneEmail;
DELIMITER //
CREATE FUNCTION EstudianteTieneEmail(p_estudiante_id INT)
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE tiene_email BOOLEAN;
    SELECT (email IS NOT NULL AND email != '') INTO tiene_email
    FROM Estudiante
    WHERE estudiante_id = p_estudiante_id;
    RETURN IFNULL(tiene_email, FALSE);
END //
DELIMITER ;

-- 3. Obtener el total de asignaturas que un estudiante ha cursado.
DROP FUNCTION IF EXISTS TotalAsignaturasEstudiante;
DELIMITER //
CREATE FUNCTION TotalAsignaturasEstudiante(p_estudiante_id INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE total_asignaturas INT;
    SELECT COUNT(DISTINCT AG.asignatura_id) INTO total_asignaturas
    FROM Nota N
    JOIN AsignaturaGrado AG ON N.asignatura_grado_id = AG.asignatura_grado_id
    WHERE N.estudiante_id = p_estudiante_id;
    RETURN IFNULL(total_asignaturas, 0);
END //
DELIMITER ;

-- 4. Verificar si un profesor imparte clases en un grado específico.
DROP FUNCTION IF EXISTS ProfesorEnGrado;
DELIMITER //
CREATE FUNCTION ProfesorEnGrado(p_profesor_id INT, p_grado_id INT)
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE existe BOOLEAN;
    SELECT EXISTS (SELECT 1 FROM ProfesorGrado WHERE profesor_id = p_profesor_id AND grado_id = p_grado_id) INTO existe;
    RETURN existe;
END //
DELIMITER ;

-- 5. Obtener la cantidad de estudiantes por sección.
DROP FUNCTION IF EXISTS ContarEstudiantesPorSeccion;
DELIMITER //
CREATE FUNCTION ContarEstudiantesPorSeccion(p_seccion_id INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE total INT;
    SELECT COUNT(estudiante_id) INTO total
    FROM Estudiante
    WHERE seccion_id = p_seccion_id;
    RETURN IFNULL(total, 0);
END //
DELIMITER ;

-- 6. Obtener la nota más baja de un estudiante en una asignatura.
DROP FUNCTION IF EXISTS ObtenerNotaMasBaja;
DELIMITER //
CREATE FUNCTION ObtenerNotaMasBaja(p_estudiante_id INT, p_asignatura_id INT)
RETURNS DECIMAL(5, 2)
READS SQL DATA
BEGIN
    DECLARE nota_minima DECIMAL(5, 2);
    SELECT MIN(N.valor_nota) INTO nota_minima
    FROM Nota N
    JOIN AsignaturaGrado AG ON N.asignatura_grado_id = AG.asignatura_grado_id
    WHERE N.estudiante_id = p_estudiante_id AND AG.asignatura_id = p_asignatura_id;
    RETURN IFNULL(nota_minima, 0.00);
END //
DELIMITER ;

-- 7. Contar la cantidad de profesores en una asignatura específica.
DROP FUNCTION IF EXISTS ContarProfesoresPorAsignatura;
DELIMITER //
CREATE FUNCTION ContarProfesoresPorAsignatura(p_asignatura_id INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE total INT;
    SELECT COUNT(DISTINCT profesor_id) INTO total
    FROM ProfesorAsignatura
    WHERE asignatura_id = p_asignatura_id;
    RETURN IFNULL(total, 0);
END //
DELIMITER ;

-- 8. Obtener el promedio de edad de los estudiantes en un grado.
DROP FUNCTION IF EXISTS PromedioEdadPorGrado;
DELIMITER //
CREATE FUNCTION PromedioEdadPorGrado(p_grado_id INT)
RETURNS DECIMAL(5,2)
READS SQL DATA
BEGIN
    DECLARE promedio_edad DECIMAL(5,2);
    SELECT AVG(TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE())) INTO promedio_edad
    FROM Estudiante
    WHERE grado_id = p_grado_id;
    RETURN IFNULL(promedio_edad, 0.00);
END //
DELIMITER ;

-- 9. Verificar si un estudiante tiene notas registradas en una asignatura.
DROP FUNCTION IF EXISTS EstudianteTieneNotasEnAsignatura;
DELIMITER //
CREATE FUNCTION EstudianteTieneNotasEnAsignatura(p_estudiante_id INT, p_asignatura_id INT)
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE existe BOOLEAN;
    SELECT EXISTS (
        SELECT 1 FROM Nota N
        JOIN AsignaturaGrado AG ON N.asignatura_grado_id = AG.asignatura_grado_id
        WHERE N.estudiante_id = p_estudiante_id AND AG.asignatura_id = p_asignatura_id
    ) INTO existe;
    RETURN existe;
END //
DELIMITER ;

-- 10. Obtener el número total de asignaturas registradas en el sistema.
DROP FUNCTION IF EXISTS TotalAsignaturas;
DELIMITER //
CREATE FUNCTION TotalAsignaturas()
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE total INT;
    SELECT COUNT(asignatura_id) INTO total
    FROM Asignatura;
    RETURN IFNULL(total, 0);
END //
DELIMITER ;
