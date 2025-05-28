-- Personas
INSERT INTO Persona (nombre, apellido, dni, genero_id, fecha_nacimiento) VALUES
('Juan', 'Pérez', '12345678', 1, '1990-01-01'),
('María', 'Gómez', '8654321', 2, '1985-05-15'),
('Carlos', 'López', '11223344', 1, '1992-03-20'),
('Ana', 'Martínez', '4332211', 2, '1988-07-30'),
('Laura', 'Fernández', '5444333', 2, '1992-09-18'),
('Javier', 'Sánchez', '9888777', 1, '1988-12-05'),
('Sofía', 'Ramírez', '2333444', 2, '1998-04-22'),
('Diego', 'Hernández', '6777888', 1, '1983-07-30'),
('Elena', 'Torres', '11222334', 2, '1975-11-12'),
('Ricardo', 'Díaz', '5666777', 1, '1991-02-28');

-- Correos
INSERT INTO Correo (persona_id, correo, principal) VALUES
(1, 'maria.gonzalez@gmail.com', TRUE),
(1, 'mariagzl@gmail.com', FALSE),
(2, 'carlos.martinez@gmail.com', TRUE),
(3, 'ana.rodriguez@gmail.com', TRUE),
(4, 'pedro.lopez@gmail.com', TRUE),
(5, 'laura.fernandez@gmail.com', TRUE),
(6, 'javier.sanchez@gmail.com', TRUE),
(6, 'javiershz@gmail.com', FALSE),
(6, 'javiersanchez@gmail.com', FALSE),
(7, 'sofia.ramirez@gmail.com', TRUE),
(8, 'diego.hernandez@gmail.com', TRUE),
(8, 'diegohdz@gmail.com', FALSE),
(9, 'elena.torres@gmail.com', TRUE),
(9, 'elenatrrs@gmail.com', FALSE),
(10, 'ricardo.diaz@gmail.com', TRUE);

-- Teléfonos
INSERT INTO Telefono (persona_id, telefono, principal) VALUES
(1, '04121111111', TRUE),
(2, '04142222222', TRUE),
(2, '04122222222', FALSE),
(3, '04123333333', TRUE),
(4, '04124444444', TRUE),
(5, '04125555555', TRUE),
(5, '04145555555', FALSE),
(5, '04165555555', FALSE),
(6, '04126666666', TRUE),
(6, '04146666666', FALSE),
(7, '04127777777', TRUE),
(8, '04128888888', TRUE),
(9, '04129999999', TRUE),
(9, '04149999999', FALSE),
(10, '04121010101', TRUE);

-- Direcciones
INSERT INTO Direccion (persona_id, direccion, principal) VALUES
(1, 'Calle Primavera 123, Ciudad Jardín', TRUE),
(2, 'Avenida Central 456, Centro', TRUE),
(3, 'Plaza Mayor 789, Urbanización Sol', TRUE),
(4, 'Callejón del Parque 321, Zona Verde', TRUE),
(5, 'Avenida del Bosque 234, Colonia Arboleda', TRUE),
(6, 'Calle Luna 45, Sector Norte', TRUE),
(7, 'Boulevard Central 678, Zona Comercial', TRUE),
(8, 'Pasaje Estrella 12, Residencial Vega', TRUE),
(9, 'Camino Real 876, Urbanización Dorada', TRUE),
(10, 'Ronda del Río 543, Distrito Fluvial', TRUE);

-- Mascotas
INSERT INTO Mascota (nombre, edad, especie_id, genero_animal_id, dueño_id, tamaño) VALUES
('Firulais', 3, 1, 1, 1, '45 cm'),
('Michi', 2, 2, 2, 2, '25 cm'),
('Bugs', 1, 3, 1, 3, '30 cm'),
('Lola', 5, 4, 2, 4, '25 cm'),
('Manchas', 4, 1, 2, 6, '30 cm');

-- Adopciones
INSERT INTO Adopcion (mascota_id, adoptante_id, fecha_adopcion) VALUES
(5, 2, CURDATE()),
(4, 3, CURDATE()),
(3, 4, CURDATE()),
(1, 4, CURDATE());