
-- Trigger para validar la fecha de nacimiento al insertar un paciente 
DELIMITER //
CREATE TRIGGER before_paciente_insert
BEFORE INSERT ON Paciente
FOR EACH ROW
BEGIN
    IF NEW.fecha_nacimiento > CURDATE() THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'La fecha de nacimiento no puede ser futura';
    END IF;
END //
DELIMITER ;