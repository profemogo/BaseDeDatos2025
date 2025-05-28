USE habit_tracker;


DELIMITER //
CREATE PROCEDURE LogActivityTransaction(
    IN p_habit_id INT,
    IN p_unit_id INT,
    IN p_value DECIMAL(10,2)
) 
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
   
    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    START TRANSACTION;
    
    
    INSERT INTO ActivityLog (habit_id, unit_id, value)
    VALUES (p_habit_id, p_unit_id, p_value);
    
    COMMIT;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GenerateMonthlyReport(
    IN p_user_id INT,
    IN p_month INT,
    IN p_year INT
)
BEGIN
    SELECT 
        h.name AS habit,
        u.name AS unit,
        SUM(al.value) AS total,
        ar.target_value,
        COUNT(CASE WHEN al.value >= ar.target_value THEN 1 END) AS success_days
    FROM Habit h
    LEFT JOIN ActivityLog al ON h.id = al.habit_id
    LEFT JOIN DailyLog dl ON al.daily_log_id = dl.id
    JOIN ActivityRule ar ON h.id = ar.habit_id
    JOIN Unit u ON ar.unit_id = u.id
    WHERE h.user_id = p_user_id
      AND MONTH(dl.date) = p_month
      AND YEAR(dl.date) = p_year
      AND ar.frequency_id IN (
          SELECT id FROM FrequencyType 
          WHERE name IN ('diaria', 'semanal', 'mensual')
      ) -- Cierre del IN
    GROUP BY h.id, ar.id;
END //
DELIMITER ;

