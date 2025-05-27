-- Lorena Fernandez CI 28.440.154
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- Pruebas de inserción inválidas


-- 1. Intentar insertar una transacción con monto negativo (debe fallar por CHECK)
-- Esto debe fallar por la restricción CHECK (monto > 0)
INSERT INTO Transaccion (usuario_id, tipo_transaccion_id, cuenta_bancaria_id, monto, fecha, categoria_id, descripcion)
VALUES (1, 2, 1, -100.00, NOW(), 9, 'Monto negativo');

-- 2. Intentar insertar una transacción con fecha futura (debe fallar por CHECK)
-- Esto debe fallar por el trigger before_insert_meta
INSERT INTO Meta (usuario_id, nombre, monto_objetivo, fecha_objetivo, progreso)
VALUES (1, 'Meta Inválida', 1000.00, '2020-01-01', 0);

-- 3. Intentar insertar una transacción con monto cero (debe fallar por CHECK)
-- Esto debe fallar porque no existe la categoría con id 999
INSERT INTO Transaccion (usuario_id, tipo_transaccion_id, cuenta_bancaria_id, monto, fecha, categoria_id, descripcion)
VALUES (1, 2, 1, 100.00, NOW(), 999, 'Categoría inexistente');

--4. Intentar insertar una transacción con cuenta bancaria inexistente (debe fallar por FOREIGN KEY)
-- Esto debe fallar porque no existe el usuario con id 999
INSERT INTO Transaccion (usuario_id, tipo_transaccion_id, cuenta_bancaria_id, monto, fecha, categoria_id, descripcion)
VALUES (999, 2, 1, 100.00, NOW(), 9, 'Usuario inexistente');

-- 5. Intentar insertar una transacción con usuario inexistente (debe fallar por FOREIGN KEY)
-- Esto debe fallar por la restricción CHECK (monto_objetivo > 0)
INSERT INTO Meta (usuario_id, nombre, monto_objetivo, fecha_objetivo, progreso)
VALUES (1, 'Meta Negativa', -500.00, '2025-01-01', 0);

-- 6. Intentar insertar una transacción con tipo_transaccion_id inexistente (debe fallar por FOREIGN KEY)
INSERT INTO Transaccion (usuario_id, tipo_transaccion_id, cuenta_bancaria_id, monto, fecha, categoria_id, descripcion)
VALUES (1, 99, 1, 100.00, NOW(), 9, 'Tipo de transacción inexistente');