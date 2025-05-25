-- Gender table (Defines available genders)
-- Relationships:
-- - Referenced by "User".
CREATE TABLE Gender (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);

-- User table (Stores user information)
-- Relationships:
-- - Has a “gender_id” referencing “Gender”.
-- - Related to “Post”, “Comment”, "PostLike", "CommentLike", "UserChat", and "Message".
CREATE TABLE User (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    gender_id INT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (gender_id) REFERENCES Gender(id) ON DELETE SET NULL
);

-- PostType (Defines post types)
-- Relationships:
-- - Referenced by "Post".
CREATE TABLE PostType (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE
);

-- ContentType (Defines content types for posts)
-- Relationships:
-- - Referenced by "PostContent".
CREATE TABLE ContentType (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE
);

-- Post (Contains user posts)
-- Relationships:
-- - Has a user_id referencing "User".
-- - Has a post_type_id referencing "PostType".
-- - Related to "PostContent", "PostLike", and "Comment".
CREATE TABLE Post (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    post_type_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (post_type_id) REFERENCES PostType(id) ON DELETE CASCADE
);

-- PostContent (Stores actual post content (text, image, video, etc.))
-- Relationships:
-- - Has a post_id referencing "Post".
-- - Has a content_type_id referencing "ContentType".
CREATE TABLE PostContent (
    id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    content_type_id INT NOT NULL,
    content TEXT,
    media_url VARCHAR(255),
    order_index INT,
    FOREIGN KEY (post_id) REFERENCES Post(id) ON DELETE CASCADE,
    FOREIGN KEY (content_type_id) REFERENCES ContentType(id) ON DELETE CASCADE
);

-- PostLike (Tracks post likes)
-- Relationships:
-- - Composite unique key ("post_id", "user_id") to prevent duplicates.
CREATE TABLE PostLike (
    id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    liked_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY (post_id, user_id),
    FOREIGN KEY (post_id) REFERENCES Post(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE
);

-- Comment (Stores comments on posts)
-- Relationships:
-- - Has post_id and user_id referencing "Post" and "User".
-- - Related to "CommentLike".
CREATE TABLE Comment (
    id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    text TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (post_id) REFERENCES Post(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE
);

-- CommentLike (Tracks comment likes)
-- Relationships:
-- - Composite unique key ("comment_id", "user_id") to prevent duplicates.
CREATE TABLE CommentLike (
    id INT AUTO_INCREMENT PRIMARY KEY,
    comment_id INT NOT NULL,
    user_id INT NOT NULL,
    liked_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY (comment_id, user_id),
    FOREIGN KEY (comment_id) REFERENCES Comment(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE
);

-- Chat table (Defines conversations between users)
-- Relationships:
-- - Related to "UserChat" and "Message".
CREATE TABLE Chat (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    type ENUM('individual','group') NOT NULL DEFAULT 'individual'
);

-- UserChat (Many-to-many relationship between "User" and "Chat")
-- Relationships:
-- - Composite unique key ("chat_id", "user_id") to prevent duplicates.
CREATE TABLE UserChat (
    id INT AUTO_INCREMENT PRIMARY KEY,
    chat_id INT NOT NULL,
    user_id INT NOT NULL,
    joined_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY (chat_id, user_id),
    FOREIGN KEY (chat_id) REFERENCES Chat(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE
);

-- MessageType (Defines message content types)
-- Relationships:
-- - Referenced by "Message".
CREATE TABLE MessageType (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE
);

-- Message (Stores messages sent in chats)
-- Relationships:
-- - Has chat_id and user_id referencing "Chat" and "User".
-- - Has message_type_id referencing "MessageType".
CREATE TABLE Message (
    id INT AUTO_INCREMENT PRIMARY KEY,
    chat_id INT NOT NULL,
    user_id INT NOT NULL,
    message_type_id INT NOT NULL,
    content TEXT,
    media_url VARCHAR(255),
    sent_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('sent','delivered','read') DEFAULT 'sent',
    FOREIGN KEY (chat_id) REFERENCES Chat(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (message_type_id) REFERENCES MessageType(id) ON DELETE CASCADE
);

-- MessageReceptor (Tracks message delivery and read status per recipient)
-- Relationships:
-- - message_id references Message(id)
-- - user_id references User(id)
-- - Unique constraint: Prevents duplicate (message_id, user_id) pairs
CREATE TABLE MessageReceptor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    message_id INT NOT NULL,
    user_id INT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    read_at DATETIME NULL,
    delivered_at DATETIME NULL,
    FOREIGN KEY (message_id) REFERENCES Message(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE,
    UNIQUE KEY unique_message_recipient (message_id, user_id)
);

-- Indexes
CREATE INDEX idx_message_chat_sent ON Message(chat_id, sent_at);
CREATE INDEX idx_post_user_created ON Post(user_id, created_at);
CREATE INDEX idx_comment_post_created ON Comment(post_id, created_at);
CREATE INDEX idx_postcontent_post_order ON PostContent(post_id, order_index);
CREATE INDEX idx_messagereceptor_user_read ON MessageReceptor(user_id, is_read);
CREATE INDEX idx_user_username ON User(username);

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