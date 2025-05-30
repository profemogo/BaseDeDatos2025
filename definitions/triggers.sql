/**
 * Expenses App
 *
 * Author: Ender Jose Puentes Vargas
 * CI: V-25153102
 *
 * Triggers Definition
 * 
 **/ 

-- User Table Triggers 

-- Trigger before insert (encrypt password)
DELIMITER $$
CREATE TRIGGER trigger_before_insert_user
BEFORE INSERT ON User
FOR EACH ROW
BEGIN
    SET NEW.password_hash = SHA2(CONCAT(NEW.password_hash, 'my_secret_key'), 256);
END$$
DELIMITER ;

-- Trigger before update (encrypt password)
DELIMITER $$
CREATE TRIGGER trigger_before_update_user
BEFORE UPDATE ON User
FOR EACH ROW
BEGIN
    SET NEW.password_hash = SHA2(CONCAT(NEW.password_hash, 'my_secret_key'), 256);
END$$
DELIMITER ;