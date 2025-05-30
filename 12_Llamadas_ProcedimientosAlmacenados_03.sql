START TRANSACTION;

-- 1. Registrar un nuevo estudiante
CALL RegistrarNuevoEstudiante('Luis', 'Fernández', '2011-07-10', 1, 1, 1, 'luis.fernandez@email.com');
SELECT LAST_INSERT_ID() INTO @estudiante_id_nuevo_1;

-- 2. Registrar otro estudiante
CALL RegistrarNuevoEstudiante('Carla', 'Martínez', '2010-05-25', 2, 2, 2, 'carla.martinez@email.com');
SELECT LAST_INSERT_ID() INTO @estudiante_id_nuevo_2;

-- 3. Registrar otro estudiante
CALL RegistrarNuevoEstudiante('Andrés', 'Ruiz', '2012-01-15', 1, 3, 3, 'andres.ruiz@email.com');
SELECT LAST_INSERT_ID() INTO @estudiante_id_nuevo_3;

-- 4. Registrar otro estudiante
CALL RegistrarNuevoEstudiante('Mariana', 'Soto', '2011-11-30', 2, 4, 4, 'mariana.soto@email.com');
SELECT LAST_INSERT_ID() INTO @estudiante_id_nuevo_4;

-- 5. Asignar una asignatura a un grado y profesor (Evitando duplicados)
INSERT IGNORE INTO AsignaturaGrado (asignatura_id, grado_id, profesor_id) VALUES (1, 1, 1);
INSERT IGNORE INTO AsignaturaGrado (asignatura_id, grado_id, profesor_id) VALUES (2, 2, 2);
INSERT IGNORE INTO AsignaturaGrado (asignatura_id, grado_id, profesor_id) VALUES (3, 3, 3);

-- 6. Inscribir un estudiante en un grado y sección
CALL InscribirEstudiante(@estudiante_id_nuevo_1, 1, 1);
CALL InscribirEstudiante(@estudiante_id_nuevo_2, 2, 2);
CALL InscribirEstudiante(@estudiante_id_nuevo_3, 3, 3);
CALL InscribirEstudiante(@estudiante_id_nuevo_4, 4, 4);

-- 7. Insertar múltiples notas
CALL InsertarMultiplesNotas(@estudiante_id_nuevo_1, 1, '[{"asignatura_id": 1, "valor_nota": 18.0}]');
CALL InsertarMultiplesNotas(@estudiante_id_nuevo_2, 2, '[{"asignatura_id": 2, "valor_nota": 17.5}]');
CALL InsertarMultiplesNotas(@estudiante_id_nuevo_3, 3, '[{"asignatura_id": 3, "valor_nota": 19.0}]');
CALL InsertarMultiplesNotas(@estudiante_id_nuevo_4, 1, '[{"asignatura_id": 1, "valor_nota": 15.5}]');

-- 8. Actualizar notas existentes
CALL ActualizarNota(1, 19.5, CURDATE());
CALL ActualizarNota(2, 18.0, CURDATE());
CALL ActualizarNota(3, 20.0, CURDATE());
CALL ActualizarNota(4, 16.0, CURDATE());

-- 9. Obtener notas de estudiantes
CALL ObtenerNotasEstudiante(@estudiante_id_nuevo_1);
CALL ObtenerNotasEstudiante(@estudiante_id_nuevo_2);
CALL ObtenerNotasEstudiante(@estudiante_id_nuevo_3);
CALL ObtenerNotasEstudiante(@estudiante_id_nuevo_4);

-- 10. Borrar notas antiguas
CALL BorrarNotasAntiguas();

COMMIT;

SELECT 'Las 20 llamadas a procedimientos almacenados se ejecutaron exitosamente.' AS Mensaje;
