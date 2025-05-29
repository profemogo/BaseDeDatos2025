-- Estos Procesos y funciones no creo que los usaria pero los invente para el proyecto
-- Función: calcular asistentes faltantes para evento
DELIMITER //

CREATE FUNCTION remaining_capacity(e_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE max_cap INT;
    DECLARE current_favs INT;
    SELECT capacity INTO max_cap FROM Event WHERE event_id = e_id;
    SELECT COUNT(*) INTO current_favs FROM Favorite WHERE event_id = e_id;
    RETURN max_cap - current_favs;
END;
//

-- Procedimiento: Añadir favorito con verificación de duplicado
CREATE PROCEDURE add_favorite(IN u_id INT, IN e_id INT)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Favorite WHERE user_id = u_id AND event_id = e_id) THEN
        INSERT INTO Favorite (user_id, event_id) VALUES (u_id, e_id);
    END IF;
END;
//
DELIMITER ;