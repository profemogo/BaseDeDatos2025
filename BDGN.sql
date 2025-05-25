-- Crear la base de datos si no existe
CREATE DATABASE IF NOT EXISTS GestionNotas;

-- Usar la base de datos
USE GestionNotas;

-- Tabla Genero
CREATE TABLE IF NOT EXISTS Genero (
    genero_id INT PRIMARY KEY AUTO_INCREMENT,
    descripcion VARCHAR(50) NOT NULL
);

-- Tabla Grado
CREATE TABLE IF NOT EXISTS Grado (
    grado_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre_grado VARCHAR(50) NOT NULL
);

-- Tabla Seccion
CREATE TABLE IF NOT EXISTS Seccion (
    seccion_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre_seccion VARCHAR(50) NOT NULL
);

-- Tabla Profesor
CREATE TABLE IF NOT EXISTS Profesor (
    profesor_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL,
    apellido VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    telefono VARCHAR(20)
);

-- Tabla Estudiante
CREATE TABLE IF NOT EXISTS Estudiante (
    estudiante_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL,
    apellido VARCHAR(255) NOT NULL,
    fecha_nacimiento DATE,
    genero_id INT,
    grado_id INT,
    seccion_id INT,
    email VARCHAR(255),
    FOREIGN KEY (genero_id) REFERENCES Genero(genero_id),
    FOREIGN KEY (grado_id) REFERENCES Grado(grado_id),
    FOREIGN KEY (seccion_id) REFERENCES Seccion(seccion_id)
);

-- Tabla Asignatura
CREATE TABLE IF NOT EXISTS Asignatura (
    asignatura_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre_asignatura VARCHAR(255) NOT NULL,
    descripcion TEXT
);

-- Tabla AsignaturaGrado (Tabla de cruce para la relación muchos a muchos entre Grado y Asignatura)
CREATE TABLE IF NOT EXISTS AsignaturaGrado (
    asignatura_grado_id INT PRIMARY KEY AUTO_INCREMENT,
    grado_id INT,
    asignatura_id INT,
    FOREIGN KEY (grado_id) REFERENCES Grado(grado_id),
    FOREIGN KEY (asignatura_id) REFERENCES Asignatura(asignatura_id)
);

-- Tabla Nota
CREATE TABLE IF NOT EXISTS Nota (
    nota_id INT PRIMARY KEY AUTO_INCREMENT,
    estudiante_id INT,
    asignatura_id INT,
    profesor_id INT,
    valor_nota DECIMAL(5, 2) NOT NULL,
    fecha_nota DATE NOT NULL,
    FOREIGN KEY (estudiante_id) REFERENCES Estudiante(estudiante_id),
    FOREIGN KEY (asignatura_id) REFERENCES Asignatura(asignatura_id),
    FOREIGN KEY (profesor_id) REFERENCES Profesor(profesor_id)
);

-- Tabla Auditoria
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
-- Agregar restricción para añadir valor de la nota
ALTER TABLE Nota
ADD CONSTRAINT CHK_ValorNota_Max20
CHECK (valor_nota >= 0 AND valor_nota <= 20);

-- Agregar restricciones UNIQUE usando ALTER TABLE
ALTER TABLE Grado
ADD CONSTRAINT uc_grado_nombre_grado UNIQUE (nombre_grado);

ALTER TABLE Seccion
ADD CONSTRAINT uc_seccion_nombre_seccion UNIQUE (nombre_seccion);

ALTER TABLE Profesor
ADD CONSTRAINT uc_profesor_email UNIQUE (email);

ALTER TABLE Estudiante
ADD CONSTRAINT uc_estudiante_email UNIQUE (email);

ALTER TABLE Asignatura
ADD CONSTRAINT uc_asignatura_nombre UNIQUE (nombre_asignatura);

-- 1. Insertar un nuevo estudiante con su información básica y una nota.
INSERT INTO Estudiante (nombre, apellido, fecha_nacimiento, genero_id, grado_id, seccion_id, email)
VALUES ('Carlos', 'Pérez', '2008-05-15', 1, 2, 1, 'carlos.perez@email.com');

INSERT INTO Nota (estudiante_id, asignatura_id, profesor_id, valor_nota, fecha_nota)
VALUES ((SELECT estudiante_id FROM Estudiante WHERE nombre = 'Carlos' AND apellido = 'Pérez'), 1, 2, 17.5, CURDATE());

-- 2. Insertar otro estudiante con su información y múltiples notas en diferentes asignaturas.
INSERT INTO Estudiante (nombre, apellido, fecha_nacimiento, genero_id, grado_id, seccion_id, email)
VALUES ('Ana', 'Gómez', '2007-11-20', 2, 3, 2, 'ana.gomez@email.com');

INSERT INTO Nota (estudiante_id, asignatura_id, profesor_id, valor_nota, fecha_nota)
VALUES ((SELECT estudiante_id FROM Estudiante WHERE nombre = 'Ana' AND apellido = 'Gómez'), 2, 1, 19.0, CURDATE());

INSERT INTO Nota (estudiante_id, asignatura_id, profesor_id, valor_nota, fecha_nota)
VALUES ((SELECT estudiante_id FROM Estudiante WHERE nombre = 'Ana' AND apellido = 'Gómez'), 3, 3, 16.8, CURDATE());

-- 3. Insertar un estudiante más con su información y una nota en una asignatura específica.
INSERT INTO Estudiante (nombre, apellido, fecha_nacimiento, genero_id, grado_id, seccion_id, email)
VALUES ('Luis', 'Rodríguez', '2009-02-10', 1, 1, 3, 'luis.rodriguez@email.com');

INSERT INTO Nota (estudiante_id, asignatura_id, profesor_id, valor_nota, fecha_nota)
VALUES ((SELECT estudiante_id FROM Estudiante WHERE nombre = 'Luis' AND apellido = 'Rodríguez'), 4, 2, 15.5, CURDATE());

-- 4. Insertar un estudiante con información y una nota asignada por un profesor diferente.
INSERT INTO Estudiante (nombre, apellido, fecha_nacimiento, genero_id, grado_id, seccion_id, email)
VALUES ('Sofía', 'Martínez', '2008-08-25', 2, 2, 2, 'sofia.martinez@email.com');

INSERT INTO Nota (estudiante_id, asignatura_id, profesor_id, valor_nota, fecha_nota)
VALUES ((SELECT estudiante_id FROM Estudiante WHERE nombre = 'Sofía' AND apellido = 'Martínez'), 1, 3, 18.2, CURDATE());

-- 5. Insertar el último estudiante con su información y una nota para una asignatura diferente.
INSERT INTO Estudiante (nombre, apellido, fecha_nacimiento, genero_id, grado_id, seccion_id, email)
VALUES ('Daniel', 'López', '2007-04-01', 1, 3, 1, 'daniel.lopez@email.com');

INSERT INTO Nota (estudiante_id, asignatura_id, profesor_id, valor_nota, fecha_nota)
VALUES ((SELECT estudiante_id FROM Estudiante WHERE nombre = 'Daniel' AND apellido = 'López'), 3, 1, 17.0, CURDATE());

--  INSERTS para todas las tablas (CORREGIDOS para AUTO_INCREMENT)

--  Tabla Grado (grado_id es probablemente AUTO_INCREMENT)
INSERT INTO `Grado` (`nombre_grado`) VALUES 
    ('1er Grado'),
    ('2do Grado'),
    ('3er Grado'),
    ('4to Grado'),
    ('5to Grado'),
    ('6to Grado');

--  Tabla Seccion (seccion_id es probablemente AUTO_INCREMENT)
INSERT INTO `Seccion` (`nombre_seccion`) VALUES 
    ('A'),
    ('B'),
    ('C'),
    ('D');

--  Tabla Genero (genero_id es probablemente AUTO_INCREMENT)
INSERT INTO `Genero` (`nombre_genero`) VALUES 
    ('Masculino'),
    ('Femenino'),
    ('Otro');

--  Tabla Asignatura (asignatura_id es AUTO_INCREMENT)
INSERT INTO `Asignatura` (`nombre_asignatura`, `descripcion`) VALUES 
    ('Matemáticas', 'Estudio de los números y las operaciones.'),
    ('Lenguaje', 'Estudio de la gramática y la literatura.'),
    ('Ciencias Naturales', 'Estudio de la biología, la química y la física.'),
    ('Ciencias Sociales', 'Estudio de la historia, la geografía y la economía.'),
    ('Inglés', 'Estudio del idioma inglés.'),
    ('Educación Física', 'Desarrollo de habilidades físicas y deportivas.'),
    ('Arte', 'Desarrollo de habilidades artísticas.'),
    ('Música', 'Desarrollo de habilidades musicales.');

--  Tabla Estudiante (estudiante_id es AUTO_INCREMENT)
INSERT INTO `Estudiante` 
    (`email`, `nombre`, `apellido`, `grado_id`, `telefono`, `direccion`, `genero_id`, `seccion_id`, `fecha_nacimiento`) 
VALUES 
    ('juan.perez@email.com', 'Juan', 'Pérez', 1, '555-1234', 'Calle 1 #123', 1, 1, '2010-05-15'),
    ('maria.gonzalez@email.com', 'María', 'González', 1, '555-5678', 'Avenida 2 #456', 2, 2, '2010-08-20'),
    ('carlos.rodriguez@email.com', 'Carlos', 'Rodríguez', 2, '555-9012', 'Carrera 3 #789', 1, 3, '2009-02-10'),
    ('ana.martinez@email.com', 'Ana', 'Martínez', 2, '555-2345', 'Transversal 4 #101', 2, 1, '2009-07-25'),
    ('luis.lopez@email.com', 'Luis', 'López', 3, '555-6789', 'Diagonal 5 #202', 1, 2, '2008-11-30'),
    ('sofia.sanchez@email.com', 'Sofía', 'Sánchez', 3, '555-0123', 'Circular 6 #303', 2, 3, '2008-04-05'),
    ('pedro.ramirez@email.com', 'Pedro', 'Ramírez', 4, '555-3456', 'Calle 7 #404', 1, 1, '2007-09-10'),
    ('laura.flores@email.com', 'Laura', 'Flores', 4, '555-7890', 'Avenida 8 #505', 2, 2, '2007-12-15'),
    ('diego.torres@email.com', 'Diego', 'Torres', 5, '555-1234', 'Carrera 9 #606', 1, 3, '2006-06-20'),
    ('valentina.diaz@email.com', 'Valentina', 'Díaz', 5, '555-5678', 'Transversal 10 #707', 2, 1, '2006-01-25'),
    ('javier.hernandez@email.com', 'Javier', 'Hernández', 6, '555-9012', 'Diagonal 11 #808', 1, 2, '2005-08-30'),
    ('isabella.ortega@email.com', 'Isabella', 'Ortega', 6, '555-2345', 'Circular 12 #909', 2, 3, '2005-03-05'),
    ('sebastian.gomez@email.com', 'Sebastián', 'Gómez', 1, '555-6789', 'Calle 13 #1010', 1, 3, '2010-06-10'),
    ('camila.silva@email.com', 'Camila', 'Silva', 1, '555-0123', 'Avenida 14 #1111', 2, 4, '2010-09-15'),
    ('andres.vargas@email.com', 'Andrés', 'Vargas', 2, '555-3456', 'Carrera 15 #1212', 1, 2, '2009-03-20'),
    ('daniela.castro@email.com', 'Daniela', 'Castro', 2, '555-7890', 'Transversal 16 #1313', 2, 4, '2009-08-25'),
    ('martin.rojas@email.com', 'Martín', 'Rojas', 3, '555-1234', 'Diagonal 17 #1414', 1, 1, '2008-12-30'),
    ('florencia.nunez@email.com', 'Florencia', 'Núñez', 3, '555-5678', 'Circular 18 #1515', 2, 4, '2008-05-05'),
    ('tomas.aguilar@email.com', 'Tomás', 'Aguilar', 4, '555-9012', 'Calle 19 #1616', 1, 2, '2007-10-10'),
    ('valeria.molina@email.com', 'Valeria', 'Molina', 4, '555-2345', 'Avenida 20 #1717', 2, 4, '2007-01-15'),
    ('samuel.navarro@email.com', 'Samuel', 'Navarro', 5, '555-6789', 'Carrera 21 #1818', 1, 3, '2006-07-20'),
    ('olivia.benavides@email.com', 'Olivia', 'Benavides', 5, '555-0123', 'Transversal 22 #1919', 2, 4, '2006-02-25'),
    ('matias.paredes@email.com', 'Matías', 'Paredes', 6, '555-3456', 'Diagonal 23 #2020', 1, 1, '2005-09-30'),
    ('emilia.soto@email.com', 'Emilia', 'Soto', 6, '555-7890', 'Circular 24 #2121', 2, 4, '2005-04-05')
    ;

--  Tabla AsignaturaGrado (asignatura_grado_id es AUTO_INCREMENT)
INSERT INTO `AsignaturaGrado` (`grado_id`, `asignatura_id`) VALUES 
    (1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (1, 7), (1, 8),
    (2, 1), (2, 2), (2, 3), (2, 4), (2, 5), (2, 6), (2, 7),
    (3, 1), (3, 2), (3, 3), (3, 4), (3, 5), (3, 6), (4, 1),
    (4, 2), (4, 3), (4, 4), (4, 5), (5, 1), (5, 2), (5, 3),
    (5, 4), (6, 1), (6, 2), (6, 3);

--  Tabla Nota (nota_id es AUTO_INCREMENT)
INSERT INTO `Nota` (`estudiante_id`, `asignatura_grado_id`, `valor_nota`, `fecha_nota`) VALUES 
    (1, 1, 85.00, '2025-05-10'), (1, 2, 92.00, '2025-05-10'), (1, 3, 78.00, '2025-05-10'), (1, 4, 88.00, '2025-05-10'), (1, 5, 95.00, '2025-05-10'), (1, 6, 89.00, '2025-05-10'), (1, 7, 91.00, '2025-05-10'), (1, 8, 84.00, '2025-05-10'),
    (2, 1, 76.00, '2025-05-10'), (2, 2, 80.00, '2025-05-10'), (2, 3, 90.00, '2025-05-10'), (2, 4, 82.00, '2025-05-10'), (2, 5, 87.00, '2025-05-10'), (2, 6, 94.00, '2025-05-10'), (2, 7, 79.00, '2025-05-10'), (2, 8, 88.00, '2025-05-10'),
    (3, 1, 92.00, '2025-05-10'), (3, 2, 85.00, '2025-05-10'), (3, 3, 78.00, '2025-05-10'), (3, 4, 89.00, '2025-05-10'), (3, 5, 91.00, '2025-05-10'), (3, 6, 84.00, '2025-05-10'), (3, 7, 80.00, '2025-05-10'),
    (4, 1, 77.00, '2025-05-10'), (4, 2, 82.00, '2025-05-10'), (4, 3, 88.00, '2025-05-10'), (4, 4, 93.00, '2025-05-10'), (4, 5, 79.00, '2025-05-10'), (4, 6, 86.00, '2025-05-10'), (4, 7, 90.00, '2025-05-10'),
    (5, 1, 84.00, '2025-05-10'), (5, 2, 89.00, '2025-05-10'), (5, 3, 92.00, '2025-05-10'), (5, 4, 78.00, '2025-05-10'), (5, 5, 85.00, '2025-05-10'), (5, 6, 81.00, '2025-05-10'),
    (6, 1, 79.00, '2025-05-10'), (6, 2, 83.00, '2025-05-10'), (6, 3, 87.00, '2025-05-10'), (13, 1, 90.00, '2025-05-10'), (13, 2, 88.00, '2025-05-10'), (13, 3, 86.00, '2025-05-10'), (13, 4, 92.00, '2025-05-10'), (13, 5, 89.00, '2025-05-10'), (13, 6, 87.00, '2025-05-10'), (13, 7, 91.00, '2025-05-10'), (13, 8, 85.00, '2025-05-10'),
    (14, 1, 78.00, '2025-05-10'), (14, 2, 82.00, '2025-05-10'), (14, 3, 80.00, '2025-05-10'), (14, 4, 84.00, '2025-05-10'), (14, 5, 86.00, '2025-05-10'), (14, 6, 90.00, '2025-05-10'), (14, 7, 83.00, '2025-05-10'), (15, 1, 89.00, '2025-05-10'), (15, 2, 85.00, '2025-05-10'), (15, 3, 79.00, '2025-05-10'), (15, 4, 81.00, '2025-05-10'), (15, 5, 87.00, '2025-05-10'), (15, 6, 92.00, '2025-05-10'), (15, 7, 88.00, '2025-05-10'),
    (16, 1, 82.00, '2025-05-10'), (16, 2, 80.00, '2025-05-10'), (16, 3, 84.00, '2025-05-10'), (16, 4, 88.00, '2025-05-10'), (16, 5, 91.00, '2025-05-10'), (16, 6, 89.00, '2025-05-10'), (16, 7, 86.00, '2025-05-10'), (17, 1, 75.00, '2025-05-10

--consultas con where
-- Consultas WHERE enfocadas en la búsqueda de nombres en GestionNotas

-- 1. Búsqueda exacta de un estudiante por nombre:
SELECT estudiante_id, nombre, apellido
FROM Estudiante
WHERE nombre = 'Juan';

-- 2. Búsqueda exacta de un estudiante por apellido:
SELECT estudiante_id, nombre, apellido
FROM Estudiante
WHERE apellido = 'Pérez';

-- 3. Búsqueda de estudiantes cuyo nombre comienza con:
SELECT estudiante_id, nombre, apellido
FROM Estudiante
WHERE nombre LIKE 'An%';  -- Ejemplo: Nombres que comienzan con "An"

-- 4. Búsqueda de estudiantes cuyo apellido contiene:
SELECT estudiante_id, nombre, apellido
FROM Estudiante
WHERE apellido LIKE '%ez';  -- Ejemplo: Apellidos que contienen "ez" al final

-- 5. Búsqueda de estudiantes por nombre o apellido (exacto):
SELECT estudiante_id, nombre, apellido
FROM Estudiante
WHERE nombre = 'María' OR apellido = 'González';

-- 6. Búsqueda insensible a mayúsculas y minúsculas de un estudiante por nombre (MySQL):
SELECT estudiante_id, nombre, apellido
FROM Estudiante
WHERE LOWER(nombre) = LOWER('juan');

-- 7. Búsqueda insensible a mayúsculas y minúsculas de un estudiante por apellido (MySQL):
SELECT estudiante_id, nombre, apellido
FROM Estudiante
WHERE LOWER(apellido) = LOWER('pérez');

-- 8. Búsqueda de profesores por nombre (exacto):
SELECT profesor_id, nombre, apellido
FROM Profesor
WHERE nombre = 'Carlos';

-- 9. Búsqueda de profesores por apellido (comienza con):
SELECT profesor_id, nombre, apellido
FROM Profesor
WHERE apellido LIKE 'L%';  -- Ejemplo: Apellidos que comienzan con "L"

-- 10. Búsqueda de profesores por nombre o apellido (insensible - MySQL):
SELECT profesor_id, nombre, apellido
FROM Profesor
WHERE LOWER(nombre) = LOWER('ana') OR LOWER(apellido) = LOWER('rodríguez');

-- 11. Estudiantes con nombres de una longitud específica:
SELECT estudiante_id, nombre
FROM Estudiante
WHERE LENGTH(nombre) = 4;  -- Ejemplo: Nombres con 4 caracteres

-- 12. Estudiantes con nombres que contienen un patrón específico (insensible - MySQL):
SELECT estudiante_id, nombre
FROM Estudiante
WHERE LOWER(nombre) LIKE LOWER('%art%');  -- Ejemplo: Nombres que contienen "art"

-- 13. Estudiantes con nombres que terminan con una letra:
SELECT estudiante_id, nombre
FROM Estudiante
WHERE nombre LIKE '%a';  -- Ejemplo: Nombres que terminan con "a"

-- 14. Profesores con apellidos que contienen un patrón específico (sensible):
SELECT profesor_id, apellido
FROM Profesor
WHERE apellido LIKE '%and%'; -- Ejemplo: Apellidos que contienen "and"

-- 15. Profesores cuyo nombre no es un valor específico:
SELECT profesor_id, nombre
FROM Profesor
WHERE nombre <> 'David';  -- O también WHERE nombre != 'David'

-- 16. Estudiantes cuyo nombre no comienza con una letra:
SELECT estudiante_id, nombre
FROM Estudiante
WHERE NOT nombre LIKE 'M%';  -- O también WHERE nombre NOT LIKE 'M%'
--  Creación de Índices recomendados para la base de datos GestionNotas

--  Índice compuesto para nombre y apellido de estudiante
CREATE INDEX idx_estudiante_nombre_apellido ON Estudiante (nombre, apellido);

--  Índices separados para grado_id y seccion_id
CREATE INDEX idx_estudiante_grado_id ON Estudiante (grado_id);
CREATE INDEX idx_estudiante_seccion_id ON Estudiante (seccion_id);

--  Índice para fecha_nacimiento
CREATE INDEX idx_estudiante_fecha_nacimiento ON Estudiante (fecha_nacimiento);

--  Índices funcionales para búsqueda insensible (CONSIDERAR - PRUEBA NECESARIA)
CREATE INDEX idx_estudiante_lower_nombre ON Estudiante ((LOWER(nombre)));
CREATE INDEX idx_estudiante_lower_apellido ON Estudiante ((LOWER(apellido)));
-- Consultas Básicas:

-- 1. Obtener todos los Estudiante:
SELECT * FROM Estudiante;

-- 2. Obtener todos los Profesor:
SELECT * FROM Profesor;

-- 3. Obtener todas las Asignatura:
SELECT * FROM Asignatura;

-- 4. Obtener todos los Grado:
SELECT * FROM Grado;

-- 5. Obtener todas las Seccion:
SELECT * FROM Seccion;

-- 6. Obtener todos los géneros:
SELECT * FROM Genero;

-- 7. Obtener todas las Nota:
SELECT * FROM Nota;


-- Consultas con JOINs:

-- 8. Obtener Estudiante con su grado y sección:
SELECT
    e.estudiante_id,
    e.nombre,
    e.apellido,
    g.nombre_grado,
    s.nombre_seccion
FROM
    Estudiante e
JOIN
    Grado g ON e.grado_id = g.grado_id
JOIN
    Seccion s ON e.seccion_id = s.seccion_id;

-- 9. Obtener Estudiante con su género:
SELECT
    e.estudiante_id,
    e.nombre,
    e.apellido,
    g.nombre_genero
FROM
    Estudiante e
JOIN
    Genero g ON e.genero_id = g.genero_id;

-- 10. Obtener Nota con el nombre del estudiante y la asignatura:
SELECT
    n.nota_id,
    n.valor_nota,
    e.nombre AS nombre_estudiante,
    e.apellido AS apellido_estudiante,
    a.nombre_asignatura
FROM
    Nota n
JOIN
    Estudiante e ON n.estudiante_id = e.estudiante_id
JOIN
    Asignatura a ON n.asignatura_id = a.asignatura_id;

-- 11. Obtener Nota con el nombre del profesor:
SELECT
    n.nota_id,
    n.valor_nota,
    p.nombre AS nombre_profesor,
    p.apellido AS apellido_profesor,
    a.nombre_asignatura
FROM
    Nota n
JOIN
    Profesor p ON n.profesor_id = p.profesor_id
JOIN
    Asignatura a ON n.asignatura_id = a.asignatura_id;

-- 12. Obtener Asignatura con los Grado en que se imparten:
SELECT
    a.nombre_asignatura,
    g.nombre_grado
FROM
    Asignatura a
JOIN
    AsignaturaGrado ag ON a.asignatura_id = ag.asignatura_id
JOIN
    Grado g ON ag.grado_id = g.grado_id;

-- Consultas con Filtros (WHERE):

-- 13. Obtener Estudiante de un grado específico:
SELECT
    e.estudiante_id,
    e.nombre,
    e.apellido
FROM
    Estudiante e
WHERE
    e.grado_id = 2; -- Ejemplo: Estudiante de 2do grado

-- 14. Obtener Estudiante de una sección específica:
SELECT
    e.estudiante_id,
    e.nombre,
    e.apellido
FROM
    Estudiante e
WHERE
    e.seccion_id = 1; -- Ejemplo: Estudiante de la sección A

-- 15. Obtener Estudiante de un género específico:
SELECT
    e.estudiante_id,
    e.nombre,
    e.apellido
FROM
    Estudiante e
WHERE
    e.genero_id = 2; -- Ejemplo: Estudiante de género Femenino

-- 16. Obtener Nota de un estudiante específico:
SELECT
    n.nota_id,
    n.valor_nota,
    a.nombre_asignatura
FROM
    Nota n
JOIN
    Asignatura a ON n.asignatura_id = a.asignatura_id
WHERE
    n.estudiante_id = 3; -- Ejemplo: Nota del estudiante con ID 101

-- 17. Obtener Nota de una asignatura específica:
SELECT
    n.nota_id,
    n.valor_nota,
    e.nombre,
    e.apellido
FROM
    Nota n
JOIN
    Estudiante e ON n.estudiante_id = e.estudiante_id
WHERE
    n.asignatura_id = 3; -- Ejemplo: Nota de la asignatura con ID 201

-- 18. Obtener Nota asignadas por un profesor específico:
SELECT
    n.nota_id,
    n.valor_nota,
    e.nombre,
    e.apellido,
    a.nombre_asignatura
FROM
    Nota n
JOIN
    Estudiante e ON n.estudiante_id = e.estudiante_id
JOIN
    Asignatura a ON n.asignatura_id = a.asignatura_id
WHERE
    n.profesor_id = 2; -- Ejemplo: Nota del profesor con ID 301

-- 19. Obtener Estudiante nacidos después de una fecha:
SELECT
    e.estudiante_id,
    e.nombre,
    e.apellido,
    e.fecha_nacimiento
FROM
    Estudiante e
WHERE
    e.fecha_nacimiento > '2005-01-01';

-- Consultas con Ordenamiento (ORDER BY):

-- 20. Obtener Estudiante ordenados por apellido:
SELECT
    e.estudiante_id,
    e.nombre,
    e.apellido
FROM
    Estudiante e
ORDER BY
    e.apellido ASC;

-- 21. Obtener Nota ordenadas por valor de nota (descendente):
SELECT
    n.nota_id,
    n.valor_nota,
    e.nombre,
    e.apellido,
    a.nombre_asignatura
FROM
    Nota n
JOIN
    Estudiante e ON n.estudiante_id = e.estudiante_id
JOIN
    Asignatura a ON n.asignatura_id = a.asignatura_id
ORDER BY
    n.valor_nota DESC;

-- Consultas Agregadas (GROUP BY, COUNT, AVG, MAX, MIN):

-- 22. Contar el número de Estudiante por grado:
SELECT
    g.nombre_grado,
    COUNT(e.estudiante_id) AS cantidad_Estudiante
FROM
    Estudiante e
JOIN
    Grado g ON e.grado_id = g.grado_id
GROUP BY
    g.nombre_grado;

-- 23. Calcular el promedio de Nota por estudiante:
SELECT
    e.estudiante_id,
    e.nombre,
    e.apellido,
    AVG(n.valor_nota) AS promedio_nota
FROM
    Nota n
JOIN
    Estudiante e ON n.estudiante_id = e.estudiante_id
GROUP BY
    e.estudiante_id,
    e.nombre,
    e.apellido;

-- 24. Obtener la nota máxima y mínima por asignatura:
SELECT
    a.nombre_asignatura,
    MAX(n.valor_nota) AS nota_maxima,
    MIN(n.valor_nota) AS nota_minima
FROM
    Nota n
JOIN
    Asignatura a ON n.asignatura_id = a.asignatura_id
GROUP BY
    a.nombre_asignatura;

-- Consultas con Subconsultas:

-- 25. Obtener Estudiante con Nota por encima del promedio general:
SELECT
    e.estudiante_id,
    e.nombre,
    e.apellido
FROM
    Estudiante e
WHERE
    e.estudiante_id IN (
        SELECT
            n.estudiante_id
        FROM
            Nota n
        WHERE
            n.valor_nota > (SELECT AVG(valor_nota) FROM Nota)
    );

Búsquedas usando los índices: 

-- 1. Buscar estudiantes por apellido:
SELECT estudiante_id, nombre, apellido
FROM Estudiante
WHERE apellido = 'Fernández';  

-- 2. Buscar estudiantes en un grado específico:
SELECT estudiante_id, nombre, apellido
FROM Estudiante
WHERE grado_id = 1;  

-- 3. Buscar estudiantes en una sección específica:
SELECT estudiante_id, nombre, apellido
FROM Estudiante
WHERE seccion_id = 2;  

-- 4. Buscar estudiantes de un género específico:
SELECT estudiante_id, nombre, apellido
FROM Estudiante
WHERE genero_id = 1;  

-- 5. Buscar profesor por apellido:
SELECT profesor_id, nombre, apellido
FROM Profesor
WHERE apellido = 'Perez';  

-- 6. Buscar profesor por email (búsqueda única):
SELECT profesor_id, nombre
FROM Profesor
WHERE email = 'juan.perez@email.com';  

-- 7. Buscar asignatura por nombre:
SELECT asignatura_id, nombre_asignatura
FROM Asignatura
WHERE nombre_asignatura = 'Matemáticas';

-- 8. Obtener notas de un estudiante específico:
SELECT nota_id, valor_nota
FROM Nota
WHERE estudiante_id = 1;  

-- 9. Obtener notas de una asignatura específica:
SELECT nota_id, valor_nota
FROM Nota
WHERE asignatura_id = 2;

-- 10. Obtener notas asignadas por un profesor específico:
SELECT nota_id, valor_nota
FROM Nota
WHERE profesor_id = 1;  

-- 11. Obtener notas en un rango de fechas:
SELECT nota_id, valor_nota
FROM Nota
WHERE fecha_nota BETWEEN '2023-05-10' AND '2023-05-15';  

-- 12. Obtener asignaturas impartidas en un grado específico:
SELECT a.asignatura_id, a.nombre_asignatura
FROM Asignatura a
JOIN AsignaturaGrado ag ON a.asignatura_id = ag.asignatura_id
WHERE ag.grado_id = 2;  

--  Consultas que se benefician de los índices creados

--  Búsquedas por nombre/apellido
SELECT estudiante_id, nombre, apellido FROM Estudiante WHERE nombre = 'Juan';
SELECT estudiante_id, nombre, apellido FROM Estudiante WHERE apellido LIKE 'Pé%';
SELECT estudiante_id, nombre, apellido FROM Estudiante WHERE nombre = 'María' OR apellido = 'González';

--  Búsquedas insensibles (MEJOR con índices funcionales)
SELECT estudiante_id, nombre, apellido FROM Estudiante WHERE LOWER(nombre) = LOWER('juan');
SELECT estudiante_id, nombre, apellido FROM Estudiante WHERE LOWER(apellido) = LOWER('pérez');

--  Búsquedas por grado/sección
SELECT estudiante_id, nombre FROM Estudiante WHERE grado_id = 3;
SELECT estudiante_id, nombre FROM Estudiante WHERE seccion_id = 2;

--  Búsquedas por fecha de nacimiento
SELECT estudiante_id, nombre FROM Estudiante WHERE fecha_nacimiento > '2009-01-01';

--  Consultas con JOIN (siempre se benefician de índices en claves foráneas)
SELECT AG.asignatura_id, A.nombre_asignatura
FROM AsignaturaGrado AG
JOIN Asignatura A ON AG.asignatura_id = A.asignatura_id
WHERE AG.grado_id = 4;

---Consultas con funciones
-- =============================================================================
--  Consultas SQL sencillas utilizando funciones integradas (AVG, LOWER, etc.)
-- =============================================================================

-- 1. Utilidad: Obtiene el promedio de todas las notas en la tabla Nota (escala 0-20). (AVG)
SELECT AVG(valor_nota) AS promedio_general_notas_sobre_20 FROM Nota;

-- 2. Utilidad: Convierte el nombre de una asignatura a minúsculas. (LOWER)
-- Ejemplo con la asignatura 'Matemáticas' (Asignatura ID 1)
SELECT LOWER(nombre_asignatura) AS asignatura_en_minusculas
FROM Asignatura
WHERE asignatura_id = 1;

-- 3. Utilidad: Obtiene la nota máxima registrada en la tabla Nota (escala 0-20). (MAX)
SELECT MAX(valor_nota) AS nota_maxima_global_sobre_20 FROM Nota;

-- 4. Utilidad: Obtiene la nota mínima registrada en la tabla Nota (escala 0-20). (MIN)
SELECT MIN(valor_nota) AS nota_minima_global_sobre_20 FROM Nota;

-- 5. Utilidad: Cuenta el número total de estudiantes. (COUNT)
SELECT COUNT(estudiante_id) AS total_estudiantes FROM Estudiante;

-- 6. Utilidad: Convierte el apellido de un estudiante a mayúsculas. (UPPER)
-- Ejemplo con el Estudiante ID 1
SELECT UPPER(apellido) AS apellido_en_mayusculas
FROM Estudiante
WHERE estudiante_id = 1;

-- 7. Utilidad: Obtiene la longitud del nombre de una sección. (LENGTH)
-- Ejemplo con la Sección ID 1
SELECT LENGTH(nombre_seccion) AS longitud_nombre_seccion
FROM Seccion
WHERE seccion_id = 1;

-- 8. Utilidad: Concatena nombre y apellido de un profesor con un prefijo. (CONCAT)
-- Ejemplo con el Profesor ID 1
SELECT CONCAT('Prof. ', nombre, ' ', apellido) AS nombre_profesor_con_prefijo
FROM Profesor
WHERE profesor_id = 1;

-- 9. Utilidad: Extrae los primeros N caracteres de una dirección de estudiante. (SUBSTRING)
-- Ejemplo con el Estudiante ID 2 y 10 caracteres
SELECT SUBSTRING(direccion, 1, 10) AS inicio_direccion
FROM Estudiante
WHERE estudiante_id = 2;

-- 10. Utilidad: Redondea una nota al entero más cercano (considerando escala 0-20). (ROUND)
-- Ejemplo con una nota de 17.6
SELECT ROUND(17.6) AS nota_redondeada;

-- 11. Utilidad: Obtiene el día de la semana de una fecha de nota. (DAYOFWEEK)
-- Ejemplo con Nota ID 1 (asumiendo fecha_nota = '2025-05-10' es un sábado)
SELECT DAYOFWEEK(fecha_nota) AS dia_semana_nota
FROM Nota
WHERE nota_id = 1; -- 1=Domingo, 2=Lunes, etc.

-- 12. Utilidad: Calcula la cantidad de años desde una fecha de nacimiento hasta hoy. (TIMESTAMPDIFF)
-- Ejemplo con el Estudiante ID 3
SELECT TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE()) AS edad_estudiante_anios
FROM Estudiante
WHERE estudiante_id = 3;

-- 13. Utilidad: Obtiene el techo (entero superior) de una nota (considerando escala 0-20). (CEIL)
-- Ejemplo con una nota de 15.1
SELECT CEIL(15.1) AS techo_nota;

-- 14. Utilidad: Obtiene el piso (entero inferior) de una nota (considerando escala 0-20). (FLOOR)
-- Ejemplo con una nota de 19.9
SELECT FLOOR(19.9) AS piso_nota;

-- 15. Utilidad: Convierte un valor numérico de género a una cadena de texto. (CASE)
-- Ejemplo con el Estudiante ID 1 (asumiendo genero_id 1 es Masculino)
SELECT
    CASE E.genero_id
        WHEN 1 THEN 'Masculino'
        WHEN 2 THEN 'Femenino'
        ELSE 'Desconocido'
    END AS nombre_genero_texto
FROM Estudiante E
WHERE E.estudiante_id = 1;

-- =============================================================================
--  TRIGGERS PARA LA BASE DE DATOS GESTIONNOTAS
-- =============================================================================

-- 1. Trigger: Validar Valor de Nota antes de Insertar/Actualizar
-- Utilidad: Asegura que la nota esté dentro del rango 0-20.
-- Tipo: BEFORE INSERT, BEFORE UPDATE en la tabla Nota.
DELIMITER //
CREATE TRIGGER trg_Nota_CheckValor
BEFORE INSERT ON Nota
FOR EACH ROW
BEGIN
    IF NEW.valor_nota < 0 OR NEW.valor_nota > 20 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El valor de la nota debe estar entre 0 y 20.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_Nota_CheckValor_Update
BEFORE UPDATE ON Nota
FOR EACH ROW
BEGIN
    IF NEW.valor_nota < 0 OR NEW.valor_nota > 20 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El valor de la nota debe estar entre 0 y 20.';
    END IF;
END //
DELIMITER ;

-- 2. Trigger: Registrar fecha de creación de estudiante (si no se proporciona)
-- Utilidad: Establece automáticamente la fecha de creación del registro del estudiante.
-- Tipo: BEFORE INSERT en la tabla Estudiante.
DELIMITER //
CREATE TRIGGER trg_Estudiante_SetFechaNacimiento
BEFORE INSERT ON Estudiante
FOR EACH ROW
BEGIN
    IF NEW.fecha_nacimiento IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha de nacimiento del estudiante no puede ser nula.';
    END IF;
END //
DELIMITER ;

-- 3. Trigger: Convertir email de profesor a minúsculas antes de insertar/actualizar
-- Utilidad: Estandariza los emails de los profesores a minúsculas.
-- Tipo: BEFORE INSERT, BEFORE UPDATE en la tabla Profesor.
DELIMITER //
CREATE TRIGGER trg_Profesor_EmailLowerCase
BEFORE INSERT ON Profesor
FOR EACH ROW
BEGIN
    SET NEW.email = LOWER(NEW.email);
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_Profesor_EmailLowerCase_Update
BEFORE UPDATE ON Profesor
FOR EACH ROW
BEGIN
    SET NEW.email = LOWER(NEW.email);
END //
DELIMITER ;

-- 4. Trigger: Validar que el nombre del grado no esté vacío
-- Utilidad: Asegura que el nombre de un grado no sea una cadena vacía.
-- Tipo: BEFORE INSERT, BEFORE UPDATE en la tabla Grado.
DELIMITER //
CREATE TRIGGER trg_Grado_CheckNombreNotEmpty
BEFORE INSERT ON Grado
FOR EACH ROW
BEGIN
    IF NEW.nombre_grado IS NULL OR TRIM(NEW.nombre_grado) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El nombre del grado no puede estar vacío.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_Grado_CheckNombreNotEmpty_Update
BEFORE UPDATE ON Grado
FOR EACH ROW
BEGIN
    IF NEW.nombre_grado IS NULL OR TRIM(NEW.nombre_grado) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El nombre del grado no puede estar vacío.';
    END IF;
END //
DELIMITER ;

-- 5. Trigger: Prevenir la eliminación de grados si tienen estudiantes asociados
-- Utilidad: Mantiene la integridad referencial para los grados.
-- Tipo: BEFORE DELETE en la tabla Grado.
DELIMITER //
CREATE TRIGGER trg_Grado_PreventDeleteIfEstudiantes
BEFORE DELETE ON Grado
FOR EACH ROW
BEGIN
    DECLARE num_estudiantes INT;
    SELECT COUNT(*) INTO num_estudiantes FROM Estudiante WHERE grado_id = OLD.grado_id;
    IF num_estudiantes > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar este grado porque tiene estudiantes asociados.';
    END IF;
END //
DELIMITER ;

-- 6. Trigger: Prevenir la eliminación de asignaturas si tienen asociaciones con grados
-- Utilidad: Mantiene la integridad referencial para las asignaturas.
-- Tipo: BEFORE DELETE en la tabla Asignatura.
DELIMITER //
CREATE TRIGGER trg_Asignatura_PreventDeleteIfGradoAsociado
BEFORE DELETE ON Asignatura
FOR EACH ROW
BEGIN
    DECLARE num_asig_grado INT;
    SELECT COUNT(*) INTO num_asig_grado FROM AsignaturaGrado WHERE asignatura_id = OLD.asignatura_id;
    IF num_asig_grado > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar esta asignatura porque está asociada a uno o más grados.';
    END IF;
END //
DELIMITER ;

-- 7. Trigger: Prevenir la eliminación de secciones si tienen estudiantes asociados
-- Utilidad: Mantiene la integridad referencial para las secciones.
-- Tipo: BEFORE DELETE en la tabla Seccion.
DELIMITER //
CREATE TRIGGER trg_Seccion_PreventDeleteIfEstudiantes
BEFORE DELETE ON Seccion
FOR EACH ROW
BEGIN
    DECLARE num_estudiantes INT;
    SELECT COUNT(*) INTO num_estudiantes FROM Estudiante WHERE seccion_id = OLD.seccion_id;
    IF num_estudiantes > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar esta sección porque tiene estudiantes asociados.';
    END IF;
END //
DELIMITER ;

-- 8. Trigger: Asegurar que el género del estudiante no sea nulo al insertar
-- Utilidad: Hace que el genero_id sea obligatorio al insertar un estudiante.
-- Tipo: BEFORE INSERT en la tabla Estudiante.
DELIMITER //
CREATE TRIGGER trg_Estudiante_GeneroNotNull
BEFORE INSERT ON Estudiante
FOR EACH ROW
BEGIN
    IF NEW.genero_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El campo genero_id no puede ser nulo para un estudiante.';
    END IF;
END //
DELIMITER ;

-- 9. Trigger: Actualizar fecha_nota a la fecha actual si no se proporciona (o es nula)
-- Utilidad: Establece la fecha de la nota a la fecha actual si no se especifica.
-- Tipo: BEFORE INSERT, BEFORE UPDATE en la tabla Nota.
DELIMITER //
CREATE TRIGGER trg_Nota_SetFechaActual
BEFORE INSERT ON Nota
FOR EACH ROW
BEGIN
    IF NEW.fecha_nota IS NULL THEN
        SET NEW.fecha_nota = CURDATE();
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_Nota_SetFechaActual_Update
BEFORE UPDATE ON Nota
FOR EACH ROW
BEGIN
    IF NEW.fecha_nota IS NULL THEN
        SET NEW.fecha_nota = CURDATE();
    END IF;
END //
DELIMITER ;

-- 10. Trigger: Validar formato de email de profesor (básico)
-- Utilidad: Asegura que el email de un profesor contenga un '@'.
-- Tipo: BEFORE INSERT, BEFORE UPDATE en la tabla Profesor.
DELIMITER //
CREATE TRIGGER trg_Profesor_ValidateEmailFormat
BEFORE INSERT ON Profesor
FOR EACH ROW
BEGIN
    IF NEW.email IS NOT NULL AND NEW.email NOT LIKE '%_@__%.__%' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El formato del email del profesor no es válido.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_Profesor_ValidateEmailFormat_Update
BEFORE UPDATE ON Profesor
FOR EACH ROW
BEGIN
    IF NEW.email IS NOT NULL AND NEW.email NOT LIKE '%_@__%.__%' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El formato del email del profesor no es válido.';
    END IF;
END //
DELIMITER ;

-- 11. Trigger: Capitalizar el nombre del estudiante al insertar
-- Utilidad: Asegura que la primera letra del nombre del estudiante sea mayúscula.
-- Tipo: BEFORE INSERT en la tabla Estudiante.
DELIMITER //
CREATE TRIGGER trg_Estudiante_CapitalizeNombre
BEFORE INSERT ON Estudiante
FOR EACH ROW
BEGIN
    SET NEW.nombre = CONCAT(UPPER(SUBSTRING(NEW.nombre, 1, 1)), LOWER(SUBSTRING(NEW.nombre, 2)));
END //
DELIMITER ;

-- 12. Trigger: Evitar actualizaciones en la fecha de nacimiento de un estudiante
-- Utilidad: Una vez establecida, la fecha de nacimiento no debería ser modificable.
-- Tipo: BEFORE UPDATE en la tabla Estudiante.
DELIMITER //
CREATE TRIGGER trg_Estudiante_PreventFechaNacimientoUpdate
BEFORE UPDATE ON Estudiante
FOR EACH ROW
BEGIN
    IF NEW.fecha_nacimiento <=> OLD.fecha_nacimiento = FALSE THEN -- <=> es NULL-safe equivalent to =
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se permite actualizar la fecha de nacimiento de un estudiante.';
    END IF;
END //
DELIMITER ;

-- 13. Trigger: Registrar un mensaje de auditoría cuando se inserta una nueva nota
-- Utilidad: Para fines de auditoría o logging, registrar que se ha añadido una nota.
-- Tipo: AFTER INSERT en la tabla Nota. (Asume una tabla de auditoría 'Log_Auditoria' o similar)
-- Nota: Necesitarías crear una tabla de auditoría si aún no existe.
/*
CREATE TABLE Log_Auditoria (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    tabla_afectada VARCHAR(50),
    accion VARCHAR(10),
    registro_id INT,
    descripcion TEXT,
    fecha_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
*/
DELIMITER //
CREATE TRIGGER trg_Nota_AfterInsertLog
AFTER INSERT ON Nota
FOR EACH ROW
BEGIN
    INSERT INTO Log_Auditoria (tabla_afectada, accion, registro_id, descripcion)
    VALUES ('Nota', 'INSERT', NEW.nota_id, CONCAT('Nueva nota agregada para estudiante ', NEW.estudiante_id, ' con valor ', NEW.valor_nota));
END //
DELIMITER ;

-- 14. Trigger: Aumentar el teléfono de un profesor a 10 dígitos si es más corto (rellenando con ceros al inicio)
-- Utilidad: Estandariza el formato del número de teléfono.
-- Tipo: BEFORE INSERT, BEFORE UPDATE en la tabla Profesor.
DELIMITER //
CREATE TRIGGER trg_Profesor_PadTelefono
BEFORE INSERT ON Profesor
FOR EACH ROW
BEGIN
    IF NEW.telefono IS NOT NULL AND LENGTH(NEW.telefono) < 10 THEN
        SET NEW.telefono = LPAD(NEW.telefono, 10, '0');
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_Profesor_PadTelefono_Update
BEFORE UPDATE ON Profesor
FOR EACH ROW
BEGIN
    IF NEW.telefono IS NOT NULL AND LENGTH(NEW.telefono) < 10 THEN
        SET NEW.telefono = LPAD(NEW.telefono, 10, '0');
    END IF;
END //
DELIMITER ;

-- 15. Trigger: Validar que un estudiante tenga al menos 10 años al momento de la inscripción (asumiendo fecha de inscripción es CURDATE())
-- Utilidad: Restricción de edad mínima.
-- Tipo: BEFORE INSERT en la tabla Estudiante.
DELIMITER //
CREATE TRIGGER trg_Estudiante_MinimaEdad
BEFORE INSERT ON Estudiante
FOR EACH ROW
BEGIN
    IF TIMESTAMPDIFF(YEAR, NEW.fecha_nacimiento, CURDATE()) < 10 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El estudiante debe tener al menos 10 años para inscribirse.';
    END IF;
END //
DELIMITER ;

-- 16. Trigger: Establecer un valor predeterminado 'Sin Descripción' si la descripción de Asignatura es nula o vacía
-- Utilidad: Asegura que la columna de descripción siempre tenga un valor.
-- Tipo: BEFORE INSERT, BEFORE UPDATE en la tabla Asignatura.
DELIMITER //
CREATE TRIGGER trg_Asignatura_DefaultDescripcion
BEFORE INSERT ON Asignatura
FOR EACH ROW
BEGIN
    IF NEW.descripcion IS NULL OR TRIM(NEW.descripcion) = '' THEN
        SET NEW.descripcion = 'Sin Descripción';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_Asignatura_DefaultDescripcion_Update
BEFORE UPDATE ON Asignatura
FOR EACH ROW
BEGIN
    IF NEW.descripcion IS NULL OR TRIM(NEW.descripcion) = '' THEN
        SET NEW.descripcion = 'Sin Descripción';
    END IF;
END //
DELIMITER ;

-- 17. Trigger: Asegurar que el nombre de la asignatura no esté duplicado (case-insensitive)
-- Utilidad: Previene asignaturas con nombres idénticos (ignorando mayúsculas/minúsculas).
-- Tipo: BEFORE INSERT, BEFORE UPDATE en la tabla Asignatura.
DELIMITER //
CREATE TRIGGER trg_Asignatura_PreventDuplicateName
BEFORE INSERT ON Asignatura
FOR EACH ROW
BEGIN
    DECLARE existing_count INT;
    SELECT COUNT(*) INTO existing_count
    FROM Asignatura
    WHERE LOWER(nombre_asignatura) = LOWER(NEW.nombre_asignatura);

    IF existing_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ya existe una asignatura con este nombre (ignoring case).';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_Asignatura_PreventDuplicateName_Update
BEFORE UPDATE ON Asignatura
FOR EACH ROW
BEGIN
    DECLARE existing_count INT;
    IF OLD.nombre_asignatura != NEW.nombre_asignatura THEN -- Solo verificar si el nombre cambia
        SELECT COUNT(*) INTO existing_count
        FROM Asignatura
        WHERE LOWER(nombre_asignatura) = LOWER(NEW.nombre_asignatura) AND asignatura_id != OLD.asignatura_id;

        IF existing_count > 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ya existe otra asignatura con este nombre (ignoring case).';
        END IF;
    END IF;
END //
DELIMITER ;

---Transacciones sencillas
-- Insertar un Nuevo Estudiante
START TRANSACTION;
INSERT INTO Estudiante (nombre, apellido, fecha_nacimiento, grado_id, seccion_id, genero_id)
VALUES ('Nuevo', 'Estudiante', '2012-01-01', 1, 1, 1); -- Reemplazar
COMMIT;

-- Actualizar el Email de un Profesor
START TRANSACTION;
UPDATE Profesor
SET email = 'nuevo.email@ejemplo.com' -- Reemplazar
WHERE profesor_id = 1; -- Reemplazar
COMMIT;

-- Eliminar un Grado
START TRANSACTION;
DELETE FROM Grado
WHERE grado_id = 5; -- Reemplazar
COMMIT;

-- Actualizar la Nota de un Estudiante
START TRANSACTION;
UPDATE Nota
SET valor_nota = 17.0 -- Reemplazar
WHERE estudiante_id = 3 AND asignatura_id = 2; -- Reemplazar
COMMIT;

-- Insertar una Nueva Asignatura
START TRANSACTION;
INSERT INTO Asignatura (nombre_asignatura, descripcion)
VALUES ('Nueva Asignatura', 'Descripción'); -- Reemplazar
COMMIT;
Transacciones con condicionales

---Procedimientos almacenados

-------1. Procedimiento almacenado para Inscribir un estudiante en una sección y grado
DELIMITER //

CREATE PROCEDURE InscribirEstudiante(
    IN p_estudiante_id INT,
    IN p_grado_id INT,
    IN p_seccion_id INT
)
BEGIN
    DECLARE v_estudiante_existe INT;
    DECLARE v_grado_existe INT;
    DECLARE v_seccion_existe INT;

    SELECT COUNT(*) INTO v_estudiante_existe FROM Estudiante WHERE estudiante_id = p_estudiante_id;
    SELECT COUNT(*) INTO v_grado_existe FROM Grado WHERE grado_id = p_grado_id;
    SELECT COUNT(*) INTO v_seccion_existe FROM Seccion WHERE seccion_id = p_seccion_id;

    IF v_estudiante_existe > 0 AND v_grado_existe > 0 AND v_seccion_existe > 0 THEN
        UPDATE Estudiante 
        SET grado_id = p_grado_id, seccion_id = p_seccion_id 
        WHERE estudiante_id = p_estudiante_id;
        SELECT 'Estudiante inscrito exitosamente.' AS Resultado;
    ELSE
        SELECT 'Error: Estudiante, Grado o Sección no existen.' AS Resultado;
    END IF;

END //

DELIMITER ;

-- Ejemplo de uso:
-- CALL InscribirEstudiante(20, 1, 3);

----2. Procedimiento para registrar nueva nota de un estudiante 

DELIMITER //

CREATE PROCEDURE RegistrarNota(
    IN p_estudiante_id INT,
    IN p_asignatura_id INT,
    IN p_profesor_id INT,
    IN p_valor_nota DECIMAL(5,2)
)
BEGIN
    DECLARE v_estudiante_existe INT;
    DECLARE v_asignatura_existe INT;
    DECLARE v_profesor_existe INT;

    SELECT COUNT(*) INTO v_estudiante_existe FROM Estudiante WHERE estudiante_id = p_estudiante_id;
    SELECT COUNT(*) INTO v_asignatura_existe FROM Asignatura WHERE asignatura_id = p_asignatura_id;
    SELECT COUNT(*) INTO v_profesor_existe FROM Profesor WHERE profesor_id = p_profesor_id;

    IF v_estudiante_existe > 0 AND v_asignatura_existe > 0 AND v_profesor_existe > 0 THEN
        INSERT INTO Nota (estudiante_id, asignatura_id, profesor_id, valor_nota, fecha_nota)
        VALUES (p_estudiante_id, p_asignatura_id, p_profesor_id, p_valor_nota, CURDATE());
        SELECT 'Nota registrada exitosamente.' AS Resultado;
    ELSE
        SELECT 'Error: Estudiante, Asignatura o Profesor no existen.' AS Resultado;
    END IF;

END //

DELIMITER ;

-- Ejemplo de uso:
-- CALL RegistrarNota(16, 3, 2, 19.0);

-----3. Procedimieto para trasferir un estudiante de seccion

DELIMITER //

CREATE PROCEDURE TransferirEstudiante(
    IN p_estudiante_id INT,
    IN p_nueva_seccion_id INT
)
BEGIN
    DECLARE v_estudiante_existe INT;
    DECLARE v_nueva_seccion_existe INT;

    SELECT COUNT(*) INTO v_estudiante_existe FROM Estudiante WHERE estudiante_id = p_estudiante_id;
    SELECT COUNT(*) INTO v_nueva_seccion_existe FROM Seccion WHERE seccion_id = p_nueva_seccion_id;

    IF v_estudiante_existe > 0 AND v_nueva_seccion_existe > 0 THEN
        UPDATE Estudiante
        SET seccion_id = p_nueva_seccion_id
        WHERE estudiante_id = p_estudiante_id;
        SELECT 'Estudiante transferido exitosamente.' AS Resultado;
    ELSE
        SELECT 'Error: Estudiante o Sección no existen.' AS Resultado;
    END IF;

END //

DELIMITER ;

-- Ejemplo de uso:
-- CALL TransferirEstudiante(1, 2);

-- 4. Eliminar un Estudiante y sus Notas Asociadas
DELIMITER //

CREATE PROCEDURE EliminarEstudianteYNotas(
    IN p_estudiante_id INT
)
BEGIN
    DECLARE v_estudiante_existe INT;

    SELECT COUNT(*) INTO v_estudiante_existe FROM Estudiante WHERE estudiante_id = p_estudiante_id;

    IF v_estudiante_existe > 0 THEN
        DELETE FROM Nota WHERE estudiante_id = p_estudiante_id;
        DELETE FROM Estudiante WHERE estudiante_id = p_estudiante_id;
        SELECT 'Estudiante y sus notas eliminadas exitosamente.' AS Resultado;
    ELSE
        SELECT 'Error: Estudiante no existe.' AS Resultado;
    END IF;

END //

DELIMITER ;

-- Ejemplo de uso:
-- CALL EliminarEstudianteYNotas(1);

-- 5. Actualizar la Información de un Profesor y sus Asignaturas
DELIMITER //

CREATE PROCEDURE ActualizarProfesor(
    IN p_profesor_id INT,
    IN p_nuevo_nombre VARCHAR(255),
    IN p_nuevo_apellido VARCHAR(255)
)
BEGIN
    DECLARE v_profesor_existe INT;

    SELECT COUNT(*) INTO v_profesor_existe FROM Profesor WHERE profesor_id = p_profesor_id;

    IF v_profesor_existe > 0 THEN
        UPDATE Profesor
        SET nombre = p_nuevo_nombre, apellido = p_nuevo_apellido
        WHERE profesor_id = p_profesor_id;
        SELECT 'Información del profesor actualizada exitosamente.' AS Resultado;
    ELSE
        SELECT 'Error: Profesor no existe.' AS Resultado;
    END IF;

END //

DELIMITER ;

-- Ejemplo de uso:
-- CALL ActualizarProfesor(1, 'Juan', 'Pérez');

6 ---- Proceso almacenado que cambia el profesor que aparece como el que asigno una nota 
DELIMITER //

CREATE PROCEDURE ActualizarProfesorYNotasAsignatura(
    IN p_profesor_id INT,
    IN p_nuevo_nombre VARCHAR(255),
    IN p_nuevo_apellido VARCHAR(255),
    IN p_asignatura_id INT,
    IN p_nuevo_profesor_id INT
)
BEGIN
    DECLARE v_profesor_existe INT;
    DECLARE v_asignatura_existe INT;
    DECLARE v_nuevo_profesor_existe INT;

    SELECT COUNT(*) INTO v_profesor_existe FROM Profesor WHERE profesor_id = p_profesor_id;
    SELECT COUNT(*) INTO v_asignatura_existe FROM Asignatura WHERE asignatura_id = p_asignatura_id;
    SELECT COUNT(*) INTO v_nuevo_profesor_existe FROM Profesor WHERE profesor_id = p_nuevo_profesor_id;

    IF v_profesor_existe > 0 THEN
        UPDATE Profesor
        SET nombre = p_nuevo_nombre, apellido = p_nuevo_apellido
        WHERE profesor_id = p_profesor_id;
        SELECT 'Información del profesor actualizada exitosamente.' AS Resultado;

        IF v_asignatura_existe > 0 AND v_nuevo_profesor_existe > 0 THEN
            UPDATE Nota
            SET profesor_id = p_nuevo_profesor_id
            WHERE profesor_id = p_profesor_id AND asignatura_id = p_asignatura_id;
            SELECT 'Profesor de la asignatura actualizado en las notas.' AS Resultado_Asignatura;
        ELSE
            SELECT 'Error: Asignatura o Nuevo Profesor no existen. No se actualizaron las notas.' AS Resultado_Asignatura;
        END IF;
    ELSE
        SELECT 'Error: Profesor no existe.' AS Resultado;
    END IF;

END //

DELIMITER ;

-- Ejemplo de uso:
-- CALL ActualizarProfesorYNotasAsignatura(1, 'Juan', 'Pérez', 2, 5);  
-- Actualiza el profesor 1, y cambia al profesor de la asignatura 2 a profesor 5 en las notas.

----Procedimientos con al menos un dato de salida .

------1.Procedimiento almacenado para obtener el promedio de un estudiante.

DELIMITER //

CREATE PROCEDURE ObtenerPromedioEstudiante(
    IN p_estudiante_id INT,
    OUT p_promedio DECIMAL(5,2)
)
BEGIN
    SELECT AVG(valor_nota) INTO p_promedio
    FROM Nota
    WHERE estudiante_id = p_estudiante_id;

    IF p_promedio IS NULL THEN
        SET p_promedio = 0.0;  -- Si no hay notas, devolver 0.0
    END IF;
END //

DELIMITER ;

-- Ejemplo de uso:
-- CALL ObtenerPromedioEstudiante(1, @promedio);
-- SELECT @promedio;

------2. Procedimiento para contar a los estudiantes de un grado y sección específicos
DELIMITER //

CREATE PROCEDURE ContarEstudiantesGradoSeccion(
    IN p_grado_id INT,
    IN p_seccion_id INT,
    OUT p_total_estudiantes INT
)
BEGIN
    SELECT COUNT(*) INTO p_total_estudiantes
    FROM Estudiante
    WHERE grado_id = p_grado_id AND seccion_id = p_seccion_id;
END //

DELIMITER ;

-- Ejemplo de uso:
-- CALL ContarEstudiantesGradoSeccion(1, 1, @total);
-- SELECT @total;

----- Procedimiento para obtener el nombre completo de un profesor 

DELIMITER //

CREATE PROCEDURE ObtenerNombreCompletoProfesor(
    IN p_profesor_id INT,
    OUT p_nombre_completo VARCHAR(511) -- Asumiendo que nombre y apellido no exceden 255 cada uno
)
BEGIN
    SELECT CONCAT(nombre, ' ', apellido) INTO p_nombre_completo
    FROM Profesor
    WHERE profesor_id = p_profesor_id;

    IF p_nombre_completo IS NULL THEN
        SET p_nombre_completo = 'Profesor no encontrado';
    END IF;
END //

DELIMITER ;

-- Ejemplo de uso:
-- CALL ObtenerNombreCompletoProfesor(1, @nombre);
-- SELECT @nombre;

----Verificar si un estudiante esta inscrito en un grado 

DELIMITER //

CREATE PROCEDURE VerificarInscripcionEstudiante(
    IN p_estudiante_id INT,
    IN p_grado_id INT,
    OUT p_esta_inscrito BOOLEAN
)
BEGIN
    DECLARE v_count INT;
    SELECT COUNT(*) INTO v_count
    FROM Estudiante
    WHERE estudiante_id = p_estudiante_id AND grado_id = p_grado_id;

    IF v_count > 0 THEN
        SET p_esta_inscrito = TRUE;
    ELSE
        SET p_esta_inscrito = FALSE;
    END IF;
END //

DELIMITER ;

-- Ejemplo de uso:
-- CALL VerificarInscripcionEstudiante(1, 1, @inscrito);
-- SELECT @inscrito;

----- Obtener máximo valor de nota en una asignatura

DELIMITER //

CREATE PROCEDURE ObtenerMaximoValorNotaAsignatura(
    IN p_asignatura_id INT,
    OUT p_max_nota DECIMAL(5,2)
)
BEGIN
    SELECT MAX(valor_nota) INTO p_max_nota
    FROM Nota
    WHERE asignatura_id = p_asignatura_id;

    IF p_max_nota IS NULL THEN
        SET p_max_nota = 0.0; -- Si no hay notas, devolver 0.0
    END IF;
END //

DELIMITER ;

-- Ejemplo de uso:
-- CALL ObtenerMaximoValorNotaAsignatura(1, @max_nota);
-- SELECT @max_nota;

-----Procedimientos para el control de notas

------- Procedimiento para obtener notas obtenidas entre dos fechas dadas.

DELIMITER //

CREATE PROCEDURE ObtenerNotasEstudianteRangoFechas(
    IN p_estudiante_id INT,
    IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE,
    OUT p_total_notas INT
)
BEGIN
    SELECT COUNT(*) INTO p_total_notas
    FROM Nota
    WHERE estudiante_id = p_estudiante_id
      AND fecha_nota BETWEEN p_fecha_inicio AND p_fecha_fin;

    SELECT nota_id, asignatura_id, profesor_id, valor_nota, fecha_nota
    FROM Nota
    WHERE estudiante_id = p_estudiante_id
      AND fecha_nota BETWEEN p_fecha_inicio AND p_fecha_fin;
END //

DELIMITER ;

-- Ejemplo de uso:
-- CALL ObtenerNotasEstudianteRangoFechas(1, '2023-01-01', '2023-12-31', @total_notas);
-- SELECT @total_notas;

---- Procedimiento para obtener nota más alta y nota más baja en una asignatura

DELIMITER //

CREATE PROCEDURE ObtenerNotasExtremasAsignatura(
    IN p_asignatura_id INT,
    OUT p_nota_maxima DECIMAL(5,2),
    OUT p_nota_minima DECIMAL(5,2)
)
BEGIN
    SELECT MAX(valor_nota), MIN(valor_nota)
    INTO p_nota_maxima, p_nota_minima
    FROM Nota
    WHERE asignatura_id = p_asignatura_id;

    IF p_nota_maxima IS NULL THEN
        SET p_nota_maxima = 0.0;
    END IF;
    IF p_nota_minima IS NULL THEN
        SET p_nota_minima = 0.0;
    END IF;
END //

DELIMITER ;

-- Ejemplo de uso:
-- CALL ObtenerNotasExtremasAsignatura(1, @max_nota, @min_nota);
-- SELECT @max_nota, @min_nota;

------ Procedimiento para calcular el promedio de la asignatura según el profesor
DELIMITER //

CREATE PROCEDURE CalcularPromedioAsignaturaProfesor(
    IN p_asignatura_id INT,
    IN p_profesor_id INT,
    OUT p_promedio_asignatura_profesor DECIMAL(5,2)
)
BEGIN
    SELECT AVG(valor_nota) INTO p_promedio_asignatura_profesor
    FROM Nota
    WHERE asignatura_id = p_asignatura_id
      AND profesor_id = p_profesor_id;

      IF p_promedio_asignatura_profesor IS NULL THEN
          SET p_promedio_asignatura_profesor = 0.0;
      END IF;
END //

DELIMITER ;

-- Ejemplo de uso:
-- CALL CalcularPromedioAsignaturaProfesor(1, 1, @promedio_profesor);
-- SELECT @promedio_profesor;

--------Procedimiento para insertar multiples notas

DELIMITER //

CREATE PROCEDURE InsertarMultiplesNotas(
    IN p_estudiante_id INT,
    IN p_asignaturas_notas JSON
)
BEGIN
    -- p_asignaturas_notas debe ser un JSON array como:
    -- [{"asignatura_id": 1, "valor_nota": 18.5}, {"asignatura_id": 2, "valor_nota": 16.0}]

    DECLARE i INT DEFAULT 0;
    DECLARE num_asignaturas INT;

    SET num_asignaturas = JSON_LENGTH(p_asignaturas_notas);

    WHILE i < num_asignaturas DO
        INSERT INTO Nota (estudiante_id, asignatura_id, profesor_id, valor_nota, fecha_nota)
        VALUES (
            p_estudiante_id,
            JSON_EXTRACT(p_asignaturas_notas, CONCAT('$[', i, '].asignatura_id')),
            1, -- Asumiendo un profesor_id por defecto, ajusta según necesidad
            JSON_EXTRACT(p_asignaturas_notas, CONCAT('$[', i, '].valor_nota')),
            CURDATE()
        );
        SET i = i + 1;
    END WHILE;

    SELECT 'Notas insertadas exitosamente.' AS Resultado;
END //

DELIMITER ;

-- Ejemplo de uso:
-- SET @notas_json = '[{"asignatura_id": 1, "valor_nota": 18.5}, {"asignatura_id": 2, "valor_nota": 16.0}]';
-- CALL InsertarMultiplesNotas(1, @notas_json);


----- Procedimiento para borrar notas de mas de 12 meses de antigüedad.
DELIMITER //

CREATE PROCEDURE EliminarNotasAntiguas(
    IN p_antiguedad_en_meses INT
)
BEGIN
    DELETE FROM Nota
    WHERE fecha_nota < DATE_SUB(CURDATE(), INTERVAL p_antiguedad_en_meses MONTH);

    SELECT CONCAT('Notas de más de ', p_antiguedad_en_meses, ' meses eliminadas.') AS Resultado;
END //

DELIMITER ;

-- Ejemplo de uso:
-- CALL EliminarNotasAntiguas(12); -- Elimina notas de hace más de 12 meses

-----Transacciones con isolation level .

-- 1. Read Committed (GestionNotas - Actualizar nota)
START TRANSACTION;
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT valor_nota FROM Nota WHERE nota_id = 10;
UPDATE Nota SET valor_nota = 19.5 WHERE nota_id = 10;
COMMIT;

START TRANSACTION;
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT valor_nota FROM Nota WHERE nota_id = 10;
COMMIT;

-- 2. Repeatable Read (GestionNotas - Calcular promedio)
START TRANSACTION;
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT valor_nota FROM Nota WHERE estudiante_id = 5;
SELECT valor_nota FROM Nota WHERE estudiante_id = 5;
COMMIT;

START TRANSACTION;
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
INSERT INTO Nota (estudiante_id, asignatura_id, profesor_id, valor_nota, fecha_nota) VALUES (5, 2, 1, 17.0, CURDATE());
COMMIT;

-- 3. Serializable (GestionNotas - Transferir estudiante)
START TRANSACTION;
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT estudiante_id, grado_id, seccion_id FROM Estudiante WHERE estudiante_id = 7;
SELECT seccion_id, nombre_seccion FROM Seccion WHERE seccion_id = 3;
UPDATE Estudiante SET seccion_id = 3 WHERE estudiante_id = 7;
COMMIT;

START TRANSACTION;
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT estudiante_id, grado_id, seccion_id FROM Estudiante WHERE estudiante_id = 7;
COMMIT;

-- 4. Repeatable Read con eliminación (GestionNotas - Eliminar notas)
START TRANSACTION;
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT COUNT(*) FROM Nota WHERE estudiante_id = 8;
DELETE FROM Nota WHERE estudiante_id = 8;
SELECT COUNT(*) FROM Nota WHERE estudiante_id = 8;
COMMIT;

START TRANSACTION;
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT COUNT(*) FROM Nota WHERE estudiante_id = 8;
COMMIT;

-- 5. Read Only (GestionNotas - Consultar vista)
START TRANSACTION READ ONLY;
-- SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT * FROM EstudiantesConNombreGradoSeccion WHERE nombre_grado = '1er Grado';
COMMIT;

START TRANSACTION;
UPDATE Estudiante SET grado_id = 2 WHERE estudiante_id = 3;
COMMIT;

-- 6. Read Committed (GestionNotas - Registrar nueva nota)
START TRANSACTION;
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
INSERT INTO Nota (estudiante_id, asignatura_id, profesor_id, valor_nota, fecha_nota) VALUES (1, 3, 2, 16.5, CURDATE());
COMMIT;

-- 7. Repeatable Read (GestionNotas - Obtener notas de un estudiante)
START TRANSACTION;
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT nota_id, asignatura_id, valor_nota FROM Nota WHERE estudiante_id = 2;
SELECT nota_id, asignatura_id, valor_nota FROM Nota WHERE estudiante_id = 2;
COMMIT;

-- 8. Serializable (GestionNotas - Actualizar información del profesor)
START TRANSACTION;
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT nombre, apellido FROM Profesor WHERE profesor_id = 4;
UPDATE Profesor SET nombre = 'Nuevo Nombre', apellido = 'Nuevo Apellido' WHERE profesor_id = 4;
COMMIT;

START TRANSACTION;
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT nombre, apellido FROM Profesor WHERE profesor_id = 4;
COMMIT;

-- 9. Repeatable Read (GestionNotas - Contar notas en una asignatura)
START TRANSACTION;
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT COUNT(*) FROM Nota WHERE asignatura_id = 1;
SELECT COUNT(*) FROM Nota WHERE asignatura_id = 1;
COMMIT;

START TRANSACTION;
INSERT INTO Nota (estudiante_id, asignatura_id, profesor_id, valor_nota, fecha_nota) VALUES (3, 1, 1, 18.0, CURDATE());
COMMIT;

-- 10. Read Committed (GestionNotas - Eliminar un estudiante y sus notas)
START TRANSACTION;
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT estudiante_id FROM Estudiante WHERE estudiante_id = 6;
DELETE FROM Nota WHERE estudiante_id = 6;
DELETE FROM Estudiante WHERE estudiante_id = 6;
COMMIT;

------Transacciones con Rollback

-- 1. Intenta actualizar una nota inexistente y revierte la operación.
START TRANSACTION;
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT valor_nota FROM Nota WHERE nota_id = 999;
UPDATE Nota SET valor_nota = 20.0 WHERE nota_id = 999;
ROLLBACK;

-- 2. Intenta insertar un estudiante con un correo electrónico duplicado y revierte la operación.
START TRANSACTION;
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
INSERT INTO Estudiante (nombre, apellido, email, grado_id, seccion_id, genero_id)
VALUES ('Nuevo', 'Estudiante', 'correo_existente@ejemplo.com', 1, 1, 1);
ROLLBACK;

-- 3. Intenta transferir un estudiante a una sección que probablemente no existe y revierte la operación.
START TRANSACTION;
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT estudiante_id, seccion_id FROM Estudiante WHERE estudiante_id = 10;
UPDATE Estudiante SET seccion_id = 99 WHERE estudiante_id = 10;
ROLLBACK;

-- 4. Selecciona un estudiante y luego decide no eliminarlo, revirtiendo la intención.
START TRANSACTION;
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT estudiante_id, nombre FROM Estudiante WHERE estudiante_id = 11;
ROLLBACK;

-- 5. Intenta registrar una nota con un valor que probablemente sea inválido y revierte la operación.
START TRANSACTION;
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
INSERT INTO Nota (estudiante_id, asignatura_id, profesor_id, valor_nota, fecha_nota)
VALUES (12, 1, 1, 25.0, CURDATE());
ROLLBACK;

-------Consultas a vistas usando select
-- 1. Ver nombres de estudiantes y sus grados y secciones:
SELECT nombre_estudiante, apellido, nombre_grado, nombre_seccion
FROM EstudiantesConNombreGradoSeccion;

-- 2. Ver el nombre del estudiante, la asignatura y la nota:
SELECT nombre_estudiante, nombre_asignatura, valor_nota
FROM NotasPorEstudianteAsignatura;

-- 3. Ver el nombre completo y el correo electrónico de los profesores:
SELECT nombre_completo, email
FROM ProfesoresConNombreCompleto;

-- 4. Ver el nombre del grado y las asignaturas ofrecidas en ese grado (ejemplo: '2do Grado'):
SELECT nombre_grado, nombre_asignatura
FROM AsignaturasPorGrado
WHERE nombre_grado = '2do Grado';

-- 5. Ver el nombre del estudiante y su promedio general de notas, ordenado por promedio descendente:
SELECT nombre_estudiante, promedio_general
FROM PromedioNotasPorEstudiante
ORDER BY promedio_general DESC;


---Procedimientos almacenados

DELIMITER //

CREATE PROCEDURE transferencia_bancaria(
    IN p_cuenta_origen VARCHAR(20),
    IN p_cuenta_destino VARCHAR(20),
    IN p_monto DECIMAL(10, 2),
    OUT p_mensaje VARCHAR(100)
)
BEGIN
    -- Variables para control de errores
    DECLARE v_saldo_origen DECIMAL(10, 2);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        procedure;
        SET p_mensaje = 'Error: Transferencia fallida.';
    END;


---Vistas

----- Vista 1
CREATE VIEW EstudiantesConNombreGradoSeccion AS
SELECT
    E.estudiante_id,
    E.nombre AS nombre_estudiante,
    E.apellido,
    G.nombre_grado,
    S.nombre_seccion
FROM
    Estudiante E
JOIN
    Grado G ON E.grado_id = G.grado_id
JOIN
    Seccion S ON E.seccion_id = S.seccion_id;

----Propósito: Combina información de estudiantes, grados y secciones para obtener una vista fácil de leer de la información de los estudiantes.


----Vista 2
---Propósito: Proporciona una vista de las notas con los nombres del estudiante y la asignatura, en lugar de solo los IDs.

CREATE VIEW NotasPorEstudianteAsignatura AS
SELECT
    N.nota_id,
    E.nombre AS nombre_estudiante,
    A.nombre_asignatura,
    N.valor_nota,
    N.fecha_nota
FROM
    Nota N
JOIN
    Estudiante E ON N.estudiante_id = E.estudiante_id
JOIN
    Asignatura A ON N.asignatura_id = A.asignatura_id;

----Propósito: Proporciona una vista de las notas con los nombres del estudiante y la asignatura, en lugar de solo los IDs.

----Vista 3

CREATE VIEW ProfesoresConNombreCompleto AS
SELECT
    profesor_id,
    CONCAT(nombre, ' ', apellido) AS nombre_completo,
    email,
    telefono
FROM
    Profesor;
----Propósito: Simplifica la obtención del nombre completo de los profesores.

---- Vista 4
CREATE VIEW AsignaturasPorGrado AS
SELECT
    AG.asignatura_grado_id,
    G.nombre_grado,
    A.nombre_asignatura,
    A.descripcion
FROM
    AsignaturaGrado AG
JOIN
    Grado G ON AG.grado_id = G.grado_id
JOIN
    Asignatura A ON AG.asignatura_id = A.asignatura_id;

------Vista 5
CREATE VIEW PromedioNotasPorEstudiante AS
SELECT
    E.estudiante_id,
    E.nombre AS nombre_estudiante,
    AVG(N.valor_nota) AS promedio_general
FROM
    Estudiante E
JOIN
    Nota N ON E.estudiante_id = N.estudiante_id
GROUP BY
    E.estudiante_id, E.nombre;

------Propósito: Calcula el promedio general de notas para cada estudiante.

---Vista 6
CREATE VIEW CantidadNotasPorAsignatura AS
SELECT
    A.asignatura_id,
    A.nombre_asignatura,
    COUNT(N.nota_id) AS cantidad_notas
FROM
    Asignatura A
LEFT JOIN
    Nota N ON A.asignatura_id = N.asignatura_id
GROUP BY
    A.asignatura_id, A.nombre_asignatura;

----Propósito: Cuenta cuántas notas se han registrado para cada asignatura.

-----Vista 7
CREATE VIEW NotasRecientes AS
SELECT
    nota_id,
    estudiante_id,
    asignatura_id,
    profesor_id,
    valor_nota,
    fecha_nota
FROM
    Nota
WHERE
    fecha_nota >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH); -- Notas del último mes

----Propósito: Proporciona una vista rápida de las notas registradas recientemente.

-----Vista 8
CREATE VIEW EstudiantesPorGenero AS
SELECT
    E.estudiante_id,
    E.nombre AS nombre_estudiante,
    GE.descripcion AS genero
FROM
    Estudiante E
JOIN
    Genero GE ON E.genero_id = GE.genero_id;
---Propósito: Muestra la información del estudiante junto con su género.
----Vista 9
CREATE VIEW NotasConNombreProfesor AS
SELECT
    N.nota_id,
    N.estudiante_id,
    N.asignatura_id,
    P.nombre AS nombre_profesor,
    P.apellido AS apellido_profesor,
    N.valor_nota,
    N.fecha_nota
FROM
    Nota N
JOIN
    Profesor P ON N.profesor_id = P.profesor_id;

---Propósito: Muestra las notas con el nombre del profesor que las asignó.

CREATE VIEW EstudiantesSinNotas AS
SELECT
    E.estudiante_id,
    E.nombre AS nombre_estudiante,
    E.apellido
FROM
    Estudiante E
LEFT JOIN
    Nota N ON E.estudiante_id = N.estudiante_id
WHERE
    N.nota_id IS NULL;

----Propósito: Identifica a los estudiantes que aún no tienen ninguna nota registrada.

---Transacciones con nivel de aislamiento distinto

-- =============================================================================
-- Transacciones con Nivel de Aislamiento Individual Garantizado -- =============================================================================

-- Transacción 1 (Nivel: READ COMMITTED)
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT @@transaction_isolation AS 'Nivel de Aislamiento Actual';
SELECT E.estudiante_id, E.nombre, E.apellido, G.nombre_grado, S.nombre_seccion
FROM Estudiante E
JOIN Grado G ON E.grado_id = G.grado_id
JOIN Seccion S ON E.seccion_id = S.seccion_id;
COMMIT;

-- Transacción 2 (Nivel: REPEATABLE READ)
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;
SELECT @@transaction_isolation AS 'Nivel de Aislamiento Actual';
SELECT N.nota_id, E.nombre AS nombre_estudiante, A.nombre_asignatura, N.valor_nota, N.fecha_nota
FROM Nota N
JOIN Estudiante E ON N.estudiante_id = E.estudiante_id
JOIN AsignaturaGrado AG ON N.asignatura_grado_id = AG.asignatura_grado_id
JOIN Asignatura A ON AG.asignatura_id = A.asignatura_id
ORDER BY N.fecha_nota DESC, N.nota_id DESC
LIMIT 5;
COMMIT;

-- Transacción 3 (Nivel: SERIALIZABLE)
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
SELECT @@transaction_isolation AS 'Nivel de Aislamiento Actual';
SELECT G.nombre_grado, COUNT(E.estudiante_id) AS total_estudiantes
FROM Grado G
LEFT JOIN Estudiante E ON G.grado_id = E.grado_id
GROUP BY G.nombre_grado
ORDER BY G.grado_id;
COMMIT;

-- Transacción 4 (Nivel: READ COMMITTED)
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT @@transaction_isolation AS 'Nivel de Aislamiento Actual';
SELECT asignatura_id, nombre_asignatura, descripcion
FROM Asignatura;
COMMIT;

-- Transacción 5 (Nivel: REPEATABLE READ)
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;
SELECT @@transaction_isolation AS 'Nivel de Aislamiento Actual';
SELECT E.nombre, E.apellido, AVG(N.valor_nota) AS promedio_estudiante
FROM Estudiante E
JOIN Nota N ON E.estudiante_id = N.estudiante_id
WHERE E.estudiante_id = 1
GROUP BY E.estudiante_id, E.nombre, E.apellido;
COMMIT;

-- Transacción 6 (Nivel: SERIALIZABLE)
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
SELECT @@transaction_isolation AS 'Nivel de Aislamiento Actual';
SELECT profesor_id, nombre, apellido, email, telefono
FROM Profesor;
COMMIT;

-- Transacción 7 (Nivel: READ COMMITTED)
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT @@transaction_isolation AS 'Nivel de Aislamiento Actual';
SELECT estudiante_id, nombre, apellido, fecha_nacimiento
FROM Estudiante
WHERE fecha_nacimiento > '2008-12-31';
COMMIT;

-- Transacción 8 (Nivel: REPEATABLE READ)
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;
SELECT @@transaction_isolation AS 'Nivel de Aislamiento Actual';
SELECT G.nombre_grado, COUNT(AG.asignatura_id) AS total_asignaturas
FROM Grado G
LEFT JOIN AsignaturaGrado AG ON G.grado_id = AG.grado_id
GROUP BY G.nombre_grado
ORDER BY G.grado_id;
COMMIT;

-- Transacción 9 (Nivel: SERIALIZABLE)
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
SELECT @@transaction_isolation AS 'Nivel de Aislamiento Actual';
SELECT E.nombre, E.apellido, MAX(N.valor_nota) AS nota_maxima_general
FROM Estudiante E
JOIN Nota N ON E.estudiante_id = N.estudiante_id
ORDER BY nota_maxima_general DESC
LIMIT 1;
COMMIT;

-- Transacción 10 (Nivel: READ COMMITTED)
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT @@transaction_isolation AS 'Nivel de Aislamiento Actual';
SELECT Ge.nombre_genero, COUNT(E.estudiante_id) AS cantidad_estudiantes
FROM Genero Ge
LEFT JOIN Estudiante E ON Ge.genero_id = E.genero_id
GROUP BY Ge.nombre_genero;
COMMIT;

-- Transacción 11 (Nivel: REPEATABLE READ)
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;
SELECT @@transaction_isolation AS 'Nivel de Aislamiento Actual';
SELECT nombre, apellido, direccion, telefono
FROM Estudiante
WHERE estudiante_id = 5;
COMMIT;

-- Transacción 12 (Nivel: SERIALIZABLE)
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
SELECT @@transaction_isolation AS 'Nivel de Aislamiento Actual';
SELECT COUNT(nota_id) AS total_notas_registradas
FROM Nota;
COMMIT;

-- Transacción 13 (Nivel: READ COMMITTED)
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT @@transaction_isolation AS 'Nivel de Aislamiento Actual';
SELECT estudiante_id, nombre, apellido
FROM Estudiante
WHERE seccion_id = (SELECT seccion_id FROM Seccion WHERE nombre_seccion = 'A');
COMMIT;

-- Transacción 14 (Nivel: REPEATABLE READ)
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;
SELECT @@transaction_isolation AS 'Nivel de Aislamiento Actual';
SELECT DISTINCT G.nombre_grado
FROM Grado G
JOIN AsignaturaGrado AG ON G.grado_id = AG.grado_id
WHERE AG.asignatura_id = (SELECT asignatura_id FROM Asignatura WHERE nombre_asignatura = 'Música');
COMMIT;

-- Transacción 15 (Nivel: SERIALIZABLE)
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
SELECT @@transaction_isolation AS 'Nivel de Aislamiento Actual';
SELECT
    CASE
        WHEN valor_nota >= 90 THEN '90-100'
        WHEN valor_nota >= 80 THEN '80-89'
        WHEN valor_nota >= 70 THEN '70-79'
        ELSE '0-69'
    END AS rango_nota,
    COUNT(nota_id) AS cantidad_notas
FROM Nota
GROUP BY rango_nota
ORDER BY rango_nota DESC;
COMMIT;

-- =============================================================================
-- FUNCIONES PARA LA BASE DE DATOS GESTIONNOTAS
-- =============================================================================

-- 1. Utilidad: Calcula el promedio de notas de un estudiante.
DELIMITER //
CREATE FUNCTION CalcularPromedioEstudiante(p_estudiante_id INT)
RETURNS DECIMAL(5, 2)
READS SQL DATA
BEGIN
    DECLARE promedio DECIMAL(5, 2);
    SELECT AVG(valor_nota) INTO promedio
    FROM Nota
    WHERE estudiante_id = p_estudiante_id;
    RETURN IFNULL(promedio, 0.00);
END //
DELIMITER ;

-- 2. Utilidad: Obtiene el nombre completo de un estudiante.
DELIMITER //
CREATE FUNCTION ObtenerNombreCompletoEstudiante(p_estudiante_id INT)
RETURNS VARCHAR(255)
READS SQL DATA
BEGIN
    DECLARE nombre_completo VARCHAR(255);
    SELECT CONCAT(nombre, ' ', apellido) INTO nombre_completo
    FROM Estudiante
    WHERE estudiante_id = p_estudiante_id;
    RETURN IFNULL(nombre_completo, 'Estudiante no encontrado');
END //
DELIMITER ;

-- 3. Utilidad: Cuenta la cantidad de asignaturas que un grado tiene.
DELIMITER //
CREATE FUNCTION ContarAsignaturasPorGrado(p_grado_id INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE total_asignaturas INT;
    SELECT COUNT(asignatura_id) INTO total_asignaturas
    FROM AsignaturaGrado
    WHERE grado_id = p_grado_id;
    RETURN IFNULL(total_asignaturas, 0);
END //
DELIMITER ;

-- 4. Utilidad: Verifica si un estudiante tiene teléfono registrado.
DELIMITER //
CREATE FUNCTION EstudianteTieneTelefono(p_estudiante_id INT)
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE tiene_telefono BOOLEAN;
    SELECT (telefono IS NOT NULL AND telefono != '') INTO tiene_telefono
    FROM Estudiante
    WHERE estudiante_id = p_estudiante_id;
    RETURN IFNULL(tiene_telefono, FALSE);
END //
DELIMITER ;

-- 5. Utilidad: Obtiene el nombre del grado de un estudiante.
DELIMITER //
CREATE FUNCTION ObtenerGradoEstudiante(p_estudiante_id INT)
RETURNS VARCHAR(100)
READS SQL DATA
BEGIN
    DECLARE nombre_grado VARCHAR(100);
    SELECT G.nombre_grado INTO nombre_grado
    FROM Estudiante E
    JOIN Grado G ON E.grado_id = G.grado_id
    WHERE E.estudiante_id = p_estudiante_id;
    RETURN IFNULL(nombre_grado, 'Grado no encontrado');
END //
DELIMITER ;

-- 6. Utilidad: Calcula la edad de un estudiante en años.
DELIMITER //
CREATE FUNCTION CalcularEdadEstudiante(p_estudiante_id INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE fecha_nacimiento DATE;
    DECLARE edad INT;
    SELECT E.fecha_nacimiento INTO fecha_nacimiento
    FROM Estudiante E
    WHERE E.estudiante_id = p_estudiante_id;

    IF fecha_nacimiento IS NULL THEN
        RETURN NULL;
    END IF;

    SET edad = TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE());
    RETURN edad;
END //
DELIMITER ;

-- 7. Utilidad: Obtiene el nombre de la sección de un estudiante.
DELIMITER //
CREATE FUNCTION ObtenerSeccionEstudiante(p_estudiante_id INT)
RETURNS VARCHAR(100)
READS SQL DATA
BEGIN
    DECLARE nombre_seccion VARCHAR(100);
    SELECT S.nombre_seccion INTO nombre_seccion
    FROM Estudiante E
    JOIN Seccion S ON E.seccion_id = S.seccion_id
    WHERE E.estudiante_id = p_estudiante_id;
    RETURN IFNULL(nombre_seccion, 'Sección no encontrada');
END //
DELIMITER ;

-- 8. Utilidad: Verifica si una asignatura es de un grado específico.
DELIMITER //
CREATE FUNCTION AsignaturaEnGrado(p_asignatura_id INT, p_grado_id INT)
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE existe BOOLEAN;
    SELECT EXISTS (SELECT 1 FROM AsignaturaGrado WHERE asignatura_id = p_asignatura_id AND grado_id = p_grado_id) INTO existe;
    RETURN existe;
END //
DELIMITER ;

-- 9. Utilidad: Cuenta el número de notas por encima de un valor dado.
DELIMITER //
CREATE FUNCTION ContarNotasSuperioresA(p_valor_limite DECIMAL(5, 2))
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE total_notas INT;
    SELECT COUNT(nota_id) INTO total_notas
    FROM Nota
    WHERE valor_nota > p_valor_limite;
    RETURN IFNULL(total_notas, 0);
END //
DELIMITER ;

-- 10. Utilidad: Obtiene el email de un profesor.
DELIMITER //
CREATE FUNCTION ObtenerEmailProfesor(p_profesor_id INT)
RETURNS VARCHAR(255)
READS SQL DATA
BEGIN
    DECLARE p_email VARCHAR(255);
    SELECT email INTO p_email
    FROM Profesor
    WHERE profesor_id = p_profesor_id;
    RETURN IFNULL(p_email, 'Email no encontrado');
END //
DELIMITER ;

-- 11. Utilidad: Determina si un estudiante ha aprobado (nota promedio >= 10).
DELIMITER //
CREATE FUNCTION EstudianteAprobado(p_estudiante_id INT)
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE promedio DECIMAL(5, 2);
    -- Reutiliza la función existente para calcular el promedio
    SELECT CalcularPromedioEstudiante(p_estudiante_id) INTO promedio;
    RETURN promedio >= 10;
END //
DELIMITER ;

-- 12. Utilidad: Cuenta estudiantes de un género específico.
DELIMITER //
CREATE FUNCTION ContarEstudiantesPorGenero(p_genero_id INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE total_estudiantes INT;
    SELECT COUNT(estudiante_id) INTO total_estudiantes
    FROM Estudiante
    WHERE genero_id = p_genero_id;
    RETURN IFNULL(total_estudiantes, 0);
END //
DELIMITER ;

-- 13. Utilidad: Obtiene la descripción de una asignatura.
DELIMITER //
CREATE FUNCTION ObtenerDescripcionAsignatura(p_asignatura_id INT)
RETURNS TEXT
READS SQL DATA
BEGIN
    DECLARE desc_asignatura TEXT;
    SELECT descripcion INTO desc_asignatura
    FROM Asignatura
    WHERE asignatura_id = p_asignatura_id;
    RETURN IFNULL(desc_asignatura, 'Descripción no disponible');
END //
DELIMITER ;

-- 14. Utilidad: Verifica si existe alguna nota registrada en una fecha específica.
DELIMITER //
CREATE FUNCTION ExistenNotasEnFecha(p_fecha DATE)
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE existe BOOLEAN;
    SELECT EXISTS (SELECT 1 FROM Nota WHERE fecha_nota = p_fecha) INTO existe;
    RETURN existe;
END //
DELIMITER ;

-- 15. Utilidad: Obtiene la nota más alta de un estudiante en una asignatura específica.
DELIMITER //
CREATE FUNCTION ObtenerNotaMasAlta(p_estudiante_id INT, p_asignatura_id INT)
RETURNS DECIMAL(5, 2)
READS SQL DATA
BEGIN
    DECLARE nota_mas_alta DECIMAL(5, 2);
    SELECT MAX(N.valor_nota) INTO nota_mas_alta
    FROM Nota N
    JOIN AsignaturaGrado AG ON N.asignatura_grado_id = AG.asignatura_grado_id
    WHERE N.estudiante_id = p_estudiante_id AND AG.asignatura_id = p_asignatura_id;
    RETURN IFNULL(nota_mas_alta, 0.00);
END //
DELIMITER ;


-- =============================================================================
-- CONSULTAS USANDO TODAS LAS FUNCIONES ALMACENADAS 
-- =============================================================================

-- Parte 1: Consultas utilizando las 15 Funciones Almacenadas (CREATE FUNCTION)
-- Nota: Los IDs de ejemplo (1, 2, 3, etc.) deben existir en tus tablas para obtener resultados significativos.

-- 1. Usando: CalcularPromedioEstudiante
SELECT
    E.estudiante_id,
    ObtenerNombreCompletoEstudiante(E.estudiante_id) AS NombreEstudiante,
    CalcularPromedioEstudiante(E.estudiante_id) AS PromedioNotas
FROM Estudiante E
WHERE E.estudiante_id = 1;

-- 2. Usando: ObtenerNombreCompletoEstudiante
SELECT
    E.estudiante_id,
    ObtenerNombreCompletoEstudiante(E.estudiante_id) AS NombreCompleto
FROM Estudiante E
WHERE E.estudiante_id = 2;

-- 3. Usando: ContarAsignaturasPorGrado
SELECT
    G.nombre_grado,
    ContarAsignaturasPorGrado(G.grado_id) AS TotalAsignaturas
FROM Grado G
WHERE G.grado_id = 1;

-- 4. Usando: EstudianteTieneTelefono
SELECT
    E.estudiante_id,
    ObtenerNombreCompletoEstudiante(E.estudiante_id) AS NombreEstudiante,
    EstudianteTieneTelefono(E.estudiante_id) AS TieneTelefono
FROM Estudiante E
WHERE E.estudiante_id = 3;

-- 5. Usando: ObtenerGradoEstudiante
SELECT
    E.estudiante_id,
    ObtenerNombreCompletoEstudiante(E.estudiante_id) AS NombreEstudiante,
    ObtenerGradoEstudiante(E.estudiante_id) AS GradoDelEstudiante
FROM Estudiante E
WHERE E.estudiante_id = 4;

-- 6. Usando: CalcularEdadEstudiante
SELECT
    E.estudiante_id,
    ObtenerNombreCompletoEstudiante(E.estudiante_id) AS NombreEstudiante,
    CalcularEdadEstudiante(E.estudiante_id) AS EdadActual
FROM Estudiante E
WHERE E.estudiante_id = 5;

-- 7. Usando: ObtenerSeccionEstudiante
SELECT
    E.estudiante_id,
    ObtenerNombreCompletoEstudiante(E.estudiante_id) AS NombreEstudiante,
    ObtenerSeccionEstudiante(E.estudiante_id) AS SeccionDelEstudiante
FROM Estudiante E
WHERE E.estudiante_id = 6;

-- 8. Usando: AsignaturaEnGrado
SELECT
    A.nombre_asignatura,
    G.nombre_grado,
    AsignaturaEnGrado(A.asignatura_id, G.grado_id) AS EstaEnEsteGrado
FROM Asignatura A, Grado G
WHERE A.asignatura_id = 1 AND G.grado_id = 1; -- Cambia IDs para probar diferentes combinaciones

-- 9. Usando: ContarNotasSuperioresA
SELECT ContarNotasSuperioresA(15.00) AS TotalNotasMayoresA15;

-- 10. Usando: ObtenerEmailProfesor
SELECT
    P.profesor_id,
    CONCAT(P.nombre, ' ', P.apellido) AS NombreProfesor,
    ObtenerEmailProfesor(P.profesor_id) AS EmailProfesor
FROM Profesor P
WHERE P.profesor_id = 1;

-- 11. Usando: EstudianteAprobado (con la lógica de >= 10 puntos)
SELECT
    E.estudiante_id,
    ObtenerNombreCompletoEstudiante(E.estudiante_id) AS NombreEstudiante,
    CalcularPromedioEstudiante(E.estudiante_id) AS Promedio,
    EstudianteAprobado(E.estudiante_id) AS HaAprobado
FROM Estudiante E
WHERE E.estudiante_id = 1;

-- 12. Usando: ContarEstudiantesPorGenero
SELECT
    Ge.nombre_genero,
    ContarEstudiantesPorGenero(Ge.genero_id) AS TotalEstudiantes
FROM Genero Ge
WHERE Ge.genero_id = 1; -- 1 para Masculino, 2 para Femenino

-- 13. Usando: ObtenerDescripcionAsignatura
SELECT
    A.nombre_asignatura,
    ObtenerDescripcionAsignatura(A.asignatura_id) AS DescripcionAsignatura
FROM Asignatura A
WHERE A.asignatura_id = 1;

-- 14. Usando: ExistenNotasEnFecha
SELECT ExistenNotasEnFecha('2025-05-10') AS HayNotasEnEstaFecha; -- Sustituye con una fecha real de tus notas

-- 15. Usando: ObtenerNotaMasAlta
SELECT
    E.nombre,
    E.apellido,
    A.nombre_asignatura,
    ObtenerNotaMasAlta(E.estudiante_id, A.asignatura_id) AS NotaMasAltaEnAsignatura
FROM Estudiante E
JOIN Asignatura A
WHERE E.estudiante_id = 1 AND A.asignatura_id = 1; -- Sustituye con IDs de estudiante y asignatura válidos


------- Asignación de roles
CREATE ROLE 'rol_administrador';
CREATE ROLE 'rol_profesor';
CREATE ROLE 'rol_estudiante';
CREATE ROLE 'rol_lectura'; 

-- Permisos para rol_administrador_db: Acceso total a la base de datos GestionNotas
GRANT ALL PRIVILEGES ON GestionNotas.* TO 'rol_administrador_db';

-- Permisos para rol_gestor_notas:
-- Leer todas las vistas
GRANT SELECT ON GestionNotas.EstudiantesConNombreGradoSeccion TO 'rol_gestor_notas';
GRANT SELECT ON GestionNotas.NotasPorEstudianteAsignatura TO 'rol_gestor_notas';
GRANT SELECT ON GestionNotas.ProfesoresConNombreCompleto TO 'rol_gestor_notas';
GRANT SELECT ON GestionNotas.AsignaturasPorGrado TO 'rol_gestor_notas';
GRANT SELECT ON GestionNotas.PromedioNotasPorEstudiante TO 'rol_gestor_notas';
-- Permisos de INSERT y UPDATE en tablas clave (ej. Estudiante, Nota, Profesor)
GRANT INSERT, UPDATE ON GestionNotas.Estudiante TO 'rol_gestor_notas';
GRANT INSERT, UPDATE ON GestionNotas.Nota TO 'rol_gestor_notas';
GRANT INSERT, UPDATE ON GestionNotas.Profesor TO 'rol_gestor_notas';
-- Permisos para ver todas las tablas (esto incluye las que no tienen insert/update directo para este rol)
GRANT SELECT ON GestionNotas.Asignatura TO 'rol_gestor_notas';
GRANT SELECT ON GestionNotas.AsignaturaGrado TO 'rol_gestor_notas';
GRANT SELECT ON GestionNotas.Grado TO 'rol_gestor_notas';
GRANT SELECT ON GestionNotas.Seccion TO 'rol_gestor_notas';
GRANT SELECT ON GestionNotas.Genero TO 'rol_gestor_notas';

-- Permisos para rol_solo_lectura:
-- Solo lectura en las 5 vistas específicas
GRANT SELECT ON GestionNotas.EstudiantesConNombreGradoSeccion TO 'rol_solo_lectura';
GRANT SELECT ON GestionNotas.NotasPorEstudianteAsignatura TO 'rol_solo_lectura';
GRANT SELECT ON GestionNotas.ProfesoresConNombreCompleto TO 'rol_solo_lectura';
GRANT SELECT ON GestionNotas.AsignaturasPorGrado TO 'rol_solo_lectura';
GRANT SELECT ON GestionNotas.PromedioNotasPorEstudiante TO 'rol_solo_lectura';
-- Permisos para leer todas las tablas 
GRANT SELECT ON GestionNotas.Estudiante TO 'rol_solo_lectura';
GRANT SELECT ON GestionNotas.Nota TO 'rol_solo_lectura';
GRANT SELECT ON GestionNotas.Profesor TO 'rol_solo_lectura';
GRANT SELECT ON GestionNotas.Asignatura TO 'rol_solo_lectura';
GRANT SELECT ON GestionNotas.AsignaturaGrado TO 'rol_solo_lectura';
GRANT SELECT ON GestionNotas.Grado TO 'rol_solo_lectura';
GRANT SELECT ON GestionNotas.Seccion TO 'rol_solo_lectura';
GRANT SELECT ON GestionNotas.Genero TO 'rol_solo_lectura';

-- Usuario Administrador de la DB
CREATE USER 'db_admin_user'@'localhost' IDENTIFIED BY 'AdminDBPass2025!';
GRANT 'rol_administrador_db' TO 'db_admin_user'@'localhost';
SET DEFAULT ROLE 'rol_administrador_db' TO 'db_admin_user'@'localhost';

-- Usuario Gestor de Notas (ej. un secretario o coordinador académico)
CREATE USER 'gestor_notas_user'@'localhost' IDENTIFIED BY 'GestorNotasPass2025';
GRANT 'rol_gestor_notas' TO 'gestor_notas_user'@'localhost';
SET DEFAULT ROLE 'rol_gestor_notas' TO 'gestor_notas_user'@'localhost';

-- Usuario Solo Lectura (ej. un visitante o analista que no modifica datos)
CREATE USER 'readonly_user'@'localhost' IDENTIFIED BY 'ReadPass2025';
GRANT 'rol_solo_lectura' TO 'readonly_user'@'localhost';
SET DEFAULT ROLE 'rol_solo_lectura' TO 'readonly_user'@'localhost';

-- Para replicar 
CREATE USER 'usuario_lectura_img'@'localhost' IDENTIFIED BY 'Password123';
GRANT USAGE ON *.* TO 'usuario_lectura_img'@'localhost';
GRANT SELECT ('fecha', 'monto') ON mi_empresa.ventas TO 'usuario_lectura_img'@'localhost'; -- Adaptar a tu DB si es necesario
GRANT SELECT ON mi_empresa.`vista usuarios` TO 'usuario_lectura_img'@'localhost'; -- 
GRANT 'prueba@%', 'prueba2@localhost' TO 'usuario_lectura_img'@'localhost'; 
FLUSH PRIVILEGES; 
----Mostrar permisos
SHOW GRANTS FOR 'db_admin_user'@'localhost';
SHOW GRANTS FOR 'gestor_notas_user'@'localhost';
SHOW GRANTS FOR 'readonly_user'@'localhost';
SHOW GRANTS FOR 'usuario_lectura_img'@'localhost';

---- Uso de DROP 
DROP USER IF EXISTS 'admin_total'@'localhost';
DROP USER IF EXISTS 'profe_matematica'@'localhost';
DROP USER IF EXISTS 'profe_historia'@'%';
DROP USER IF EXISTS 'estudiante_juanperez'@'localhost';
DROP USER IF EXISTS 'estudiante_anagarcia'@'localhost';
DROP USER IF EXISTS 'auditor_reportes'@'localhost';

DROP USER IF EXISTS 'analista_rrhh'@'localhost';
DROP USER IF EXISTS 'editor_asignaturas'@'localhost';
DROP USER IF EXISTS 'personal_secretaria'@'localhost';
DROP USER IF EXISTS 'desarrollador_temp'@'localhost';
DROP USER IF EXISTS 'respaldo_data'@'localhost';

DROP ROLE IF EXISTS 'rol_administrador';
DROP ROLE IF EXISTS 'rol_profesor';
DROP ROLE IF EXISTS 'rol_estudiante';
DROP ROLE IF EXISTS 'rol_lectura';

DROP VIEW IF EXISTS EstudiantesConNombreGradoSeccion;
DROP VIEW IF EXISTS NotasPorEstudianteAsignatura;
DROP VIEW IF EXISTS ProfesoresConNombreCompleto;
DROP VIEW IF EXISTS AsignaturasPorGrado;
DROP VIEW IF EXISTS PromedioNotasPorEstudiante;

DROP TABLE IF EXISTS Nota;
DROP TABLE IF EXISTS AsignaturaGrado;
DROP TABLE IF EXISTS Estudiante;
DROP TABLE IF EXISTS Profesor;
DROP TABLE IF EXISTS Asignatura;
DROP TABLE IF EXISTS Grado;
DROP TABLE IF EXISTS Seccion;
DROP TABLE IF EXISTS Genero;

FLUSH PRIVILEGES;

-- DROP DATABASE IF EXISTS GestionNotas; 
 






 


 


