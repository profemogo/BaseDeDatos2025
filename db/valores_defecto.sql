-- Insertar tipos de documento
INSERT INTO TipoDocumento (abreviatura) VALUES
('V'),
('P'),
('J'),
('E');

-- Insertar estados civiles
INSERT INTO EstadoCivil (descripcion) VALUES
('Soltero'),
('Casado'),
('Viudo');

-- Insertar tipos de informe
INSERT INTO TipoInforme (codigo) VALUES
( 'ECO-GIN'),
('ECO-MAM'),
('ECO-OBS1'),
('ECO-OBS2'),
('ECO-OBS3'),
('ECO-ABD');

-- Insertar los grupos sanguíneos con su factor Rh
INSERT INTO TipoSangre (tipo) VALUES
-- Grupos con Rh positivo
('A+'),
('B+'),
('AB+'),
('O+'),
-- Grupos con Rh negativo
('A-'),
('B-'),
('AB-'),
('O-');