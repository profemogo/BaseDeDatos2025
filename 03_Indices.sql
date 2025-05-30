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
