-- Triggers

DELIMITER //
CREATE TRIGGER validate_chat_participant
BEFORE INSERT ON MessageReceptor
FOR EACH ROW
BEGIN
    DECLARE is_participant INT;

    SELECT COUNT(*) INTO is_participant
    FROM UserChat uc
    JOIN Message m ON uc.chat_id = m.chat_id
    WHERE uc.user_id = NEW.user_id
    AND m.id = NEW.message_id;

    IF is_participant = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The user is not a chat participant';
    END IF;
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER update_message_status
BEFORE UPDATE ON MessageReceptor
FOR EACH ROW
BEGIN
    IF NEW.is_read = TRUE AND OLD.is_read = FALSE THEN
        SET NEW.read_at = NOW();
    END IF;

    IF NEW.delivered_at IS NOT NULL AND OLD.delivered_at IS NULL THEN
        SET NEW.delivered_at = NOW();
    END IF;
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER soft_delete_user
BEFORE UPDATE ON User
FOR EACH ROW
BEGIN
    IF NEW.is_active = FALSE AND OLD.is_active = TRUE THEN
        UPDATE Post SET is_active = FALSE WHERE user_id = NEW.id;
        UPDATE Comment SET is_active = FALSE WHERE user_id = NEW.id;
    END IF;
END//
DELIMITER ;