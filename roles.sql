-- ¡Advertencia! Este script eliminará los roles si ya existen.

DROP ROLE IF EXISTS 'admin', 'event_manager', 'venue_manager', 'user_manager';

-- Crear roles
CREATE ROLE 'admin', 'event_manager', 'venue_manager', 'user_manager';

-- ADMIN: Acceso completo a toda la base de datos
GRANT ALL PRIVILEGES ON EventDB.* TO 'admin';

-- EVENT MANAGER: Control total sobre eventos y favoritos
GRANT SELECT, INSERT, UPDATE, DELETE ON EventDB.Event TO 'event_manager';
GRANT SELECT, INSERT, DELETE ON EventDB.Favorite TO 'event_manager';

-- VENUE MANAGER: Control sobre lugares (venues)
GRANT SELECT, INSERT, UPDATE, DELETE ON EventDB.Venue TO 'venue_manager';

-- USER MANAGER: Gestión de usuarios y roles
GRANT SELECT, INSERT, UPDATE ON EventDB.User TO 'user_manager';
GRANT SELECT ON EventDB.Role TO 'user_manager';