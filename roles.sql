-- Lorena Fernandez CI 28.440.154
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--     Roles y Permisos de la base de datos
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

-- Eliminar roles existentes si existen
DROP ROLE IF EXISTS 'admin_role'@'localhost';
DROP ROLE IF EXISTS 'usuario_role'@'localhost';
DROP ROLE IF EXISTS 'auditor_role'@'localhost';

-- Eliminar usuarios existentes si existen
DROP USER IF EXISTS 'admin'@'localhost';
DROP USER IF EXISTS 'usuario1'@'localhost';
DROP USER IF EXISTS 'auditor1'@'localhost';

-- Crear roles
CREATE ROLE 'admin_role'@'localhost';
CREATE ROLE 'usuario_role'@'localhost';
CREATE ROLE 'auditor_role'@'localhost';

-- Asignar permisos al rol de administrador
GRANT ALL PRIVILEGES ON *.* TO 'admin_role'@'localhost';

-- Asignar permisos al rol de usuario
-- Permisos para sus propios datos
GRANT SELECT, UPDATE ON Usuario TO 'usuario_role'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON Transaccion TO 'usuario_role'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON Presupuesto TO 'usuario_role'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON Meta TO 'usuario_role'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON CuentaBancaria TO 'usuario_role'@'localhost';
GRANT SELECT ON Categoria TO 'usuario_role'@'localhost';
GRANT SELECT ON TipoTransaccion TO 'usuario_role'@'localhost';
GRANT SELECT ON HistorialTransaccion TO 'usuario_role'@'localhost';

-- Asignar permisos al rol de auditor
GRANT SELECT ON Usuario TO 'auditor_role'@'localhost';
GRANT SELECT ON Transaccion TO 'auditor_role'@'localhost';
GRANT SELECT ON Presupuesto TO 'auditor_role'@'localhost';
GRANT SELECT ON Meta TO 'auditor_role'@'localhost';
GRANT SELECT ON CuentaBancaria TO 'auditor_role'@'localhost';
GRANT SELECT ON Categoria TO 'auditor_role'@'localhost';
GRANT SELECT ON TipoTransaccion TO 'auditor_role'@'localhost';
GRANT SELECT ON HistorialTransaccion TO 'auditor_role'@'localhost';

-- Crear usuarios de ejemplo
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin';
CREATE USER 'usuario1'@'localhost' IDENTIFIED BY 'user';
CREATE USER 'auditor1'@'localhost' IDENTIFIED BY 'auditor';

-- Asignar roles a usuarios
GRANT 'admin_role'@'localhost' TO 'admin'@'localhost';
GRANT 'usuario_role'@'localhost' TO 'usuario1'@'localhost';
GRANT 'auditor_role'@'localhost' TO 'auditor1'@'localhost';

-- Activar roles por defecto
SET DEFAULT ROLE ALL TO 'admin'@'localhost';
SET DEFAULT ROLE ALL TO 'usuario1'@'localhost';
SET DEFAULT ROLE ALL TO 'auditor1'@'localhost';

-- Procedimiento para asignar rol a usuario
DELIMITER //
CREATE PROCEDURE AsignarRolUsuario(
    IN p_usuario VARCHAR(50),
    IN p_rol VARCHAR(50)
)
BEGIN
    SET @sql = CONCAT('GRANT ', p_rol, ' TO ', p_usuario);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    SET @sql = CONCAT('SET DEFAULT ROLE ALL TO ', p_usuario);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //
DELIMITER ;

-- Procedimiento para revocar rol de usuario
DELIMITER //
CREATE PROCEDURE RevocarRolUsuario(
    IN p_usuario VARCHAR(50),
    IN p_rol VARCHAR(50)
)
BEGIN
    SET @sql = CONCAT('REVOKE ', p_rol, ' FROM ', p_usuario);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //
DELIMITER ;

-- Procedimiento para verificar permisos de usuario
DELIMITER //
CREATE PROCEDURE VerificarPermisosUsuario(
    IN p_usuario VARCHAR(50)
)
BEGIN
    SELECT * FROM information_schema.user_privileges 
    WHERE grantee = CONCAT('\'', p_usuario, '\'');
END //
DELIMITER ;

-- Ejemplos de uso:

-- Para asignar un rol a un usuario:
-- CALL AsignarRolUsuario('nuevo_usuario@localhost', 'usuario_role');

-- Para revocar un rol de un usuario:
-- CALL RevocarRolUsuario('usuario@localhost', 'usuario_role');

-- Para verificar permisos de un usuario:
-- CALL VerificarPermisosUsuario('usuario@localhost');

-- Para revocar todos los permisos de un usuario:
-- REVOKE ALL PRIVILEGES ON *.* FROM 'usuario@localhost';

-- Para revocar un permiso específico:
-- REVOKE SELECT ON database.table FROM 'usuario@localhost';
