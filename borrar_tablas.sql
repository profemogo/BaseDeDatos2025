-- Deshabilitar temporalmente restricciones de clave foránea
SET FOREIGN_KEY_CHECKS = 0;

-- Borrar todas las tablas en orden inverso de dependencias
DROP TABLE IF EXISTS Records;
DROP TABLE IF EXISTS Tiempos;
DROP TABLE IF EXISTS RegistroCompetencias;
DROP TABLE IF EXISTS Series;
DROP TABLE IF EXISTS Competencias;
DROP TABLE IF EXISTS EstiloMetraje;
DROP TABLE IF EXISTS Metrajes;
DROP TABLE IF EXISTS EstilosNado;
DROP TABLE IF EXISTS Entrenadores;
DROP TABLE IF EXISTS Nadadores;
DROP TABLE IF EXISTS CategoriaEdad;
DROP TABLE IF EXISTS Club;
DROP TABLE IF EXISTS Genero;

-- Volver a habilitar restricciones de clave foránea
SET FOREIGN_KEY_CHECKS = 1; 