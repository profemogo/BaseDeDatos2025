USE habit_tracker;

DELIMITER $$


CREATE TRIGGER trg_create_dailylog_before_activity
BEFORE INSERT ON ActivityLog
FOR EACH ROW
BEGIN
    
    IF NOT EXISTS (
        SELECT 1 FROM DailyLog 
        WHERE user_id = (SELECT user_id FROM Habit WHERE id = NEW.habit_id)
        AND date = CURRENT_DATE()
    ) THEN
        
        INSERT INTO DailyLog (user_id, date)
        VALUES (
            (SELECT user_id FROM Habit WHERE id = NEW.habit_id),
            CURRENT_DATE()
        );
    END IF;

    
    SET NEW.daily_log_id = (
        SELECT id FROM DailyLog 
        WHERE user_id = (SELECT user_id FROM Habit WHERE id = NEW.habit_id)
        AND date = CURRENT_DATE()
    );
END$$


CREATE TRIGGER trg_update_last_activity
AFTER INSERT ON ActivityLog
FOR EACH ROW
BEGIN
    UPDATE User
    SET last_activity_date = CURRENT_DATE()
    WHERE id = (SELECT user_id FROM Habit WHERE id = NEW.habit_id);
END$$


CREATE TRIGGER trg_grant_daily_achievement
AFTER INSERT ON ActivityLog
FOR EACH ROW
BEGIN
    DECLARE v_total DECIMAL(10,2);
    DECLARE v_target DECIMAL(10,2);
    DECLARE v_rule_id INT;

    
    SELECT ar.id, ar.target_value 
    INTO v_rule_id, v_target
    FROM ActivityRule ar
    WHERE ar.habit_id = NEW.habit_id
        AND ar.unit_id = NEW.unit_id
        AND ar.frequency_id = (SELECT id FROM FrequencyType WHERE name = 'diaria');

    
    SELECT SUM(value) INTO v_total
    FROM ActivityLog
    WHERE daily_log_id = NEW.daily_log_id
        AND habit_id = NEW.habit_id
        AND unit_id = NEW.unit_id;

   
    IF v_total >= v_target THEN
        INSERT IGNORE INTO Achievement (user_id, activity_rule_id)
        VALUES (
            (SELECT user_id FROM Habit WHERE id = NEW.habit_id),
            v_rule_id
        );
    END IF;
END$$


CREATE TRIGGER trg_grant_streak_achievement
AFTER INSERT ON DailyLog
FOR EACH ROW
BEGIN
    DECLARE v_streak INT;
    DECLARE v_rule_id INT;

   
    WITH streak_cte AS (
        SELECT date, 
               DATE_SUB(date, INTERVAL ROW_NUMBER() OVER (ORDER BY date) DAY) AS grp
        FROM DailyLog 
        WHERE user_id = NEW.user_id
          AND date <= NEW.date
    )
    SELECT COUNT(*) INTO v_streak
    FROM streak_cte
    WHERE grp = (
        SELECT grp 
        FROM streak_cte 
        WHERE date = NEW.date
    );

    
    SELECT ar.id INTO v_rule_id
    FROM ActivityRule ar
    JOIN Habit h ON ar.habit_id = h.id
    WHERE h.user_id = NEW.user_id
      AND ar.frequency_id = (SELECT id FROM FrequencyType WHERE name = 'racha')
      AND v_streak >= ar.target_days
    LIMIT 1;

    
    IF v_rule_id IS NOT NULL THEN
        INSERT IGNORE INTO Achievement (user_id, activity_rule_id)
        VALUES (NEW.user_id, v_rule_id);
    END IF;
END$$

DELIMITER ;