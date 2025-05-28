CREATE DATABASE IF NOT EXISTS SistemaDeAdopcion;
USE SistemaDeAdopcion;

CREATE TABLE IF NOT EXISTS Genero (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS Persona (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    dni VARCHAR(20) UNIQUE,
    genero_id INT,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_nacimiento DATE NOT NULL,
    FOREIGN KEY (genero_id) REFERENCES Genero (id)
);

CREATE TABLE IF NOT EXISTS Correo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    persona_id INT NOT NULL,
    correo VARCHAR(100) NOT NULL UNIQUE,
    principal BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (persona_id) REFERENCES Persona (id)
);

CREATE TABLE IF NOT EXISTS Telefono (
    id INT AUTO_INCREMENT PRIMARY KEY,
    persona_id INT NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    principal BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (persona_id) REFERENCES Persona (id)
);

CREATE TABLE IF NOT EXISTS Direccion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    persona_id INT NOT NULL,
    direccion TEXT NOT NULL,
    principal BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (persona_id) REFERENCES Persona (id)
);

CREATE TABLE IF NOT EXISTS Especie (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS GeneroAnimal (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS Mascota (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    edad INT,
    especie_id INT,
    genero_animal_id INT,
    dueño_id INT,
    tamaño VARCHAR(50),
    FOREIGN KEY (especie_id) REFERENCES Especie (id),
    FOREIGN KEY (genero_animal_id) REFERENCES GeneroAnimal (id),
    FOREIGN KEY (dueño_id) REFERENCES Persona (id)
);

CREATE TABLE IF NOT EXISTS Adopcion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    mascota_id INT NOT NULL,
    adoptante_id INT NOT NULL,
    fecha_adopcion DATE NOT NULL,
    FOREIGN KEY (mascota_id) REFERENCES Mascota (id),
    FOREIGN KEY (adoptante_id) REFERENCES Persona (id)
);