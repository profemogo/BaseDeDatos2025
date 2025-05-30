USE GestionNotas;

--  T1: Insertar Géneros
START TRANSACTION;
    INSERT INTO Genero (descripcion) VALUES ('Masculino'), ('Femenino'), ('No Binario');
COMMIT;

--  T2: Insertar Grados
START TRANSACTION;
    INSERT INTO Grado (nombre_grado) VALUES 
        ('1er Grado'), ('2do Grado'), ('3er Grado'), 
        ('4to Grado'), ('5to Grado'), ('6to Grado');
COMMIT;

--  T3: Insertar Secciones
START TRANSACTION;
    INSERT INTO Seccion (nombre_seccion) VALUES 
        ('A'), ('B'), ('C'), ('D');
COMMIT;

--  T4: Insertar Profesores
START TRANSACTION;
    INSERT INTO Profesor (nombre, apellido, email, telefono) VALUES
        ('Juan', 'García', 'juan.garcia@email.com', '0412-1234567'),
        ('Ana', 'Pérez', 'ana.perez@email.com', '0412-7654321'),
        ('Carlos', 'Rodríguez', 'carlos.rodriguez@email.com', '0414-1112233'),
        ('Sofía', 'Martínez', 'sofia.martinez@email.com', '0416-9988776'),
        ('Miguel', 'Fernández', 'miguel.fernandez@email.com', '0424-5544332');
COMMIT;

--  T5: Insertar Estudiantes con validaciones
START TRANSACTION;
    INSERT INTO Estudiante (nombre, apellido, fecha_nacimiento, genero_id, grado_id, seccion_id, email) VALUES
        ('Pedro', 'Ramírez', '2010-01-15', (SELECT genero_id FROM Genero WHERE descripcion = 'Masculino' LIMIT 1), 1, 1, 'pedro.ramirez@email.com'),
        ('Laura', 'Flores', '2009-03-20', (SELECT genero_id FROM Genero WHERE descripcion = 'Femenino' LIMIT 1), 2, 2, 'laura.flores@email.com'),
        ('Diego', 'Torres', '2008-07-10', (SELECT genero_id FROM Genero WHERE descripcion = 'Masculino' LIMIT 1), 3, 3, 'diego.torres@email.com'),
        ('Valentina', 'Díaz', '2007-05-05', (SELECT genero_id FROM Genero WHERE descripcion = 'Femenino' LIMIT 1), 4, 1, 'valentina.diaz@email.com'),
        ('Mateo', 'Gómez', '2010-09-08', (SELECT genero_id FROM Genero WHERE descripcion = 'Masculino' LIMIT 1), 1, 2, 'mateo.gomez@email.com'),
        ('Isabella', 'Ruiz', '2011-02-14', (SELECT genero_id FROM Genero WHERE descripcion = 'Femenino' LIMIT 1), 1, 1, 'isabella.ruiz@email.com'),
        ('Emilia', 'Castillo', '2009-07-25', (SELECT genero_id FROM Genero WHERE descripcion = 'Femenino' LIMIT 1), 3, 3, 'emilia.castillo@email.com'),
        ('Samuel', 'Fernández', '2008-06-19', (SELECT genero_id FROM Genero WHERE descripcion = 'Masculino' LIMIT 1), 5, 2, 'samuel.fernandez@email.com'),
        ('Daniel', 'Paredes', '2007-04-30', (SELECT genero_id FROM Genero WHERE descripcion = 'Masculino' LIMIT 1), 6, 4, 'daniel.paredes@email.com'),
        ('Camila', 'Mendoza', '2012-01-23', (SELECT genero_id FROM Genero WHERE descripcion = 'Femenino' LIMIT 1), 1, 3, 'camila.mendoza@email.com');
COMMIT;

--  T6: Insertar Asignaturas
START TRANSACTION;
    INSERT INTO Asignatura (nombre_asignatura) VALUES
        ('Matemáticas'), ('Lenguaje'), ('Ciencias Naturales'),
        ('Historia'), ('Inglés'), ('Educación Física'), ('Arte');
COMMIT;

--  T7: Relacionar Asignaturas con Grados y Profesores
START TRANSACTION;
    INSERT INTO AsignaturaGrado (asignatura_id, grado_id, profesor_id) VALUES
        ((SELECT asignatura_id FROM Asignatura WHERE nombre_asignatura = 'Matemáticas' LIMIT 1), 
         (SELECT grado_id FROM Grado WHERE nombre_grado = '1er Grado' LIMIT 1), 
         (SELECT profesor_id FROM Profesor WHERE nombre = 'Juan' AND apellido = 'García' LIMIT 1)),
        ((SELECT asignatura_id FROM Asignatura WHERE nombre_asignatura = 'Lenguaje' LIMIT 1), 
         (SELECT grado_id FROM Grado WHERE nombre_grado = '1er Grado' LIMIT 1), 
         (SELECT profesor_id FROM Profesor WHERE nombre = 'Ana' AND apellido = 'Pérez' LIMIT 1));
COMMIT;

--  T8: Insertar Notas asegurando relaciones válidas
START TRANSACTION;
    INSERT INTO Nota (estudiante_id, asignatura_id, profesor_id, valor_nota, fecha_nota) VALUES
        ((SELECT estudiante_id FROM Estudiante WHERE nombre = 'Pedro' AND apellido = 'Ramírez' LIMIT 1),
         (SELECT asignatura_id FROM Asignatura WHERE nombre_asignatura = 'Matemáticas' LIMIT 1),
         (SELECT profesor_id FROM Profesor WHERE nombre = 'Juan' AND apellido = 'García' LIMIT 1),
         18.5, CURRENT_DATE()),
        ((SELECT estudiante_id FROM Estudiante WHERE nombre = 'Laura' AND apellido = 'Flores' LIMIT 1),
         (SELECT asignatura_id FROM Asignatura WHERE nombre_asignatura = 'Lenguaje' LIMIT 1),
         (SELECT profesor_id FROM Profesor WHERE nombre = 'Ana' AND apellido = 'Pérez' LIMIT 1),
         16.8, CURRENT_DATE());
COMMIT;

--  T9: Ajuste de Secciones de algunos estudiantes
START TRANSACTION;
    UPDATE Estudiante
    SET seccion_id = (SELECT seccion_id FROM Seccion WHERE nombre_seccion = 'A' LIMIT 1)
    WHERE grado_id = (SELECT grado_id FROM Grado WHERE nombre_grado = '3er Grado' LIMIT 1);
COMMIT;

