USE GestionNotas;

-- Eliminar usuarios (si existen) para una ejecución limpia
DROP USER IF EXISTS 'admin_user'@'localhost';
DROP USER IF EXISTS 'profesor_user'@'localhost';
DROP USER IF EXISTS 'estudiante_user'@'localhost';
DROP USER IF EXISTS 'lectura_user'@'localhost';

-- Crear Usuarios y Asignar Roles

-- Usuario Administrador
CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'AdminPass123!';
GRANT 'rol_administrador' TO 'admin_user'@'localhost';
SET DEFAULT ROLE 'rol_administrador' TO 'admin_user'@'localhost';

-- Usuario Profesor
CREATE USER 'profesor_user'@'localhost' IDENTIFIED BY 'ProfesorPass123!';
GRANT 'rol_profesor' TO 'profesor_user'@'localhost';
SET DEFAULT ROLE 'rol_profesor' TO 'profesor_user'@'localhost';

-- Usuario Estudiante
CREATE USER 'estudiante_user'@'localhost' IDENTIFIED BY 'EstudiantePass123!';
GRANT 'rol_estudiante' TO 'estudiante_user'@'localhost';
SET DEFAULT ROLE 'rol_estudiante' TO 'estudiante_user'@'localhost';

-- Usuario Solo Lectura
CREATE USER 'lectura_user'@'localhost' IDENTIFIED BY 'LecturaPass123!';
GRANT 'rol_lectura' TO 'lectura_user'@'localhost';
SET DEFAULT ROLE 'rol_lectura' TO 'lectura_user'@'localhost';

FLUSH PRIVILEGES;
