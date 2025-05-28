-- Insertar tipos de documento
INSERT INTO TipoDocumento (descripcion, abreviatura) VALUES
('Cédula de Identidad', 'V'),
('Pasaporte', 'P'),
('RIF', 'J'),
('Documento Extranjero', 'E');

-- Insertar estados civiles
INSERT INTO EstadoCivil (descripcion) VALUES
('Soltero/a'),
('Casado/a'),
('Viudo/a');

-- Insertar tipos de informe
INSERT INTO TipoInforme (descripcion, codigo) VALUES
('Eco Ginecologico', 'ECO-GIN'),
('Eco Mamario', 'ECO-MAM'),
('Eco Obstetrico Primer Trimestre', 'ECO-OBS1'),
('Eco Obstetrico Segundo Trimestre', 'ECO-OBS2'),
('Eco Obstetrico Tercer Trimestre', 'ECO-OBS3'),
('Eco Abdominal', 'ECO-ABD');

-- Insertar los grupos sanguíneos con su factor Rh
INSERT INTO TipoSangre (descripcion, factor) VALUES
-- Grupos con Rh positivo (factor = TRUE)
('A', TRUE),
('B', TRUE),
('AB', TRUE),
('O', TRUE),
-- Grupos con Rh negativo (factor = FALSE)
('A', FALSE),
('B', FALSE),
('AB', FALSE),
('O', FALSE);