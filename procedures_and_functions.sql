-- Procedure using transaction

DELIMITER //
CREATE PROCEDURE DeactivateUser(IN p_user_id INT)
BEGIN

    DECLARE has_error BOOLEAN DEFAULT FALSE;

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        SET has_error = TRUE;
    END;

    START TRANSACTION;

    UPDATE User SET is_active = FALSE WHERE id = p_user_id;

    UPDATE Post SET is_active = FALSE WHERE user_id = p_user_id;

    UPDATE Comment SET is_active = FALSE WHERE user_id = p_user_id;

    DELETE FROM PostLike WHERE user_id = p_user_id;
    DELETE FROM CommentLike WHERE user_id = p_user_id;

    IF has_error THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error deactivating user';
    ELSE
        COMMIT;
    END IF;
END//
DELIMITER ;

-- Functions

DELIMITER //
CREATE FUNCTION UnreadMessagesCount(chat_id INT, user_id INT) RETURNS INT
READS SQL DATA
BEGIN
    DECLARE unread_count INT DEFAULT 0;

    SELECT COUNT(*) INTO unread_count
    FROM MessageReceptor mr
    JOIN Message m ON mr.message_id = m.id
    WHERE m.chat_id = chat_id
    AND mr.user_id = user_id
    AND mr.is_read = FALSE;

    RETURN unread_count;
END//
DELIMITER ;