-- Views

CREATE VIEW ViewPostsDetailed AS
SELECT
    p.id AS post_id,
    p.created_at AS post_date,
    u.id AS user_id,
    u.username,
    u.name AS user_name,
    g.name AS gender,
    pt.name AS post_type,
    (SELECT COUNT(*) FROM PostLike pl WHERE pl.post_id = p.id) AS like_count,
    (SELECT COUNT(*) FROM Comment c WHERE c.post_id = p.id AND c.is_active = TRUE) AS comment_count,
    pc.content,
    pc.media_url,
    ct.name AS content_type
FROM
    Post p
    JOIN User u ON p.user_id = u.id
    JOIN Gender g ON u.gender_id = g.id
    JOIN PostType pt ON p.post_type_id = pt.id
    JOIN PostContent pc ON p.id = pc.post_id
    JOIN ContentType ct ON pc.content_type_id = ct.id
WHERE
    p.is_active = TRUE
ORDER BY
    p.created_at DESC;