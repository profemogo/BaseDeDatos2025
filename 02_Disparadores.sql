USE GestionNotas

DELIMITER //

-- Validar el valor de la nota antes de Insertar/Actualizar
CREATE TRIGGER trg_Nota_CheckValor
BEFORE INSERT ON Nota
FOR EACH ROW
BEGIN
    IF NEW.valor_nota < 0 OR NEW.valor_nota > 20 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El valor de la nota debe estar entre 0 y 20.';
    END IF;
END //

CREATE TRIGGER trg_Nota_CheckValor_Update
BEFORE UPDATE ON Nota
FOR EACH ROW
BEGIN
    IF NEW.valor_nota < 0 OR NEW.valor_nota > 20 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El valor de la nota debe estar entre 0 y 20.';
    END IF;
END //

-- Convertir email de profesor a minúsculas antes de insertar/actualizar
CREATE TRIGGER trg_Profesor_EmailLowerCase
BEFORE INSERT ON Profesor
FOR EACH ROW
BEGIN
    SET NEW.email = LOWER(NEW.email);
END //

CREATE TRIGGER trg_Profesor_EmailLowerCase_Update
BEFORE UPDATE ON Profesor
FOR EACH ROW
BEGIN
    SET NEW.email = LOWER(NEW.email);
END //

-- Prevenir la eliminación de grados si tienen estudiantes asociados
CREATE TRIGGER trg_Grado_PreventDeleteIfEstudiantes
BEFORE DELETE ON Grado
FOR EACH ROW
BEGIN
    DECLARE num_estudiantes INT;
    SELECT COUNT(*) INTO num_estudiantes FROM Estudiante WHERE grado_id = OLD.grado_id;
    IF num_estudiantes > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar este grado porque tiene estudiantes asociados.';
    END IF;
END //

-- Prevenir la eliminación de asignaturas si están asociadas a grados
CREATE TRIGGER trg_Asignatura_PreventDeleteIfGradoAsociado
BEFORE DELETE ON Asignatura
FOR EACH ROW
BEGIN
    DECLARE num_asig_grado INT;
    SELECT COUNT(*) INTO num_asig_grado FROM AsignaturaGrado WHERE asignatura_id = OLD.asignatura_id;
    IF num_asig_grado > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar esta asignatura porque está asociada a uno o más grados.';
    END IF;
END //

-- Prevenir la eliminación de secciones si tienen estudiantes asociados
CREATE TRIGGER trg_Seccion_PreventDeleteIfEstudiantes
BEFORE DELETE ON Seccion
FOR EACH ROW
BEGIN
    DECLARE num_estudiantes INT;
    SELECT COUNT(*) INTO num_estudiantes FROM Estudiante WHERE seccion_id = OLD.seccion_id;
    IF num_estudiantes > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar esta sección porque tiene estudiantes asociados.';
    END IF;
END //

-- Asegurar que el género del estudiante no sea nulo al insertar
CREATE TRIGGER trg_Estudiante_GeneroNotNull
BEFORE INSERT ON Estudiante
FOR EACH ROW
BEGIN
    IF NEW.genero_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El campo genero_id no puede ser nulo para un estudiante.';
    END IF;
END //

-- Actualizar fecha_nota a la fecha actual si no se proporciona
CREATE TRIGGER trg_Nota_SetFechaActual
BEFORE INSERT ON Nota
FOR EACH ROW
BEGIN
    IF NEW.fecha_nota IS NULL THEN
        SET NEW.fecha_nota = CURDATE();
    END IF;
END //

CREATE TRIGGER trg_Nota_SetFechaActual_Update
BEFORE UPDATE ON Nota
FOR EACH ROW
BEGIN
    IF NEW.fecha_nota IS NULL THEN
        SET NEW.fecha_nota = CURDATE();
    END IF;
END //

-- Validar formato de email de profesor
CREATE TRIGGER trg_Profesor_ValidateEmailFormat
BEFORE INSERT ON Profesor
FOR EACH ROW
BEGIN
    IF NEW.email IS NOT NULL AND NEW.email NOT LIKE '%_@__%.__%' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El formato del email del profesor no es válido.';
    END IF;
END //

CREATE TRIGGER trg_Profesor_ValidateEmailFormat_Update
BEFORE UPDATE ON Profesor
FOR EACH ROW
BEGIN
    IF NEW.email IS NOT NULL AND NEW.email NOT LIKE '%_@__%.__%' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El formato del email del profesor no es válido.';
    END IF;
END //

-- Capitalizar el nombre del estudiante al insertar
CREATE TRIGGER trg_Estudiante_CapitalizeNombre
BEFORE INSERT ON Estudiante
FOR EACH ROW
BEGIN
    SET NEW.nombre = CONCAT(UPPER(SUBSTRING(NEW.nombre, 1, 1)), LOWER(SUBSTRING(NEW.nombre, 2)));
END //

-- Evitar actualizaciones en la fecha de nacimiento de un estudiante
CREATE TRIGGER trg_Estudiante_PreventFechaNacimientoUpdate
BEFORE UPDATE ON Estudiante
FOR EACH ROW
BEGIN
    IF NEW.fecha_nacimiento <=> OLD.fecha_nacimiento = FALSE THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se permite actualizar la fecha de nacimiento de un estudiante.';
    END IF;
END //

DELIMITER ;
