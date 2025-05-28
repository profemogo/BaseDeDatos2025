CREATE DATABASE IF NOT EXISTS habit_tracker;
USE habit_tracker;


CREATE TABLE User (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    password_hash CHAR(60) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    last_activity_date DATE
);

CREATE TABLE Email (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(100) UNIQUE NOT NULL,
    user_id INT NOT NULL,
    is_main BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE,
    UNIQUE INDEX idx_unique_main_email (user_id, is_main)
);

CREATE TABLE Habit (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    user_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE,
    UNIQUE (user_id, name)
);

CREATE TABLE DailyLog (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    date DATE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE,
    UNIQUE (user_id, date)
);


CREATE TABLE Unit (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE FrequencyType (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20) UNIQUE NOT NULL
);


CREATE TABLE ActivityRule (
    id INT PRIMARY KEY AUTO_INCREMENT,
    habit_id INT NOT NULL,
    target_value DECIMAL(10,2) NOT NULL,
    unit_id INT NOT NULL,
    frequency_id INT NOT NULL,
    target_days INT,
    FOREIGN KEY (habit_id) REFERENCES Habit(id),
    FOREIGN KEY (unit_id) REFERENCES Unit(id),
    FOREIGN KEY (frequency_id) REFERENCES FrequencyType(id),
    UNIQUE (habit_id, unit_id, frequency_id)
);


CREATE TABLE ActivityLog (
    id INT PRIMARY KEY AUTO_INCREMENT,
    daily_log_id INT NOT NULL,
    habit_id INT NOT NULL,
    unit_id INT NOT NULL,
    value DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (daily_log_id) REFERENCES DailyLog(id),
    FOREIGN KEY (habit_id) REFERENCES Habit(id),
    FOREIGN KEY (unit_id) REFERENCES Unit(id)
);

CREATE TABLE Achievement (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    activity_rule_id INT NOT NULL,
    earned_date DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (user_id) REFERENCES User(id),
    FOREIGN KEY (activity_rule_id) REFERENCES ActivityRule(id),
    UNIQUE (user_id, activity_rule_id)
);


CREATE INDEX idx_email_user ON Email(email);
CREATE INDEX idx_habit_user ON Habit(user_id);
CREATE INDEX idx_dailylog_user_date ON DailyLog(user_id, date);
CREATE INDEX idx_activityrule_habit_frequency ON ActivityRule(habit_id, frequency_id);
CREATE INDEX idx_activitylog_composite ON ActivityLog(daily_log_id, habit_id, unit_id);

CREATE INDEX idx_dailylog_date ON DailyLog(date);
CREATE INDEX idx_activitylog_value ON ActivityLog(value);