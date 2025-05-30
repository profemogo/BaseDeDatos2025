-- =============================================
-- ESTRUCTURA CORREGIDA CON RESTRICCIONES COMPLETAS
-- =============================================

DROP DATABASE IF EXISTS GestionNotas;

CREATE DATABASE IF NOT EXISTS GestionNotas;
USE GestionNotas;

-- Tabla Genero
CREATE TABLE IF NOT EXISTS Genero (
    genero_id INT PRIMARY KEY AUTO_INCREMENT,
    descripcion VARCHAR(50) NOT NULL UNIQUE
);

-- Tabla Grado
CREATE TABLE IF NOT EXISTS Grado (
    grado_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre_grado VARCHAR(50) NOT NULL UNIQUE
);

-- Tabla Seccion
CREATE TABLE IF NOT EXISTS Seccion (
    seccion_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre_seccion VARCHAR(50) NOT NULL UNIQUE
);

-- Tabla Profesor
CREATE TABLE IF NOT EXISTS Profesor (
    profesor_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL,
    apellido VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    telefono VARCHAR(20)
);

-- Tabla Estudiante con restricciones en claves foráneas
CREATE TABLE IF NOT EXISTS Estudiante (
    estudiante_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL,
    apellido VARCHAR(255) NOT NULL,
    fecha_nacimiento DATE,
    genero_id INT NOT NULL,
    grado_id INT NOT NULL,
    seccion_id INT NOT NULL,
    email VARCHAR(255) UNIQUE,
    FOREIGN KEY (genero_id) REFERENCES Genero(genero_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (grado_id) REFERENCES Grado(grado_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (seccion_id) REFERENCES Seccion(seccion_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla Asignatura
CREATE TABLE IF NOT EXISTS Asignatura (
    asignatura_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre_asignatura VARCHAR(255) NOT NULL UNIQUE
);

-- Tabla AsignaturaGrado con restricciones
CREATE TABLE IF NOT EXISTS AsignaturaGrado (
    asignatura_grado_id INT PRIMARY KEY AUTO_INCREMENT,
    asignatura_id INT NOT NULL,
    grado_id INT NOT NULL,
    profesor_id INT NULL, -- 🔹 Permitimos NULL para que SET NULL funcione correctamente
    UNIQUE (asignatura_id, grado_id, profesor_id),
    FOREIGN KEY (asignatura_id) REFERENCES Asignatura(asignatura_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (grado_id) REFERENCES Grado(grado_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (profesor_id) REFERENCES Profesor(profesor_id) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Tabla Nota con restricciones para manejo de relaciones
CREATE TABLE IF NOT EXISTS Nota (
    nota_id INT PRIMARY KEY AUTO_INCREMENT,
    estudiante_id INT NOT NULL,
    asignatura_id INT NOT NULL,
    profesor_id INT NULL, -- 🔹 Permitimos NULL para evitar errores con SET NULL
    valor_nota DECIMAL(5, 2) NOT NULL CHECK (valor_nota >= 0 AND valor_nota <= 20),
    fecha_nota DATE NOT NULL DEFAULT (CURDATE()),
    FOREIGN KEY (estudiante_id) REFERENCES Estudiante(estudiante_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (asignatura_id) REFERENCES Asignatura(asignatura_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (profesor_id) REFERENCES Profesor(profesor_id) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Tabla Auditoria para registro de modificaciones
CREATE TABLE IF NOT EXISTS Auditoria (
    auditoria_id INT PRIMARY KEY AUTO_INCREMENT,
    tabla VARCHAR(255) NOT NULL,
    registro_id INT NOT NULL,
    tipo_evento VARCHAR(50) NOT NULL,
    usuario VARCHAR(255),
    fecha_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    datos_antes TEXT,
    datos_despues TEXT
);


