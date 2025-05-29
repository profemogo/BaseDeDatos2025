-- Trigger: no permitir favoritos en eventos sin capacidad

DELIMITER //
CREATE TRIGGER check_event_capacity
BEFORE INSERT ON Favorite
FOR EACH ROW
BEGIN
    DECLARE cap INT;
    DECLARE used INT;

    SELECT capacity INTO cap FROM Event WHERE event_id = NEW.event_id;
    SELECT COUNT(*) INTO used FROM Favorite WHERE event_id = NEW.event_id;

    IF used >= cap THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No hay más capacidad para este evento.';
    END IF;
END;
//
DELIMITER ;