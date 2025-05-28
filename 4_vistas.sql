USE swimmingProject_v1;

DROP VIEW IF EXISTS vista_nadadores_por_club;

CREATE VIEW vista_nadadores_por_club AS
SELECT 
    c.nombre as nombre_club,
    c.ciudad as ciudad_club,
    COUNT(n.id) as total_nadadores,
    GROUP_CONCAT(
        CONCAT(n.nombre, ' ', n.apellidos, ' (', 
        TIMESTAMPDIFF(YEAR, n.fecha_nacimiento, CURDATE()), ' años)')
        ORDER BY n.apellidos, n.nombre
        SEPARATOR ', '
    ) as lista_nadadores
FROM 
    Club c
    LEFT JOIN Nadadores n ON c.id = n.club_id
GROUP BY 
    c.id, c.nombre, c.ciudad
ORDER BY 
    c.nombre;