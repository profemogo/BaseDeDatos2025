USE swimmingProject_v1;

-- =============================================
-- Datos Iniciales para Sistema de Natación
-- Descripción: Contiene los datos fundamentales y estandarizados
-- según las regulaciones de la natación profesional
-- =============================================

-- -----------------------------
-- Estilos de Nado Oficiales
-- -----------------------------
INSERT INTO EstilosNado (nombre) VALUES
    ('Mariposa'),
    ('Espalda'),
    ('Pecho'),
    ('Libre'),
    ('Combinado');  -- 200m y 400m

-- -----------------------------
-- Distancias Oficiales (metros)
-- -----------------------------
INSERT INTO Metrajes (metros) VALUES
    (50),    -- Solo para estilos individuales
    (100),   -- Todos los estilos
    (200),   -- Todos los estilos
    (400),   -- Libre y Combinado 
    (800),   -- Solo Libre
    (1500);  -- Solo Libre

-- -----------------------------
-- Combinaciones Válidas Estilo-Metraje
-- -----------------------------
-- Variables para almacenar IDs
SET @mariposa_id = (SELECT id FROM EstilosNado WHERE nombre = 'Mariposa');
SET @espalda_id = (SELECT id FROM EstilosNado WHERE nombre = 'Espalda');
SET @pecho_id = (SELECT id FROM EstilosNado WHERE nombre = 'Pecho');
SET @libre_id = (SELECT id FROM EstilosNado WHERE nombre = 'Libre');
SET @combinado_id = (SELECT id FROM EstilosNado WHERE nombre = 'Combinado');

SET @50m_id = (SELECT id FROM Metrajes WHERE metros = 50);
SET @100m_id = (SELECT id FROM Metrajes WHERE metros = 100);
SET @200m_id = (SELECT id FROM Metrajes WHERE metros = 200);
SET @400m_id = (SELECT id FROM Metrajes WHERE metros = 400);
SET @800m_id = (SELECT id FROM Metrajes WHERE metros = 800);
SET @1500m_id = (SELECT id FROM Metrajes WHERE metros = 1500);

-- Mariposa: 50m, 100m, 200m
INSERT INTO EstiloMetraje (estilo_id, metraje_id) VALUES
    (@mariposa_id, @50m_id),
    (@mariposa_id, @100m_id),
    (@mariposa_id, @200m_id);

-- Espalda: 50m, 100m, 200m
INSERT INTO EstiloMetraje (estilo_id, metraje_id) VALUES
    (@espalda_id, @50m_id),
    (@espalda_id, @100m_id),
    (@espalda_id, @200m_id);

-- Pecho: 50m, 100m, 200m
INSERT INTO EstiloMetraje (estilo_id, metraje_id) VALUES
    (@pecho_id, @50m_id),
    (@pecho_id, @100m_id),
    (@pecho_id, @200m_id);

-- Libre: todas las distancias
INSERT INTO EstiloMetraje (estilo_id, metraje_id) VALUES
    (@libre_id, @50m_id),
    (@libre_id, @100m_id),
    (@libre_id, @200m_id),
    (@libre_id, @400m_id),
    (@libre_id, @800m_id),
    (@libre_id, @1500m_id);

-- Combinado: 200m, 400m
INSERT INTO EstiloMetraje (estilo_id, metraje_id) VALUES
    (@combinado_id, @200m_id),
    (@combinado_id, @400m_id);

-- -----------------------------
-- Géneros
-- -----------------------------
INSERT INTO Genero (nombre) VALUES
    ('Masculino'),
    ('Femenino');

-- -----------------------------
-- Categorías de Edad Estándar
-- -----------------------------
INSERT INTO CategoriaEdad (nombre, edad_minima, edad_maxima) VALUES
    ('Infantil A', 7, 8),
    ('Infantil B', 9, 10),
    ('Juvenil A', 11, 12),
    ('Juvenil B', 13, 14),
    ('Junior', 15, 17),
    ('Senior', 18, 25),
    ('Master', 26, 120);  -- Categoría única para mayores de 25 años

-- Comentarios sobre las combinaciones:
-- 1. Pruebas individuales:
--    - 50m, 100m, 200m: Mariposa, Espalda, Pecho y Libre
--    - 400m: Libre y Combinado
--    - 800m y 1500m: Solo Libre
-- 2. Combinado:
--    - 200m y 400m: Orden: Mariposa, Espalda, Pecho, Libre 