-- Administrator
CREATE USER IF NOT EXISTS 'admin'@'localhost' IDENTIFIED BY 'admin';
GRANT 'super_admin' TO 'admin'@'localhost';
SET DEFAULT ROLE 'super_admin' TO 'admin'@'localhost';

-- Content Manager
CREATE USER IF NOT EXISTS 'content_manager'@'localhost' IDENTIFIED BY 'content';
GRANT 'content_manager' TO 'content_manager'@'localhost';
SET DEFAULT ROLE 'content_manager' TO 'content_manager'@'localhost';

-- User Manager
CREATE USER IF NOT EXISTS 'user_manager'@'localhost' IDENTIFIED BY 'user';
GRANT 'user_manager' TO 'user_manager'@'localhost';
SET DEFAULT ROLE 'user_manager' TO 'user_manager'@'localhost';

-- Moderator
CREATE USER IF NOT EXISTS 'moderator'@'localhost' IDENTIFIED BY 'moderator';
GRANT 'moderator' TO 'moderator'@'localhost';
SET DEFAULT ROLE 'moderator' TO 'moderator'@'localhost';