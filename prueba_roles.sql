-- Prueba de Roles y Usuarios
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- Lorena Fernandez CI 28.440.154

-- 1. Verificar si los usuarios existen
SELECT User, Host FROM mysql.user WHERE User IN ('admin', 'usuario1', 'auditor1');

-- 2. Verificar permisos del admin
SHOW GRANTS FOR 'admin'@'localhost';

-- 3. Verificar permisos del usuario1
SHOW GRANTS FOR 'usuario1'@'localhost';

-- 4. Verificar permisos del auditor1
SHOW GRANTS FOR 'auditor1'@'localhost';

-- 5. Pruebas de permisos (ejecutar cada bloque por separado)

-- Prueba como admin (debería poder todo):
-- mysql -u admin -p
-- USE FinanzasPersonales;
-- SELECT * FROM Usuario;
-- INSERT INTO Usuario (nombre, email, password) VALUES ('Test Admin', 'test@admin.com', 'test123');
-- DELETE FROM Usuario WHERE id = 1;  -- Debería funcionar


-- Prueba como usuario1 (debería tener permisos limitados):
-- mysql -u usuario1 -p
-- USE FinanzasPersonales;
-- SELECT * FROM Usuario WHERE id = 1;  -- Debería funcionar
-- SELECT * FROM Usuario WHERE id = 2;  -- Debería dar error (no puede ver otros usuarios)
-- UPDATE Usuario SET nombre = 'Usuario Modificado' WHERE id = 1;  -- Debería funcionar
-- UPDATE Usuario SET nombre = 'Usuario Modificado' WHERE id = 2;  -- Debería dar error
-- DELETE FROM Usuario WHERE id = 1;  -- Debería dar error (no tiene permiso DELETE)
-- DROP TABLE Usuario;  -- Debería dar error (no tiene permisos de DDL)

-- Prueba como auditor1 (solo debería poder ver):
-- mysql -u auditor1 -p
-- USE FinanzasPersonales;
-- SELECT * FROM Usuario;  -- Debería funcionar
-- SELECT * FROM Transaccion;  -- Debería funcionar
-- INSERT INTO Usuario (nombre, email, password) VALUES ('Test', 'test@test.com', 'test123');  -- Debería dar error
-- UPDATE Usuario SET nombre = 'Nuevo Nombre' WHERE id = 1;  -- Debería dar error
-- DELETE FROM Usuario WHERE id = 1;  -- Debería dar error
-- DROP TABLE Usuario;  -- Debería dar error 