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

DELIMITER //
CREATE PROCEDURE GetUserStats(IN p_user_id INT)
BEGIN
    SELECT
        u.id,
        u.username,
        u.name,
        u.is_active,
        (SELECT COUNT(*) FROM Post WHERE user_id = p_user_id AND is_active = TRUE) AS post_count,
        (SELECT COUNT(*) FROM Comment WHERE user_id = p_user_id AND is_active = TRUE) AS comment_count,
        (SELECT COUNT(*) FROM PostLike WHERE user_id = p_user_id) AS likes_given,
        (SELECT COUNT(*) FROM PostLike WHERE post_id IN (SELECT id FROM Post WHERE user_id = p_user_id)) AS likes_received,
        (SELECT COUNT(*) FROM Message WHERE user_id = p_user_id) AS messages_sent,
        (SELECT COUNT(*) FROM MessageReceptor WHERE user_id = p_user_id AND is_read = FALSE) AS unread_messages
    FROM
        User u
    WHERE
        u.id = p_user_id;
END //
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