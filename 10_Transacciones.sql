-- =============================================
-- TRANSACCIONES SQL (20 Ejemplos)
-- =============================================

-- T1: Insertar un nuevo estudiante
START TRANSACTION;
    INSERT INTO Estudiante (nombre, apellido, fecha_nacimiento, genero_id, grado_id, seccion_id, email)
    VALUES (
        'Sofía',
        'Ruiz',
        '2011-02-28',
        (SELECT genero_id FROM Genero WHERE descripcion = 'Femenino'),
        (SELECT grado_id FROM Grado WHERE nombre_grado = '1er Grado'),
        (SELECT seccion_id FROM Seccion WHERE nombre_seccion = 'A'),
        'sofia.ruiz@example.com'
    );
    SELECT 'T1: Estudiante Sofía Ruiz insertado.' AS Mensaje;
COMMIT;

-- T2: Actualizar el email y teléfono de un profesor
START TRANSACTION;
    UPDATE Profesor
    SET email = 'ana.perez.new@email.com', telefono = '0412-1112233'
    WHERE nombre = 'Ana' AND apellido = 'Pérez';
    SELECT 'T2: Email y teléfono de Ana Pérez actualizados.' AS Mensaje;
COMMIT;

-- T3: Eliminar una asignatura y sus notas y asignaciones (si existen)
START TRANSACTION;
    DELETE FROM Nota WHERE asignatura_id = (SELECT asignatura_id FROM Asignatura WHERE nombre_asignatura = 'Arte');
    DELETE FROM AsignaturaGrado WHERE asignatura_id = (SELECT asignatura_id FROM Asignatura WHERE nombre_asignatura = 'Arte');
    DELETE FROM Asignatura WHERE nombre_asignatura = 'Arte';
    SELECT 'T3: Asignatura "Arte" y sus dependencias eliminadas.' AS Mensaje;
COMMIT;

-- T4: Actualizar el grado y sección de un estudiante
START TRANSACTION;
    UPDATE Estudiante
    SET
        grado_id = (SELECT grado_id FROM Grado WHERE nombre_grado = '3er Grado'),
        seccion_id = (SELECT seccion_id FROM Seccion WHERE nombre_seccion = 'B')
    WHERE nombre = 'Camila' AND apellido = 'Silva';
    SELECT 'T4: Camila Silva reasignada a 3er Grado, Sección B.' AS Mensaje;
COMMIT;

-- T5: Insertar una nueva asignatura
START TRANSACTION;
    INSERT INTO Asignatura (nombre_asignatura)
    VALUES ('Literatura');
    SELECT 'T5: Asignatura "Literatura" insertada.' AS Mensaje;
COMMIT;

-- T6: Insertar una nueva nota para un estudiante
START TRANSACTION;
    INSERT INTO Nota (estudiante_id, asignatura_id, profesor_id, valor_nota, fecha_nota)
    VALUES (
        (SELECT estudiante_id FROM Estudiante WHERE nombre = 'Pedro' AND apellido = 'Ramírez'),
        (SELECT asignatura_id FROM Asignatura WHERE nombre_asignatura = 'Matemáticas'),
        (SELECT profesor_id FROM Profesor WHERE nombre = 'Juan' AND apellido = 'García'),
        19.0,
        CURDATE()
    );
    SELECT 'T6: Nueva nota para Pedro Ramírez en Matemáticas.' AS Mensaje;
COMMIT;

-- T7: Actualizar el teléfono de un profesor si existe (UPDATE afectará 0 filas si no existe)
START TRANSACTION;
    UPDATE Profesor
    SET telefono = '0412-9998877'
    WHERE nombre = 'Juan' AND apellido = 'García';
    SELECT CONCAT('T7: Teléfono de Juan García actualizado. Filas afectadas: ', ROW_COUNT()) AS Mensaje;
COMMIT;

-- T8: Insertar un nuevo grado
START TRANSACTION;
    INSERT INTO Grado (nombre_grado)
    VALUES ('7mo Grado');
    SELECT 'T8: Nuevo grado "7mo Grado" insertado.' AS Mensaje;
COMMIT;

-- T9: Actualizar el nombre de una sección
START TRANSACTION;
    UPDATE Seccion
    SET nombre_seccion = 'Sección E'
    WHERE nombre_seccion = 'D';
    SELECT 'T9: Sección D actualizada a Sección E.' AS Mensaje;
COMMIT;

-- T10: Validar si un estudiante tiene notas en una asignatura específica (solo consulta)
START TRANSACTION;
    SET @estudiante_id = (SELECT estudiante_id FROM Estudiante WHERE nombre = 'Laura' AND apellido = 'Flores');
    SET @asignatura_id = (SELECT asignatura_id FROM Asignatura WHERE nombre_asignatura = 'Lenguaje');
    SELECT CONCAT('T10: Laura Flores tiene ', COUNT(*), ' notas en Lenguaje.') AS Mensaje
    FROM Nota WHERE estudiante_id = @estudiante_id AND asignatura_id = @asignatura_id;
COMMIT;

-- T11: Insertar una nueva asignación de asignatura a grado y profesor
START TRANSACTION;
    INSERT INTO AsignaturaGrado (asignatura_id, grado_id, profesor_id)
    VALUES (
        (SELECT asignatura_id FROM Asignatura WHERE nombre_asignatura = 'Literatura'),
        (SELECT grado_id FROM Grado WHERE nombre_grado = '6to Grado'),
        (SELECT profesor_id FROM Profesor WHERE nombre = 'Carlos' AND apellido = 'Rodríguez')
    );
    SELECT 'T11: Asignatura Literatura asignada a 6to Grado con Carlos Rodríguez.' AS Mensaje;
COMMIT;

-- T12: Actualizar la fecha de nacimiento de un estudiante
START TRANSACTION;
    UPDATE Estudiante
    SET fecha_nacimiento = '2009-01-01'
    WHERE nombre = 'Isabella' AND apellido = 'Ortega';
    SELECT 'T12: Fecha de nacimiento de Isabella Ortega actualizada.' AS Mensaje;
COMMIT;

-- T13: Eliminar todas las notas de una asignatura específica
START TRANSACTION;
    SET @asignatura_id_borrar = (SELECT asignatura_id FROM Asignatura WHERE nombre_asignatura = 'Educación Física');
    DELETE FROM Nota WHERE asignatura_id = @asignatura_id_borrar;
    SELECT 'T13: Todas las notas de Educación Física eliminadas. Filas afectadas: ' AS Mensaje;
COMMIT;

-- T14: Insertar un nuevo profesor
START TRANSACTION;
    INSERT INTO Profesor (nombre, apellido, email, telefono)
    VALUES ('Martín', 'Soto', 'martin.soto@example.com', '0414-5554433');
    SELECT 'T14: Nuevo profesor Martín Soto insertado.' AS Mensaje;
COMMIT;

-- T15: Actualizar una nota específica
START TRANSACTION;
    UPDATE Nota
    SET valor_nota = 18.0
    WHERE
        estudiante_id = (SELECT estudiante_id FROM Estudiante WHERE nombre = 'Daniela' AND apellido = 'Castro')
        AND asignatura_id = (SELECT asignatura_id FROM Asignatura WHERE nombre_asignatura = 'Lenguaje');
    SELECT 'T15: Nota de Daniela Castro en Lenguaje actualizada.' AS Mensaje;
COMMIT;

-- T16: Validar si una asignatura está asignada a un grado específico (solo consulta)
START TRANSACTION;
    SET @asignatura_id_check = (SELECT asignatura_id FROM Asignatura WHERE nombre_asignatura = 'Matemáticas');
    SET @grado_id_check = (SELECT grado_id FROM Grado WHERE nombre_grado = '4to Grado');
    SELECT CONCAT('T16: Asignaturas asignadas: ', COUNT(*), ' (Matemáticas a 4to Grado).') AS Mensaje
    FROM AsignaturaGrado WHERE asignatura_id = @asignatura_id_check AND grado_id = @grado_id_check;
COMMIT;

-- T17: Insertar una nueva sección
START TRANSACTION;
    INSERT INTO Seccion (nombre_seccion)
    VALUES ('F');
    SELECT 'T17: Nueva sección "F" insertada.' AS Mensaje;
COMMIT;

-- T18: Actualizar el género de un estudiante
START TRANSACTION;
    UPDATE Estudiante
    SET genero_id = (SELECT genero_id FROM Genero WHERE descripcion = 'Masculino')
    WHERE nombre = 'Daniela' AND apellido = 'Castro';
    SELECT 'T18: Género de Daniela Castro actualizado a Masculino.' AS Mensaje;
COMMIT;

-- T19: Eliminar un grado (y sus dependencias en Estudiante y AsignaturaGrado)
-- ¡CUIDADO! Esto es muy destructivo.
START TRANSACTION;
    SET @grado_a_eliminar_id = (SELECT grado_id FROM Grado WHERE nombre_grado = '6to Grado');
    -- Reasignar estudiantes a otro grado o eliminarlos
    UPDATE Estudiante SET grado_id = (SELECT grado_id FROM Grado WHERE nombre_grado = '5to Grado') WHERE grado_id = @grado_a_eliminar_id;
    DELETE FROM AsignaturaGrado WHERE grado_id = @grado_a_eliminar_id;
    DELETE FROM Grado WHERE grado_id = @grado_a_eliminar_id;
    SELECT 'T19: Grado "6to Grado" eliminado y dependencias reasignadas/eliminadas.' AS Mensaje;
COMMIT;



-- T20: Insertar una nota con una fecha pasada y validar si la inserción fue exitosa
START TRANSACTION;
    INSERT INTO Nota (estudiante_id, asignatura_id, profesor_id, valor_nota, fecha_nota)
    VALUES (
        (SELECT estudiante_id FROM Estudiante WHERE nombre = 'Pedro' AND apellido = 'Ramírez'),
        (SELECT asignatura_id FROM Asignatura WHERE nombre_asignatura = 'Ciencias Naturales'),
        (SELECT profesor_id FROM Profesor WHERE nombre = 'Carlos' AND apellido = 'Rodríguez'),
        14.0,
        '2024-11-01'
    );
    SELECT CONCAT('T20: Nota para Pedro Ramírez insertada exitosamente. Filas afectadas: ', ROW_COUNT()) AS Mensaje;
COMMIT;
