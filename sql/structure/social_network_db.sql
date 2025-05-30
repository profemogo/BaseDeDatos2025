-- Tables

-- Gender table (Defines available genders)
-- Relationships:
-- - Referenced by "User".
CREATE TABLE Gender (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
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
    name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE
);

-- ContentType (Defines content types for posts)
-- Relationships:
-- - Referenced by "PostContent".
CREATE TABLE ContentType (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
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
    FOREIGN KEY (content_type_id) REFERENCES ContentType(id) ON DELETE CASCADE,
    CONSTRAINT check_content_not_null CHECK (content IS NOT NULL OR media_url IS NOT NULL)
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
    type ENUM('individual','group') NOT NULL DEFAULT 'individual',
    CONSTRAINT check_group_name CHECK (type = 'individual' OR name IS NOT NULL)
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
    name VARCHAR(50) NOT NULL UNIQUE,
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