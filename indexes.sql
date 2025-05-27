-- Indexes

CREATE INDEX idx_message_chat_sent ON Message(chat_id, sent_at);
CREATE INDEX idx_post_user_created ON Post(user_id, created_at);
CREATE INDEX idx_comment_post_created ON Comment(post_id, created_at);
CREATE INDEX idx_postcontent_post_order ON PostContent(post_id, order_index);
CREATE INDEX idx_messagereceptor_user_read ON MessageReceptor(user_id, is_read);
CREATE INDEX idx_user_username ON User(username);
CREATE INDEX idx_message_status ON Message(status);