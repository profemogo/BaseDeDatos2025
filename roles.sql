CREATE ROLE IF NOT EXISTS 'admin_adopciones';
CREATE ROLE IF NOT EXISTS 'empleado_adopciones';
CREATE ROLE IF NOT EXISTS 'voluntario';
CREATE ROLE IF NOT EXISTS 'adoptante';

-- Permisos para administrador (acceso completo)
GRANT ALL PRIVILEGES ON SistemaDeAdopcion.* TO 'admin_adopciones';

-- Permisos para empleado (gestión diaria sin eliminación)
GRANT SELECT, INSERT, UPDATE ON SistemaDeAdopcion.* TO 'empleado_adopciones';
GRANT EXECUTE ON PROCEDURE SistemaDeAdopcion.RegistrarAdopcion TO 'empleado_adopciones';
GRANT EXECUTE ON PROCEDURE SistemaDeAdopcion.ObtenerInfoPersona TO 'empleado_adopciones';
GRANT EXECUTE ON FUNCTION SistemaDeAdopcion.CalcularEdad TO 'empleado_adopciones';
GRANT EXECUTE ON FUNCTION SistemaDeAdopcion.PuedeAdoptar TO 'empleado_adopciones';
GRANT EXECUTE ON FUNCTION SistemaDeAdopcion.ContarMascotasEspecie TO 'empleado_adopciones';

-- Permisos para voluntarios (solo lectura y funciones específicas)
GRANT SELECT ON SistemaDeAdopcion.* TO 'voluntario';
GRANT EXECUTE ON PROCEDURE SistemaDeAdopcion.ObtenerInfoPersona TO 'voluntario';
GRANT EXECUTE ON FUNCTION SistemaDeAdopcion.CalcularEdad TO 'voluntario';
GRANT EXECUTE ON FUNCTION SistemaDeAdopcion.PuedeAdoptar TO 'voluntario';
GRANT EXECUTE ON FUNCTION SistemaDeAdopcion.ContarMascotasEspecie TO 'voluntario';

-- Permisos para adoptantes (solo sus datos y mascotas)
GRANT SELECT ON SistemaDeAdopcion.VistaMascotas TO 'adoptante';
GRANT SELECT ON SistemaDeAdopcion.VistaAdopciones TO 'adoptante';
GRANT EXECUTE ON PROCEDURE SistemaDeAdopcion.obtenerInfoPersona TO 'adoptante';

-- Crear usuario administrador
CREATE USER IF NOT EXISTS 'admin@localhost' IDENTIFIED BY '123123';
GRANT 'admin_adopciones' TO 'admin@localhost';
SET DEFAULT ROLE 'admin_adopciones' TO 'admin@localhost';

-- Crear usuario empleado
CREATE USER IF NOT EXISTS 'empleado@localhost' IDENTIFIED BY '123123';
GRANT 'empleado_adopciones' TO 'empleado@localhost';
SET DEFAULT ROLE 'empleado_adopciones' TO 'empleado@localhost';

-- Crear usuario voluntario
CREATE USER IF NOT EXISTS 'voluntario@localhost' IDENTIFIED BY '123123';
GRANT 'voluntario' TO 'voluntario@localhost';
SET DEFAULT ROLE 'voluntario' TO 'voluntario@localhost';

-- Crear usuario adoptante (asociado a persona ID 1)
CREATE USER IF NOT EXISTS 'adoptante@localhost' IDENTIFIED BY '123123';
GRANT 'adoptante' TO 'adoptante@localhost';
SET DEFAULT ROLE 'adoptante' TO 'adoptante@localhost';