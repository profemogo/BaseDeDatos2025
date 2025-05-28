-- Creación de la base de datos
CREATE DATABASE IF NOT EXISTS swimmingProject_v1;
USE swimmingProject_v1;

-- Eliminar tablas existentes en orden inverso a sus dependencias
DROP TABLE IF EXISTS Tiempos;
DROP TABLE IF EXISTS Records;
DROP TABLE IF EXISTS RegistroCompetencias;
DROP TABLE IF EXISTS Series;
DROP TABLE IF EXISTS Nadadores;
DROP TABLE IF EXISTS Entrenadores;
DROP TABLE IF EXISTS Competencias;
DROP TABLE IF EXISTS EstiloMetraje;
DROP TABLE IF EXISTS historial_cambios;
DROP TABLE IF EXISTS EstilosNado;
DROP TABLE IF EXISTS Metrajes;
DROP TABLE IF EXISTS CategoriaEdad;
DROP TABLE IF EXISTS Club;
DROP TABLE IF EXISTS Genero;

-- tablas base (sin dependencias)
CREATE TABLE CategoriaEdad (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    edad_minima INT NOT NULL,
    edad_maxima INT NOT NULL
);

CREATE TABLE Club (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(200),
    telefono VARCHAR(20),
    email VARCHAR(100),
    pais VARCHAR(50),
    ciudad VARCHAR(50)
);

CREATE TABLE Genero (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL
);

CREATE TABLE EstilosNado (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE Metrajes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    metros INT NOT NULL
);

CREATE TABLE historial_cambios (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    tabla_afectada VARCHAR(50),
    id_registro INT,
    tipo_cambio ENUM('INSERT','UPDATE','DELETE'),
    campo_modificado VARCHAR(50),
    valor_anterior TEXT,
    valor_nuevo TEXT,
    usuario VARCHAR(50),
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--tablas con dependencias simples
CREATE TABLE EstiloMetraje (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    estilo_id BIGINT,
    metraje_id BIGINT,
    FOREIGN KEY (estilo_id) REFERENCES EstilosNado(id),
    FOREIGN KEY (metraje_id) REFERENCES Metrajes(id)
);

CREATE TABLE Competencias (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    pais VARCHAR(50) NOT NULL,
    estado VARCHAR(50) NOT NULL,
    ciudad VARCHAR(50) NOT NULL,
    club_id BIGINT,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    descripcion TEXT,
    tipo_competencia VARCHAR(50),
    FOREIGN KEY (club_id) REFERENCES Club(id)
);

CREATE TABLE Entrenadores (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    cedula VARCHAR(20) NOT NULL,
    club_id BIGINT,
    email VARCHAR(100),
    telefono VARCHAR(20),
    especialidad VARCHAR(50),
    certificado BOOLEAN DEFAULT FALSE,
    fecha_certificacion DATE,
    fecha_vencimiento DATE,
    FOREIGN KEY (club_id) REFERENCES Club(id)
);

-- tablas con multiples dependencias
CREATE TABLE Nadadores (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    genero_id BIGINT,
    cedula VARCHAR(20) NOT NULL,
    club_id BIGINT,
    email VARCHAR(100),
    telefono VARCHAR(20),
    categoria_edad_id BIGINT,
    FOREIGN KEY (genero_id) REFERENCES Genero(id),
    FOREIGN KEY (club_id) REFERENCES Club(id),
    FOREIGN KEY (categoria_edad_id) REFERENCES CategoriaEdad(id)
);

CREATE TABLE Series (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    competencia_id BIGINT,
    estilo_metraje_id BIGINT,
    fecha_hora TIMESTAMP NOT NULL,
    numero_serie INT NOT NULL,
    categoria_edad_id BIGINT,
    genero_id BIGINT,
    num_carriles INT NOT NULL DEFAULT 8,
    FOREIGN KEY (competencia_id) REFERENCES Competencias(id),
    FOREIGN KEY (estilo_metraje_id) REFERENCES EstiloMetraje(id),
    FOREIGN KEY (categoria_edad_id) REFERENCES CategoriaEdad(id),
    FOREIGN KEY (genero_id) REFERENCES Genero(id)
);

CREATE TABLE RegistroCompetencias (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nadador_id BIGINT,
    competencia_id BIGINT,
    serie_id BIGINT,
    carril INT NOT NULL,
    estado ENUM('inscrito','confirmado','retirado','finalizado') DEFAULT 'inscrito',
    posicion_final INT,
    UNIQUE KEY unique_nadador_serie (nadador_id, serie_id),
    UNIQUE KEY unique_carril_serie_estilo (serie_id, carril),
    FOREIGN KEY (nadador_id) REFERENCES Nadadores(id),
    FOREIGN KEY (competencia_id) REFERENCES Competencias(id),
    FOREIGN KEY (serie_id) REFERENCES Series(id)
);

CREATE TABLE Records (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nadador_id BIGINT,
    estilo_metraje_id BIGINT,
    tiempo DECIMAL(10,2) NOT NULL,
    fecha DATE NOT NULL,
    competencia_id BIGINT,
    tipo_record ENUM('club','regional','nacional','mundial') NOT NULL,
    FOREIGN KEY (nadador_id) REFERENCES Nadadores(id),
    FOREIGN KEY (estilo_metraje_id) REFERENCES EstiloMetraje(id),
    FOREIGN KEY (competencia_id) REFERENCES Competencias(id)
);

CREATE TABLE Tiempos (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    registro_competencia_id BIGINT,
    estilo_metraje_id BIGINT,
    tiempo DECIMAL(10,2) NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    es_record BOOLEAN DEFAULT FALSE,
    tipo_record ENUM('personal','club','regional','nacional','mundial'),
    observaciones TEXT,
    FOREIGN KEY (registro_competencia_id) REFERENCES RegistroCompetencias(id),
    FOREIGN KEY (estilo_metraje_id) REFERENCES EstiloMetraje(id)
); 