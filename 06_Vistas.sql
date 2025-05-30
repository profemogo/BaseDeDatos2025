USE GestionNotas;

-- Vista: Registro de Auditoría
CREATE OR REPLACE VIEW DetalleAuditoriaPorTipoEvento AS
SELECT fecha_hora, usuario, tipo_evento, datos_antes, datos_despues
FROM Auditoria
ORDER BY fecha_hora DESC
LIMIT 100;

-- Vista: Promedio de Notas por Asignatura y Grado
CREATE OR REPLACE VIEW PromedioNotasPorAsignaturaGrado AS
SELECT G.nombre_grado, A.nombre_asignatura, ROUND(AVG(N.valor_nota), 2) AS promedio_asignatura_grado
FROM Nota N
JOIN Estudiante E ON N.estudiante_id = E.estudiante_id
JOIN Grado G ON E.grado_id = G.grado_id
JOIN Asignatura A ON N.asignatura_id = A.asignatura_id
GROUP BY G.nombre_grado, A.nombre_asignatura
ORDER BY G.nombre_grado, A.nombre_asignatura;

-- Vista: Carga Académica del Profesor
CREATE OR REPLACE VIEW CargaAcademicaProfesor AS
SELECT CONCAT(P.nombre, ' ', P.apellido) AS nombre_profesor, A.nombre_asignatura, G.nombre_grado
FROM Profesor P
JOIN AsignaturaGrado AG ON P.profesor_id = AG.profesor_id
JOIN Asignatura A ON AG.asignatura_id = A.asignatura_id
JOIN Grado G ON AG.grado_id = G.grado_id
ORDER BY nombre_profesor, G.nombre_grado, A.nombre_asignatura;

-- Vista: Notas Detalladas por Estudiante
CREATE OR REPLACE VIEW NotasDetalladasPorEstudiante AS
SELECT CONCAT(E.nombre, ' ', E.apellido) AS nombre_estudiante, G.nombre_grado, S.nombre_seccion, 
       A.nombre_asignatura, N.valor_nota, N.fecha_nota, CONCAT(P.nombre, ' ', P.apellido) AS profesor_que_registro
FROM Nota N
JOIN Estudiante E ON N.estudiante_id = E.estudiante_id
JOIN Asignatura A ON N.asignatura_id = A.asignatura_id
JOIN Profesor P ON N.profesor_id = P.profesor_id
JOIN Grado G ON E.grado_id = G.grado_id
JOIN Seccion S ON E.seccion_id = S.seccion_id
ORDER BY nombre_estudiante, G.nombre_grado, A.nombre_asignatura, N.fecha_nota;

-- Vista: Mis Asignaturas y Profesores
CREATE OR REPLACE VIEW MisAsignaturasConProfesor AS
SELECT A.nombre_asignatura, CONCAT(P.nombre, ' ', P.apellido) AS nombre_profesor
FROM AsignaturaGrado AG
JOIN Asignatura A ON AG.asignatura_id = A.asignatura_id
JOIN Profesor P ON AG.profesor_id = P.profesor_id
ORDER BY A.nombre_asignatura, nombre_profesor;

-- Vista: Estudiantes con Promedio Bajo
CREATE OR REPLACE VIEW EstudiantesConPromedioBajo AS
SELECT E.estudiante_id, CONCAT(E.nombre, ' ', E.apellido) AS nombre_estudiante, G.nombre_grado, S.nombre_seccion,
       ROUND(COALESCE(AVG(N.valor_nota), 0.0), 2) AS promedio_general
FROM Estudiante E
LEFT JOIN Nota N ON E.estudiante_id = N.estudiante_id
JOIN Grado G ON E.grado_id = G.grado_id
JOIN Seccion S ON E.seccion_id = S.seccion_id
GROUP BY E.estudiante_id, nombre_estudiante, G.nombre_grado, S.nombre_seccion
HAVING promedio_general < 12.0
ORDER BY promedio_general ASC, nombre_estudiante;

-- Vista: Estudiantes Activos por Grado y Sección
CREATE OR REPLACE VIEW EstudiantesActivosPorGradoSeccion AS
SELECT G.nombre_grado, S.nombre_seccion, COUNT(E.estudiante_id) AS total_estudiantes
FROM Estudiante E
JOIN Grado G ON E.grado_id = G.grado_id
JOIN Seccion S ON E.seccion_id = S.seccion_id
GROUP BY G.nombre_grado, S.nombre_seccion
ORDER BY G.nombre_grado, S.nombre_seccion;

-- Vista: Asignaturas Sin Notas Registradas
CREATE OR REPLACE VIEW AsignaturasSinNotasRegistradas AS
SELECT A.asignatura_id, A.nombre_asignatura
FROM Asignatura A
LEFT JOIN Nota N ON A.asignatura_id = N.asignatura_id
WHERE N.nota_id IS NULL
ORDER BY A.nombre_asignatura;

-- Vista: Estudiantes por Género
CREATE OR REPLACE VIEW EstudiantesPorGenero AS
SELECT GE.descripcion AS nombre_genero, COUNT(E.estudiante_id) AS total_estudiantes
FROM Estudiante E
JOIN Genero GE ON E.genero_id = GE.genero_id
GROUP BY GE.descripcion
ORDER BY total_estudiantes DESC;

-- Vista: Grados con Más Estudiantes
CREATE OR REPLACE VIEW GradosConMasEstudiantes AS
SELECT G.nombre_grado, COUNT(E.estudiante_id) AS total_estudiantes
FROM Grado G
JOIN Estudiante E ON G.grado_id = E.grado_id
GROUP BY G.nombre_grado
ORDER BY total_estudiantes DESC;

