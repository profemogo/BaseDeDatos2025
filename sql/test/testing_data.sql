-- Insert 10 test users
INSERT INTO User (name, username, email, gender_id) VALUES
('John Smith', 'johnsmith', 'john@example.com', 1),
('Emily Johnson', 'emilyj', 'emily@example.com', 2),
('Michael Brown', 'michaelb', 'michael@example.com', 1),
('Sarah Davis', 'sarahd', 'sarah@example.com', 2),
('David Wilson', 'davidw', 'david@example.com', 1),
('Jessica Garcia', 'jessicag', 'jessica@example.com', 2),
('Robert Martinez', 'robertm', 'robert@example.com', 1),
('Jennifer Anderson', 'jennifera', 'jennifer@example.com', 2),
('Thomas Taylor', 'thomast', 'thomas@example.com', 1),
('Elizabeth Thomas', 'elizabetht', 'elizabeth@example.com', 2);

-- Insert chats 5 test chats
INSERT INTO Chat (name, type) VALUES
(NULL, 'individual'), -- Chat 1: John and Emily
(NULL, 'individual'), -- Chat 2: Michael and Sarah
('Friends Group', 'group'), -- Chat 3: Group chat
(NULL, 'individual'), -- Chat 4: David and Jessica
('Work Team', 'group'); -- Chat 5: Work group

-- Assign users to chats
INSERT INTO UserChat (chat_id, user_id) VALUES
(1, 1), (1, 2), -- John and Emily
(2, 3), (2, 4), -- Michael and Sarah
(3, 1), (3, 2), (3, 3), (3, 4), -- Friends group
(4, 5), (4, 6), -- David and Jessica
(5, 7), (5, 8), (5, 9), (5, 10); -- Work team

-- Insert messages in chats
INSERT INTO Message (chat_id, user_id, message_type_id, content, media_url, status) VALUES
-- Chat 1 (John and Emily)
(1, 1, 1, 'Hi Emily, how are you?', NULL, 'read'),
(1, 2, 1, 'Hi John, I''m good thanks. You?', NULL, 'read'),
(1, 1, 1, 'Doing well, thanks. Want to meet tomorrow?', NULL, 'delivered'),

-- Chat 2 (Michael and Sarah)
(2, 3, 1, 'Sarah, did you see the latest email?', NULL, 'read'),
(2, 4, 1, 'Yes, I''m reviewing it now', NULL, 'read'),
(2, 3, 1, 'Please send me a picture of it', NULL, 'read'),
(2, 4, 2, NULL, 'https://example.com/photos/screenshot.png', 'sent'),
(2, 4, 1, 'Please let me know if everything is ok.', NULL, 'sent'),

-- Chat 3 (Friends group)
(3, 1, 1, 'Guys, want to go to the movies this weekend?', NULL, 'read'),
(3, 3, 1, 'Great idea! What movie?', NULL, 'read'),
(3, 2, 1, 'Sounds good to me', NULL, 'delivered'),

-- Chat 5 (Work team)
(5, 7, 1, 'Reminder: meeting tomorrow at 10am', NULL, 'read'),
(5, 8, 1, 'Thanks for the reminder', NULL, 'read'),
(5, 10, 1, 'I''ll bring the prepared report', NULL, 'delivered');

-- Insert message recipients
INSERT INTO MessageReceptor (message_id, user_id, is_read, read_at, delivered_at) VALUES
-- Chat 1
(1, 2, 1, NOW(), NOW()),
(2, 1, 1, NOW(), NOW()),
(3, 2, 0, NULL, NOW()),

-- Chat 2
(4, 4, 1, NOW(), NOW()),
(5, 3, 1, NOW(), NOW()),
(6, 4, 1, NOW(), NOW()),
(7, 3, 0, NULL, NULL),
(8, 3, 0, NULL, NULL),

-- Chat 3
(9, 2, 1, NOW(), NOW()),
(9, 3, 1, NOW(), NOW()),
(9, 4, 1, NOW(), NOW()),
(10, 1, 1, NOW(), NOW()),
(10, 2, 1, NOW(), NOW()),
(10, 4, 1, NOW(), NOW()),
(11, 1, 0, NULL, NOW()),
(11, 3, 0, NULL, NOW()),
(11, 4, 0, NULL, NOW()),

-- Chat 5
(12, 8, 1, NOW(), NOW()),
(12, 9, 1, NOW(), NOW()),
(12, 10, 1, NOW(), NOW()),
(13, 7, 1, NOW(), NOW()),
(13, 9, 1, NOW(), NOW()),
(13, 10, 1, NOW(), NOW()),
(14, 7, 0, NULL, NOW()),
(14, 8, 0, NULL, NOW()),
(14, 9, 0, NULL, NOW());

-- Insert posts
INSERT INTO Post (user_id, post_type_id) VALUES
(1, 1), -- John's text post
(2, 2), -- Emily's photo post
(3, 1), -- Michael's text post
(4, 3), -- Sarah's video post
(5, 1), -- David's text post
(2, 1), -- Another post from Emily
(7, 2), -- Robert's photo post
(9, 1), -- Thomas's text post
(10, 3); -- Elizabeth's video post

-- Insert post content
INSERT INTO PostContent (post_id, content_type_id, content, media_url, order_index) VALUES
-- Post 1 (text)
(1, 1, 'Today is a great day. Happy Friday everyone!', NULL, 1),

-- Post 2 (photo)
(2, 2, NULL, 'https://example.com/photos/emily/beach.jpg', 1),
(2, 1, 'On vacation at the beach 🏖️', NULL, 2),

-- Post 3 (text)
(3, 1, 'Just finished my new project. Really happy with the results!', NULL, 1),

-- Post 4 (video)
(4, 4, NULL, 'https://example.com/videos/sarah/tutorial.mp4', 1),
(4, 1, 'Here''s my new cooking tutorial', NULL, 2),

-- Post 5 (text)
(5, 1, 'Can anyone recommend a good book?', NULL, 1),

-- Post 6 (text)
(6, 1, 'Thought of the day: Patience is bitter, but its fruit is sweet.', NULL, 1),

-- Post 7 (photo)
(7, 3, NULL, 'https://example.com/photos/robert/concert.png', 1),
(7, 1, 'At last night''s concert. It was amazing!', NULL, 2),

-- Post 8 (text)
(8, 1, 'Happy to announce I''m starting a new job next week.', NULL, 1),

-- Post 9 (video)
(9, 4, NULL, 'https://example.com/videos/elizabeth/workout.mp4', 1),
(9, 1, 'My morning workout routine', NULL, 2);

-- Insert comments
INSERT INTO Comment (post_id, user_id, text) VALUES
(1, 2, 'Happy Friday to you too!'),
(1, 3, 'Enjoy the weekend'),
(2, 1, 'So jealous! Enjoy your vacation'),
(3, 4, 'Tell us more about your project'),
(5, 6, 'I recommend "One Hundred Years of Solitude"'),
(5, 7, '"The Little Prince" is a classic that never fails'),
(8, 2, 'Congratulations on the new job!'),
(8, 5, 'Which company?'),
(9, 3, 'Great workout routine!');

-- Insert post likes
INSERT INTO PostLike (post_id, user_id) VALUES
(1, 2), (1, 3), (1, 4),
(2, 1), (2, 5), (2, 6), (2, 7),
(3, 4), (3, 5),
(4, 1), (4, 2), (4, 3),
(5, 6), (5, 7), (5, 8),
(7, 2), (7, 3), (7, 4), (7, 5),
(8, 1), (8, 2), (8, 3), (8, 4), (8, 5),
(9, 1), (9, 2);

-- Insert comment likes
INSERT INTO CommentLike (comment_id, user_id) VALUES
(1, 3), (1, 4),
(2, 1),
(3, 2), (3, 4),
(4, 3),
(6, 1), (6, 2), (6, 3),
(7, 4), (7, 5),
(8, 1);