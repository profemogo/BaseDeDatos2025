USE habit_tracker;


CREATE OR REPLACE VIEW DailyProgress AS
SELECT 
    u.id AS user_id,
    h.name AS habit,
    dl.date,
    SUM(al.value) AS total,
    MAX(ar.target_value) AS target_value, 
    CASE WHEN SUM(al.value) >= MAX(ar.target_value) THEN TRUE ELSE FALSE END AS completed
FROM User u
JOIN Habit h ON u.id = h.user_id
JOIN ActivityLog al ON h.id = al.habit_id
JOIN DailyLog dl ON al.daily_log_id = dl.id
JOIN ActivityRule ar ON h.id = ar.habit_id 
    AND ar.frequency_id = (SELECT id FROM FrequencyType WHERE name = 'diaria')
GROUP BY u.id, h.id, dl.date; 


CREATE OR REPLACE VIEW UserAchievements AS
SELECT 
    a.user_id,
    h.name AS habit,
    ft.name AS frequency_type,
    COUNT(a.id) AS total_achievements
FROM Achievement a
JOIN ActivityRule ar ON a.activity_rule_id = ar.id
JOIN Habit h ON ar.habit_id = h.id
JOIN FrequencyType ft ON ar.frequency_id = ft.id
GROUP BY a.user_id, h.id, ft.name;
