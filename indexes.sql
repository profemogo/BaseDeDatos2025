CREATE INDEX idx_event_datetime ON Event(datetime);
CREATE INDEX idx_event_category ON Event(category);
CREATE INDEX idx_event_venue_id ON Event(venue_id);

CREATE INDEX idx_user_email ON User(email);
CREATE INDEX idx_favorite_user_id ON Favorite(user_id);
CREATE INDEX idx_favorite_event_id ON Favorite(event_id);