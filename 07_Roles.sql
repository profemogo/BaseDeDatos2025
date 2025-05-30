USE GestionNotas;

-- Eliminar roles (si existen) para una ejecución limpia
DROP ROLE IF EXISTS 'rol_administrador';
DROP ROLE IF EXISTS 'rol_profesor';
DROP ROLE IF EXISTS 'rol_estudiante';
DROP ROLE IF EXISTS 'rol_lectura';

-- Crear Roles
CREATE ROLE 'rol_administrador';
CREATE ROLE 'rol_profesor';
CREATE ROLE 'rol_estudiante';
CREATE ROLE 'rol_lectura';

-- Asignar Permisos a cada Rol

-- Permisos para 'rol_administrador'
-- Control total sobre la base de datos (tablas y vistas).
GRANT ALL PRIVILEGES ON GestionNotas.* TO 'rol_administrador';

-- Permisos para 'rol_profesor'
-- Los profesores pueden gestionar notas y sus asignaciones, y consultar información relevante.
-- NO tienen permisos DML sobre vistas, solo sobre tablas base.

-- Permisos DML (INSERT, UPDATE, DELETE) en TABLAS:
GRANT SELECT, INSERT, UPDATE, DELETE ON GestionNotas.Nota TO 'rol_profesor';
GRANT SELECT, UPDATE ON GestionNotas.Profesor TO 'rol_profesor'; -- Para actualizar su propio perfil
GRANT SELECT, INSERT, UPDATE ON GestionNotas.AsignaturaGrado TO 'rol_profesor'; -- Para gestionar asignaciones

-- Permisos SELECT en TABLAS (para datos de referencia que no están en vistas o para operaciones internas):
GRANT SELECT ON GestionNotas.Estudiante TO 'rol_profesor';
GRANT SELECT ON GestionNotas.Asignatura TO 'rol_profesor';
GRANT SELECT ON GestionNotas.Grado TO 'rol_profesor';
GRANT SELECT ON GestionNotas.Seccion TO 'rol_profesor';
GRANT SELECT ON GestionNotas.Genero TO 'rol_profesor';
GRANT SELECT ON GestionNotas.Auditoria TO 'rol_profesor'; -- Para que puedan ver logs de auditoría si es necesario

-- Permisos SELECT en VISTAS (para reportes e información estructurada):
GRANT SELECT ON GestionNotas.DetalleAuditoriaPorTipoEvento TO 'rol_profesor';
GRANT SELECT ON GestionNotas.PromedioNotasPorAsignaturaGrado TO 'rol_profesor';
GRANT SELECT ON GestionNotas.CargaAcademicaProfesor TO 'rol_profesor';
GRANT SELECT ON GestionNotas.NotasDetalladasPorEstudiante TO 'rol_profesor';
GRANT SELECT ON GestionNotas.MisAsignaturasConProfesor TO 'rol_profesor';
GRANT SELECT ON GestionNotas.EstudiantesConPromedioBajo TO 'rol_profesor';
GRANT SELECT ON GestionNotas.EstudiantesActivosPorGradoSeccion TO 'rol_profesor';
GRANT SELECT ON GestionNotas.AsignaturasSinNotasRegistradas TO 'rol_profesor';
GRANT SELECT ON GestionNotas.EstudiantesPorGenero TO 'rol_profesor';
GRANT SELECT ON GestionNotas.GradosConMasEstudiantes TO 'rol_profesor';