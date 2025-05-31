USE habit_tracker;

CREATE USER IF NOT EXISTS 'habit_user'@'localhost' IDENTIFIED BY 'base_datos_25';


GRANT ALL PRIVILEGES ON habit_tracker.* TO 'habit_user'@'localhost';
FLUSH PRIVILEGES;