USE mysql;

CREATE USER IF NOT EXISTS 'habit_user'@'localhost' IDENTIFIED BY 'base_datos_25';


GRANT ALL PRIVILEGES ON habit_tracker_v2.* TO 'habit_user'@'localhost';
FLUSH PRIVILEGES;