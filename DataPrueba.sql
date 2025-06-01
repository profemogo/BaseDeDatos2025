SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE DescripcionReceta;
TRUNCATE TABLE Recipe;
TRUNCATE TABLE Medicamento;
TRUNCATE TABLE Ingreso;
TRUNCATE TABLE HistorialConsulta;
TRUNCATE TABLE Consulta;
TRUNCATE TABLE Habitacion;
TRUNCATE TABLE Medico;
TRUNCATE TABLE Especialidad;
TRUNCATE TABLE Paciente;

SET FOREIGN_KEY_CHECKS = 1;

SHOW TABLE STATUS LIKE 'Especialidad'\G



INSERT INTO Especialidad (nombre) VALUES
('Cardiología'),
('Pediatría'),
('Neurología'),
('Dermatología'),
('Medicina General'),
('Gastroenterología'),
('Oncología'),
('Ortopedia'),
('Psiquiatría'),
('Oftalmología');



INSERT INTO Medico (especialidad_id, numero_colegiatura, nombre, apellido, telefono, cedula) VALUES
(1, 'C1001', 'Juan', 'Pérez', '555-1001', '11111111'),
(2, 'C1002', 'María', 'López', '555-1002', '22222222'),
(3, 'C1003', 'Carlos', 'Ramírez', '555-1003', '33333333'),
(4, 'C1004', 'Ana', 'Torres', '555-1004', '44444444'),
(5, 'C1005', 'Luis', 'Mendoza', '555-1005', '55555555'),
(6, 'C1006', 'Julia', 'García', '555-1006', '66666666'),
(7, 'C1007', 'Miguel', 'Santos', '555-1007', '77777777'),
(8, 'C1008', 'Paula', 'Morales', '555-1008', '88888888'),
(9, 'C1009', 'Andrés', 'Herrera', '555-1009', '99999999'),
(10, 'C1010', 'Sofía', 'Ruiz', '555-1010', '10101010');

INSERT INTO Paciente (nombre, apellido, direccion, cedula, fecha_nacimiento, genero, telefono) VALUES
('Pedro', 'Gómez', 'Av. Central 1', '00000001', '1980-05-10', 'M', '555-2001'),
('Laura', 'Martínez', 'Calle Falsa 2', '00000002', '1992-08-15', 'F', '555-2002'),
('Mario', 'Suárez', 'Av. Bolívar 3', '00000003', '1975-12-20', 'M', '555-2003'),
('Luisa', 'Fernández', 'Calle Sol 4', '00000004', '1985-07-07', 'F', '555-2004'),
('Camilo', 'Rodríguez', 'Calle Luna 5', '00000005', '2000-01-01', 'Otro', '555-2005'),
('Valeria', 'Cruz', 'Av. Siempre Viva 6', '00000006', '1987-03-22', 'F', '555-2006'),
('Nicolás', 'Muñoz', 'Calle Sur 7', '00000007', '1990-09-09', 'M', '555-2007'),
('Daniela', 'Silva', 'Av. Norte 8', '00000008', '1995-12-12', 'F', '555-2008'),
('Esteban', 'Lara', 'Calle Este 9', '00000009', '1982-06-06', 'M', '555-2009'),
('Juliana', 'Peña', 'Calle Oeste 10', '00000010', '1998-10-10', 'F', '555-2010');

INSERT INTO Habitacion (numero, tipo, piso) VALUES
('101', 'Privada', 1),
('102', 'Compartida', 1),
('103', 'UCI', 1),
('201', 'Privada', 2),
('202', 'Compartida', 2),
('203', 'UCI', 2),
('301', 'Privada', 3),
('302', 'Compartida', 3),
('303', 'UCI', 3),
('304', 'Privada', 3);

INSERT INTO Consulta (paciente_id, medico_id, fecha, motivo_consulta) VALUES
(1, 1, '2025-05-31 08:00:00', 'Dolor en el pecho'),
(2, 2, '2025-05-31 08:30:00', 'Fiebre y tos'),
(3, 3, '2025-05-31 09:00:00', 'Dolor de cabeza'),
(4, 4, '2025-05-31 09:30:00', 'Erupciones'),
(5, 5, '2025-05-31 10:00:00', 'Chequeo general'),
(6, 6, '2025-05-31 10:30:00', 'Dolor abdominal'),
(7, 7, '2025-05-31 11:00:00', 'Náuseas'),
(8, 8, '2025-05-31 11:30:00', 'Ansiedad'),
(9, 9, '2025-05-31 12:00:00', 'Visión borrosa'),
(10, 10, '2025-05-31 12:30:00', 'Dolor muscular');




INSERT INTO Ingreso (paciente_id, habitacion_id, fecha_ingreso, fecha_egreso, diagnostico) VALUES
(1, 1, '2025-05-28 08:00:00', '2025-05-29 08:00:00', 'Hipertensión'),
(2, 2, '2025-05-27 09:00:00', '2025-05-28 09:00:00', 'Gripe'),
(3, 3, '2025-05-26 10:00:00', '2025-05-27 10:00:00', 'Migraña'),
(4, 4, '2025-05-25 11:00:00', '2025-05-26 11:00:00', 'Dermatitis'),
(5, 5, '2025-05-24 12:00:00', '2025-05-25 12:00:00', 'Chequeo'),
(6, 6, '2025-05-23 13:00:00', '2025-05-24 13:00:00', 'Gastritis'),
(7, 7, '2025-05-22 14:00:00', '2025-05-23 14:00:00', 'Vómito'),
(8, 8, '2025-05-21 15:00:00', '2025-05-22 15:00:00', 'Ansiedad'),
(9, 9, '2025-05-20 16:00:00', '2025-05-21 16:00:00', 'Miopía'),
(10, 10, '2025-05-19 17:00:00', '2025-05-20 17:00:00', 'Lesión muscular');

INSERT INTO Medicamento (nombre, descripcion) VALUES
('Paracetamol', 'Analgésico y antipirético'),
('Ibuprofeno', 'Antiinflamatorio no esteroideo'),
('Amoxicilina', 'Antibiótico'),
('Loratadina', 'Antihistamínico'),
('Omeprazol', 'Inhibidor de la bomba de protones'),
('Metformina', 'Control de glucosa'),
('Diazepam', 'Ansiolítico'),
('Salbutamol', 'Broncodilatador'),
('Simvastatina', 'Reductor de colesterol'),
('Acetaminofén', 'Analgésico leve');


INSERT INTO Recipe (consulta_id, fecha) VALUES
(1, '2025-05-31 08:05:00'),
(2, '2025-05-31 08:35:00'),
(3, '2025-05-31 09:05:00'),
(4, '2025-05-31 09:35:00'),
(5, '2025-05-31 10:05:00'),
(6, '2025-05-31 10:35:00'),
(7, '2025-05-31 11:05:00'),
(8, '2025-05-31 11:35:00'),
(9, '2025-05-31 12:05:00'),
(10, '2025-05-31 12:35:00');


INSERT INTO DescripcionReceta (recipe_id, medicamento_id, dosis, frecuencia) VALUES
(1, 1, '500mg', 'Cada 8 horas'),
(2, 2, '400mg', 'Cada 6 horas'),
(3, 3, '250mg', 'Cada 12 horas'),
(4, 4, '10mg', 'Cada 24 horas'),
(5, 5, '20mg', 'Antes del desayuno'),
(6, 6, '850mg', 'Dos veces al día'),
(7, 7, '5mg', 'Una vez al día'),
(8, 8, '2 puffs', 'Cada 6 horas'),
(9, 9, '10mg', 'Antes de dormir'),
(10, 10, '500mg', 'Cada 6 horas');





