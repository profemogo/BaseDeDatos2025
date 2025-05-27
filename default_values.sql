-- Default Values

INSERT INTO Gender (name) VALUES ('male'), ('female'), ('other');

INSERT INTO PostType (name, description) VALUES
    ('text', 'text only post'),
    ('image', 'post with image'),
    ('video', 'post with video');

INSERT INTO ContentType (name, description) VALUES
    ('text', 'Text only'),
    ('image/jpg', 'image JPEG'),
    ('image/png', 'image PNG'),
    ('video/mp4', 'video MP4');

INSERT INTO MessageType (name) VALUES ('text'), ('image'), ('video'), ("gif"), ('sticker');