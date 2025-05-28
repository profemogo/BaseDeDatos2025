USE habit_tracker;


DELIMITER //
CREATE FUNCTION GetCurrentStreak(p_user_id INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE streak INT DEFAULT 0;
    
    WITH OrderedLogs AS (
        SELECT date,
               DATE_SUB(date, INTERVAL ROW_NUMBER() OVER (ORDER BY date) DAY) AS grp
        FROM DailyLog
        WHERE user_id = p_user_id
    )
    SELECT COUNT(*) INTO streak
    FROM OrderedLogs
    WHERE grp = (SELECT grp FROM OrderedLogs ORDER BY date DESC LIMIT 1);
    
    RETURN streak;
END //
DELIMITER ;


DELIMITER //
CREATE FUNCTION IsDailyGoalMet(p_user_id INT, p_habit_id INT) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    DECLARE target DECIMAL(10,2);
    
    SELECT 
        SUM(al.value), 
        MAX(ar.target_value) 
    INTO total, target
    FROM ActivityLog al
    JOIN DailyLog dl ON al.daily_log_id = dl.id
    JOIN ActivityRule ar ON al.habit_id = ar.habit_id
    WHERE dl.user_id = p_user_id
      AND al.habit_id = p_habit_id
      AND dl.date = CURDATE()
      AND ar.frequency_id = (SELECT id FROM FrequencyType WHERE name = 'diaria');
    
    RETURN IFNULL(total >= target, FALSE);
END //
DELIMITER ;
