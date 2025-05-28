DELIMITER @@@ 
CREATE TRIGGER AfterAdopcionInsert AFTER INSERT ON Adopcion FOR EACH ROW 
BEGIN
    UPDATE Mascota
    SET dueño_id = NEW.adoptante_id
    WHERE id = NEW.mascota_id;
END @@@ 
DELIMITER ;

DELIMITER @@@ 
CREATE TRIGGER AfterAdopcionUpdate AFTER UPDATE ON Adopcion FOR EACH ROW 
BEGIN 
    IF NEW.adoptante_id != OLD.adoptante_id THEN
        UPDATE Mascota
        SET dueño_id = NEW.adoptante_id
        WHERE id = NEW.mascota_id;
    END IF;
END @@@ 
DELIMITER ;

DELIMITER @@@ 
CREATE TRIGGER AfterAdopcionDelete AFTER DELETE ON Adopcion FOR EACH ROW 
BEGIN
    UPDATE Mascota
    SET dueño_id = NULL
    WHERE id = OLD.mascota_id;
END @@@ 
DELIMITER ;