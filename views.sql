CREATE OR REPLACE VIEW VistaGenerosActivos AS
SELECT id, nombre
FROM Genero
WHERE activo = TRUE;

CREATE OR REPLACE VIEW VistaPersonas AS
SELECT p.id, p.nombre, p.apellido, p.dni, g.nombre AS genero
FROM Persona p
LEFT JOIN Genero g ON p.genero_id = g.id;

CREATE OR REPLACE VIEW VistaCorreos AS
SELECT c.id, CONCAT(p.nombre, ' ', p.apellido) AS persona, c.correo,
       CASE WHEN c.principal THEN 'Sí' ELSE 'No' END AS es_principal
FROM Correo c
JOIN Persona p ON c.persona_id = p.id;

CREATE OR REPLACE VIEW VistaTelefonos AS
SELECT t.id, CONCAT(p.nombre, ' ', p.apellido) AS persona, t.telefono,
       CASE WHEN t.principal THEN 'Sí' ELSE 'No' END AS es_principal
FROM Telefono t
JOIN Persona p ON t.persona_id = p.id;

CREATE OR REPLACE VIEW VistaDirecciones AS
SELECT d.id, CONCAT(p.nombre, ' ', p.apellido) AS persona, d.direccion,
       CASE WHEN d.principal THEN 'Sí' ELSE 'No' END AS es_principal
FROM Direccion d
JOIN Persona p ON d.persona_id = p.id;

CREATE OR REPLACE VIEW VistaEspecies AS
SELECT id, nombre
FROM Especie;

CREATE OR REPLACE VIEW VistaGenerosAnimales AS
SELECT id, nombre
FROM GeneroAnimal;

CREATE OR REPLACE VIEW VistaMascotas AS
SELECT m.id, m.nombre, m.edad, e.nombre AS especie, 
       ga.nombre AS genero, m.tamaño
FROM Mascota m
LEFT JOIN Especie e ON m.especie_id = e.id
LEFT JOIN GeneroAnimal ga ON m.genero_animal_id = ga.id;

CREATE OR REPLACE VIEW VistaAdopciones AS
SELECT a.id, m.nombre AS mascota, 
       CONCAT(p.nombre, ' ', p.apellido) AS adoptante,
       a.fecha_adopcion
FROM Adopcion a
JOIN Mascota m ON a.mascota_id = m.id
JOIN Persona p ON a.adoptante_id = p.id;