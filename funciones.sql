USE swimmingProject_v1;

-- =============================================
-- Función: CalcularPuntajeCompetencia
-- Descripción: Calcula el puntaje total de un nadador en una competencia específica
-- Parámetros:
--   p_nadador_id: ID del nadador
--   p_competencia_id: ID de la competencia
-- Retorna: Puntaje total (DECIMAL)
-- Lógica de puntuación (solo primeros 8 lugares):
--   - Primer lugar: 10 puntos
--   - Segundo lugar: 8 puntos
--   - Tercer lugar: 6 puntos
--   - Cuarto lugar: 5 puntos
--   - Quinto lugar: 4 puntos
--   - Sexto lugar: 3 puntos
--   - Séptimo lugar: 2 puntos
--   - Octavo lugar: 1 punto
--   - Después del octavo lugar: 0 puntos
-- =============================================
DELIMITER //

CREATE OR REPLACE FUNCTION CalcularPuntajeCompetencia(
    p_nadador_id BIGINT,
    p_competencia_id BIGINT
) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE v_puntaje_total DECIMAL(10,2) DEFAULT 0;
    
    -- Calcular puntos por posición (solo primeros 8 lugares)
    SELECT 
        SUM(CASE 
            WHEN posicion_final = 1 THEN 10
            WHEN posicion_final = 2 THEN 8
            WHEN posicion_final = 3 THEN 6
            WHEN posicion_final = 4 THEN 5
            WHEN posicion_final = 5 THEN 4
            WHEN posicion_final = 6 THEN 3
            WHEN posicion_final = 7 THEN 2
            WHEN posicion_final = 8 THEN 1
            ELSE 0
        END) INTO v_puntaje_total
    FROM RegistroCompetencias
    WHERE nadador_id = p_nadador_id 
    AND competencia_id = p_competencia_id
    AND estado = 'finalizado'
    AND posicion_final <= 8;  -- Solo considerar los primeros 8 lugares
    
    -- Si no hay participaciones en los primeros 8 lugares, retornar 0
    IF v_puntaje_total IS NULL THEN
        RETURN 0;
    END IF;
    
    RETURN v_puntaje_total;
END //

-- =============================================
-- Función: CalcularRankingClub
-- Descripción: Calcula la posición y puntaje total de un club en un año específico
-- Parámetros:
--   p_club_id: ID del club
--   p_anio: Año a calcular
-- Retorna: JSON con posición y puntaje total
-- Lógica de ranking:
--   - Suma de puntos de competencias de todos los nadadores del club
-- =============================================

CREATE OR REPLACE FUNCTION CalcularRankingClub(
    p_club_id BIGINT,
    p_anio INT
) RETURNS JSON
DETERMINISTIC
BEGIN
    DECLARE v_puntaje_total DECIMAL(10,2) DEFAULT 0;
    DECLARE v_posicion INT;
    
    -- Calcular puntos por competencias
    SELECT SUM(CalcularPuntajeCompetencia(n.id, c.id)) INTO v_puntaje_total
    FROM Nadadores n
    JOIN RegistroCompetencias rc ON n.id = rc.nadador_id
    JOIN Competencias c ON rc.competencia_id = c.id
    WHERE n.club_id = p_club_id
    AND YEAR(c.fecha_inicio) = p_anio;
    
    -- Calcular posición comparando con otros clubes
    SELECT COUNT(*) + 1 INTO v_posicion
    FROM (
        SELECT c.id, SUM(CalcularPuntajeCompetencia(n.id, comp.id)) as puntos_club
        FROM Club c
        JOIN Nadadores n ON c.id = n.club_id
        JOIN RegistroCompetencias rc ON n.id = rc.nadador_id
        JOIN Competencias comp ON rc.competencia_id = comp.id
        WHERE YEAR(comp.fecha_inicio) = p_anio
        AND c.id != p_club_id
        GROUP BY c.id
        HAVING puntos_club > COALESCE(v_puntaje_total, 0)
    ) otros_clubes;
    
    -- Si no hay puntaje, establecer valores por defecto
    IF v_puntaje_total IS NULL THEN
        SET v_puntaje_total = 0;
    END IF;
    
    -- Retornar resultado en formato JSON
    RETURN JSON_OBJECT(
        'posicion', v_posicion,
        'puntaje', v_puntaje_total,
        'club_id', p_club_id,
        'anio', p_anio
    );
END //

DELIMITER ;

-- Ejemplos de uso:
-- Calcular puntaje de un nadador en una competencia:
-- SELECT CalcularPuntajeCompetencia(1, 1) as puntaje;

-- Calcular ranking de un club en un año específico:
-- SELECT CalcularRankingClub(1, 2024) as ranking;

-- Obtener ranking completo de clubes para un año:
-- SELECT 
--     c.nombre as club,
--     JSON_EXTRACT(CalcularRankingClub(c.id, 2024), '$.posicion') as posicion,
--     JSON_EXTRACT(CalcularRankingClub(c.id, 2024), '$.puntaje') as puntaje
-- FROM Club c
-- ORDER BY posicion; 