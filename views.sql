-- Vista de eventos favoritos por usuario con detalles

CREATE VIEW UserFavoriteEvents AS
SELECT
    u.full_name,
    e.event_name,
    e.datetime,
    v.name AS venue_name,
    e.category
FROM Favorite f
JOIN User u ON f.user_id = u.user_id
JOIN Event e ON f.event_id = e.event_id
JOIN Venue v ON e.venue_id = v.venue_id;
