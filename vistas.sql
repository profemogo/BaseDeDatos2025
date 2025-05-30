USE swimmingProject_v1;

-- =============================================
-- Vista: vista_nadadores_por_club
-- Descripción: Vista resumida que muestra información general de los nadadores por club
-- Uso principal: Reportes administrativos y resúmenes generales
-- Características:
--   - Muestra el total de nadadores por club
--   - Lista concatenada de nadadores con sus edades
--   - Incluye clubes sin nadadores (LEFT JOIN)
--   - Ordenada alfabéticamente por nombre del club
-- =============================================
DROP VIEW IF EXISTS vista_nadadores_por_club;

CREATE VIEW vista_nadadores_por_club AS
SELECT 
    c.nombre as nombre_club,      -- Nombre del club
    c.ciudad as ciudad_club,      -- Ciudad donde se encuentra el club
    COUNT(n.id) as total_nadadores,  -- Contador de nadadores (null no cuenta en LEFT JOIN)
    GROUP_CONCAT(                    -- Lista concatenada de nadadores con edad
        CONCAT(n.nombre, ' ', n.apellidos, ' (', 
        TIMESTAMPDIFF(YEAR, n.fecha_nacimiento, CURDATE()), ' años)')
        ORDER BY n.apellidos, n.nombre
        SEPARATOR ', '
    ) as lista_nadadores
FROM 
    Club c
    LEFT JOIN Nadadores n ON c.id = n.club_id  -- LEFT JOIN mantiene clubes sin nadadores
GROUP BY 
    c.id, c.nombre, c.ciudad
ORDER BY 
    c.nombre;

-- =============================================
-- Vista: vista_estadisticas_nadadores_club
-- Descripción: Vista detallada que muestra estadísticas de rendimiento de cada nadador por club
-- Uso principal: Análisis técnico y seguimiento de rendimiento deportivo
-- Características:
--   - Información personal del nadador
--   - Estadísticas de participación y rendimiento
--   - Identificación de fortalezas (estilo más fuerte)
--   - Solo incluye nadadores activos (INNER JOIN)
-- =============================================
DROP VIEW IF EXISTS vista_estadisticas_nadadores_club;

CREATE VIEW vista_estadisticas_nadadores_club AS
SELECT 
    c.nombre as club,             -- Nombre del club
    c.ciudad,                     -- Ciudad del club
    n.nombre,                     -- Nombre del nadador
    n.apellidos,                  -- Apellidos del nadador
    ce.nombre as categoria,       -- Categoría de edad del nadador
    g.nombre as genero,          -- Género del nadador
    (SELECT COUNT(DISTINCT rc.competencia_id)   -- Total de competencias diferentes
     FROM RegistroCompetencias rc 
     WHERE rc.nadador_id = n.id) as total_competencias,
    (SELECT COUNT(*)                            -- Total de records conseguidos
     FROM Records r 
     WHERE r.nadador_id = n.id) as total_records,
    (SELECT COUNT(*)                            -- Total de records personales
     FROM Tiempos t 
     JOIN RegistroCompetencias rc ON t.registro_competencia_id = rc.id 
     WHERE rc.nadador_id = n.id AND t.es_record = TRUE) as records_personales,
    (SELECT em.nombre                           -- Estilo de nado más exitoso
     FROM EstilosNado em 
     JOIN EstiloMetraje e ON em.id = e.estilo_id  
     JOIN Records r ON e.id = r.estilo_metraje_id 
     WHERE r.nadador_id = n.id 
     GROUP BY em.id, em.nombre  -- Agregado em.nombre para evitar ambigüedad
     ORDER BY COUNT(*) DESC 
     LIMIT 1) as estilo_mas_fuerte
FROM 
    Club c
    JOIN Nadadores n ON c.id = n.club_id           -- INNER JOIN solo nadadores activos
    JOIN CategoriaEdad ce ON n.categoria_edad_id = ce.id
    JOIN Genero g ON n.genero_id = g.id
ORDER BY 
    c.nombre,                     -- Ordenado por club
    n.apellidos,                  -- Luego por apellidos
    n.nombre;                     -- Finalmente por nombre

-- Ejemplos de uso:
-- 1. Ver todos los clubes y su cantidad de nadadores:
--    SELECT nombre_club, total_nadadores FROM vista_nadadores_por_club;

-- 2. Ver estadísticas completas de nadadores de un club específico:
--    SELECT * FROM vista_estadisticas_nadadores_club WHERE club = 'Nombre del Club';

-- 3. Encontrar nadadores con más records:
--    SELECT nombre, apellidos, club, total_records 
--    FROM vista_estadisticas_nadadores_club 
--    WHERE total_records > 0 
--    ORDER BY total_records DESC;