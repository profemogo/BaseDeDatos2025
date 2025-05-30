-- =============================================
-- 1. READ UNCOMMITTED (Permite lecturas sucias - Dirty Reads)
-- =============================================
SELECT '--- READ UNCOMMITTED DEMO ---' AS NivelAislamiento;

-- En Sesión 1:
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
START TRANSACTION;
UPDATE Estudiante SET nombre = 'Pedro_RU_Temp' WHERE estudiante_id = 1;
SELECT 'Sesión 1: Pedro actualizado a Pedro_RU_Temp (no commiteado)' AS Mensaje;
SELECT SLEEP(5);

-- En Sesión 2:
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
START TRANSACTION;
SELECT 'Sesión 2: Primera lectura de Pedro (debería ver Pedro_RU_Temp - Dirty Read)' AS Mensaje;
SELECT estudiante_id, nombre FROM Estudiante WHERE estudiante_id = 1;
SELECT SLEEP(5);

-- De vuelta en Sesión 1:
ROLLBACK;
SELECT 'Sesión 1: Rollback de la actualización.' AS Mensaje;
SELECT SLEEP(5);

-- De vuelta en Sesión 2:
SELECT 'Sesión 2: Segunda lectura de Pedro (debería ver el nombre original - Dirty Read desaparecido)' AS Mensaje;
SELECT estudiante_id, nombre FROM Estudiante WHERE estudiante_id = 1;
COMMIT;
SELECT 'Sesión 2: Transacción finalizada.' AS Mensaje;


-- =============================================
-- 2. READ COMMITTED (Evita Dirty Reads, Permite Non-Repeatable Reads y Phantom Reads)
-- =============================================
SELECT '--- READ COMMITTED DEMO ---' AS NivelAislamiento;

-- En Sesión 1:
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
UPDATE Estudiante SET nombre = 'Laura_RC_Updated' WHERE estudiante_id = 2;
SELECT 'Sesión 1: Laura actualizada a Laura_RC_Updated (no commiteado)' AS Mensaje;
SELECT SLEEP(5);

-- En Sesión 2:
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT 'Sesión 2: Primera lectura de Laura (debería ver el nombre original - No Dirty Read)' AS Mensaje;
SELECT estudiante_id, nombre FROM Estudiante WHERE estudiante_id = 2;
SELECT SLEEP(5);

-- De vuelta en Sesión 1:
COMMIT;
SELECT 'Sesión 1: Commit de la actualización.' AS Mensaje;
SELECT SLEEP(5);

-- De vuelta en Sesión 2:
SELECT 'Sesión 2: Segunda lectura de Laura (debería ver Laura_RC_Updated - Non-Repeatable Read)' AS Mensaje;
SELECT estudiante_id, nombre FROM Estudiante WHERE estudiante_id = 2;
COMMIT;
SELECT 'Sesión 2: Transacción finalizada.' AS Mensaje;

-- Demostración de Phantom Read en READ COMMITTED (requiere nueva transacción en Sesión 2)
-- En Sesión 1:
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
INSERT INTO Estudiante (nombre, apellido, fecha_nacimiento, genero_id, grado_id, seccion_id, email)
VALUES ('Phantom_RC', 'Estudiante', '2015-01-01', 1, 1, 1, 'phantomrc@example.com');
COMMIT;
SELECT 'Sesión 1: Insertado Phantom_RC.' AS Mensaje;
SELECT SLEEP(5);

-- En Sesión 2:
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT 'Sesión 2: Lectura de estudiantes en Grado 1 (antes del insert de Sesión 1).' AS Mensaje;
SELECT COUNT(*) FROM Estudiante WHERE grado_id = 1;
SELECT SLEEP(5);

-- De vuelta en Sesión 2 (después del commit de Sesión 1):
SELECT 'Sesión 2: Re-lectura de estudiantes en Grado 1 (debería ver el nuevo estudiante - Phantom Read).' AS Mensaje;
SELECT COUNT(*) FROM Estudiante WHERE grado_id = 1;
COMMIT;
SELECT 'Sesión 2: Transacción finalizada.' AS Mensaje;


-- =============================================
-- 3. REPEATABLE READ (Evita Dirty Reads, Non-Repeatable Reads, Permite Phantom Reads)
-- =============================================
SELECT '--- REPEATABLE READ DEMO ---' AS NivelAislamiento;

-- En Sesión 1:
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;
SELECT 'Sesión 1: Primera lectura de Diego (debería ver el nombre original).' AS Mensaje;
SELECT estudiante_id, nombre FROM Estudiante WHERE estudiante_id = 3;
SELECT SLEEP(5);

-- En Sesión 2:
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;
UPDATE Estudiante SET nombre = 'Diego_RR_Updated' WHERE estudiante_id = 3;
SELECT 'Sesión 2: Diego actualizado a Diego_RR_Updated (no commiteado).' AS Mensaje;
SELECT SLEEP(5);

-- De vuelta en Sesión 1:
SELECT 'Sesión 1: Segunda lectura de Diego (debería ver el nombre original - No Non-Repeatable Read).' AS Mensaje;
SELECT estudiante_id, nombre FROM Estudiante WHERE estudiante_id = 3;
SELECT SLEEP(5);

-- De vuelta en Sesión 2:
COMMIT;
SELECT 'Sesión 2: Commit de la actualización.' AS Mensaje;
SELECT SLEEP(5);

-- De vuelta en Sesión 1:
SELECT 'Sesión 1: Tercera lectura de Diego (todavía debería ver el nombre original - No Non-Repeatable Read).' AS Mensaje;
SELECT estudiante_id, nombre FROM Estudiante WHERE estudiante_id = 3;
COMMIT;
SELECT 'Sesión 1: Transacción finalizada.' AS Mensaje;

-- Demostración de Phantom Read (comportamiento de MySQL InnoDB)
-- En Sesión 1:
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;
SELECT 'Sesión 1: Conteo de estudiantes en Grado 4 (primera lectura).' AS Mensaje;
SELECT COUNT(*) FROM Estudiante WHERE grado_id = 4;
SELECT SLEEP(5);

-- En Sesión 2:
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;
INSERT INTO Estudiante (nombre, apellido, fecha_nacimiento, genero_id, grado_id, seccion_id, email)
VALUES ('Phantom_RR', 'Estudiante', '2016-06-01', 2, 4, 1, 'phantomrr@example.com');
COMMIT;
SELECT 'Sesión 2: Insertado Phantom_RR.' AS Mensaje;
SELECT SLEEP(5);

-- De vuelta en Sesión 1:
SELECT 'Sesión 1: Re-conteo de estudiantes en Grado 4 (debería ser el mismo que la primera lectura - No Phantom Read en MySQL).' AS Mensaje;
SELECT COUNT(*) FROM Estudiante WHERE grado_id = 4;
COMMIT;
SELECT 'Sesión 1: Transacción finalizada.' AS Mensaje;


-- =============================================
-- 4. SERIALIZABLE (Evita Dirty Reads, Non-Repeatable Reads, Phantom Reads)
-- =============================================
SELECT '--- SERIALIZABLE DEMO ---' AS NivelAislamiento;

-- En Sesión 1:
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
SELECT 'Sesión 1: Conteo de estudiantes en Grado 2 (establece bloqueo de rango).' AS Mensaje;
SELECT COUNT(*) FROM Estudiante WHERE grado_id = 2;
SELECT SLEEP(5);

-- En Sesión 2:
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
SELECT 'Sesión 2: Intentando insertar estudiante en Grado 2 (debería bloquearse hasta que Sesión 1 haga COMMIT/ROLLBACK).' AS Mensaje;
INSERT INTO Estudiante (nombre, apellido, fecha_nacimiento, genero_id, grado_id, seccion_id, email)
VALUES ('Blocked_S', 'Student', '2017-01-01', 1, 2, 2, 'blocked_s@example.com');
SELECT 'Sesión 2: Insert completado (después de que Sesión 1 liberó el bloqueo).' AS Mensaje;
SELECT SLEEP(5);

-- De vuelta en Sesión 1:
COMMIT;
SELECT 'Sesión 1: Commit de la transacción (libera el bloqueo).' AS Mensaje;
SELECT SLEEP(5);

-- De vuelta en Sesión 2 (después de que Sesión 1 hizo COMMIT):
SELECT 'Sesión 2: Ahora debería poder hacer commit.' AS Mensaje;
COMMIT;
SELECT 'Sesión 2: Transacción finalizada.' AS Mensaje;

-- Verificación final del estado de la tabla Estudiante
SELECT '--- ESTADO FINAL DE LA TABLA ESTUDIANTE ---' AS Verificacion;
SELECT estudiante_id, nombre, apellido, grado_id FROM Estudiante ORDER BY estudiante_id;
