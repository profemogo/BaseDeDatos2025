-- 2. Crear roles
CREATE ROLE IF NOT EXISTS 'rol_medico';
CREATE ROLE IF NOT EXISTS 'rol_admin';
CREATE ROLE IF NOT EXISTS 'rol_enfermeria';

-- 3. Crear usuarios y asignarles roles
CREATE USER IF NOT EXISTS 'medico1'@'localhost' IDENTIFIED BY '12345';
CREATE USER IF NOT EXISTS 'admin1'@'localhost' IDENTIFIED BY '12345';
CREATE USER IF NOT EXISTS 'enfermeria1'@'localhost' IDENTIFIED BY '12345';

GRANT 'rol_medico' TO 'medico1'@'localhost';
GRANT 'rol_admin' TO 'admin1'@'localhost';
GRANT 'rol_enfermeria' TO 'enfermeria1'@'localhost';

-- 4. Asignar permisos a roles

-- Permisos rol_medico: acceso a consultas, recetas, descripción de recetas y pacientes (lectura)
GRANT SELECT, INSERT ON m.Consulta TO 'rol_medico';
GRANT SELECT, INSERT ON m.Recipe TO 'rol_medico';
GRANT SELECT, INSERT ON m.DescripcionReceta TO 'rol_medico';
GRANT SELECT ON m.Paciente TO 'rol_medico';

-- Permisos rol_admin: todos los privilegios en la base hospital
GRANT ALL PRIVILEGES ON m.* TO 'rol_admin' WITH GRANT OPTION;

-- Permisos rol_enfermeria: solo lectura en pacientes, ingresos y habitaciones
GRANT SELECT ON Paciente TO 'rol_enfermeria';
GRANT SELECT ON Ingreso TO 'rol_enfermeria';
GRANT SELECT ON Habitacion TO 'rol_enfermeria';
GRANT SELECT ON Medicamento TO 'rol_enfermeria';
GRANT SELECT ON DescripcionReceta  TO 'rol_enfermeria';
GRANT SELECT ON Recipe  TO 'rol_enfermeria';
GRANT SELECT ON Consulta  TO 'rol_enfermeria';



-- 5. Opcional: establecer rol por defecto al iniciar sesión
SET DEFAULT ROLE 'rol_medico' TO 'medico1'@'localhost';
SET DEFAULT ROLE 'rol_admin' TO 'admin1'@'localhost';
SET DEFAULT ROLE 'rol_enfermeria' TO 'enfermeria1'@'localhost';

-- 6. Aplicar cambios de privilegios inmediatamente
FLUSH PRIVILEGES;

GRANT ALL PRIVILEGES ON m.* TO 'admin1'@'localhost';
FLUSH PRIVILEGES;


GRANT USAGE ON m.* TO   'medico1'@'localhost';
FLUSH PRIVILEGES;

REVOKE SELECT ON Recipe FROM 'rol_enfermeria';

REVOKE SELECT ON Consulta FROM 'rol_enfermeria';






--Activar usuarios 



SET ROLE rol_medico;


SET ROLE rol_admin;

SET ROLE rol_enfermeria;

CREATE ROLE 'rol_seguridad';


GRANT EXECUTE ON PROCEDURE BorrarDatos TO 'rol_seguridad';

GRANT 'rol_seguridad' TO 'admin1'@'localhost';



SET ROLE rol_seguridad;


