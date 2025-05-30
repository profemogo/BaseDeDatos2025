-- Warning! executing this sql script will drop/delete the follow existing roles if already exist.

DROP ROLE IF EXISTS 'super_admin', 'content_manager', 'user_manager', 'moderator';

CREATE ROLE 'super_admin', 'content_manager', 'user_manager', 'moderator';

-- Super Administrator
GRANT ALL PRIVILEGES ON SocialNetworkDB.* TO 'super_admin';

-- Content Manager
GRANT SELECT, INSERT, UPDATE ON SocialNetworkDB.Post TO 'content_manager';
GRANT SELECT, INSERT, UPDATE ON SocialNetworkDB.PostContent TO 'content_manager';
GRANT SELECT, INSERT, UPDATE ON SocialNetworkDB.Comment TO 'content_manager';

GRANT SELECT, INSERT ON SocialNetworkDB.PostLike TO 'content_manager';
GRANT SELECT, INSERT ON SocialNetworkDB.CommentLike TO 'content_manager';

GRANT EXECUTE ON PROCEDURE SocialNetworkDB.DeactivateUser TO 'content_manager';

-- User Manager
GRANT SELECT, INSERT, UPDATE ON SocialNetworkDB.User TO 'user_manager';
GRANT SELECT, INSERT, UPDATE ON SocialNetworkDB.UserChat TO 'user_manager';

GRANT SELECT ON SocialNetworkDB.Gender TO 'user_manager';

GRANT EXECUTE ON PROCEDURE SocialNetworkDB.DeactivateUser TO 'user_manager';

-- Moderator
GRANT SELECT ON SocialNetworkDB.Post TO 'moderator';
GRANT SELECT ON SocialNetworkDB.PostContent TO 'moderator';
GRANT SELECT ON SocialNetworkDB.Comment TO 'moderator';
GRANT SELECT ON SocialNetworkDB.User TO 'moderator';

GRANT UPDATE (is_active) ON SocialNetworkDB.Post TO 'moderator';
GRANT UPDATE (is_active) ON SocialNetworkDB.Comment TO 'moderator';

GRANT EXECUTE ON PROCEDURE SocialNetworkDB.DeactivateUser TO 'moderator';