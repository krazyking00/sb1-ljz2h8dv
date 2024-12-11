-- Insert sample streaming sources
INSERT INTO streaming_sources (name, base_url) VALUES 
('GoogleDrive', 'https://drive.google.com'),
('Mega', 'https://mega.nz'),
('OneDrive', 'https://onedrive.live.com');

-- Insert a sample movie
INSERT INTO media (title, media_type_id, release_year, description) VALUES 
('The Matrix', 1, 1999, 'A computer programmer discovers a mysterious world of digital reality.');

-- Insert a sample TV show
INSERT INTO media (title, media_type_id, release_year, description) VALUES 
('Breaking Bad', 2, 2008, 'A high school chemistry teacher turned crystal meth dealer.');

-- Insert sample season for Breaking Bad
INSERT INTO tv_seasons (media_id, season_number, title) VALUES 
((SELECT id FROM media WHERE title = 'Breaking Bad'), 1, 'Season 1');

-- Insert sample episodes
INSERT INTO tv_episodes (season_id, episode_number, title) VALUES 
((SELECT id FROM tv_seasons WHERE season_number = 1 LIMIT 1), 1, 'Pilot'),
((SELECT id FROM tv_seasons WHERE season_number = 1 LIMIT 1), 2, 'Cat\'s in the Bag...');

-- Insert sample stream links
INSERT INTO stream_links (media_id, source_id, url, quality, file_size, pastebin_id) VALUES 
((SELECT id FROM media WHERE title = 'The Matrix'), 
 (SELECT id FROM streaming_sources WHERE name = 'GoogleDrive'),
 'https://drive.google.com/sample-matrix-link',
 '1080p',
 '2.1GB',
 'abc123');

-- Insert sample stream link for TV episode
INSERT INTO stream_links (
    media_id, 
    episode_id, 
    source_id, 
    url, 
    quality, 
    file_size, 
    pastebin_id
) VALUES (
    (SELECT id FROM media WHERE title = 'Breaking Bad'),
    (SELECT id FROM tv_episodes WHERE episode_number = 1 LIMIT 1),
    (SELECT id FROM streaming_sources WHERE name = 'Mega'),
    'https://mega.nz/sample-breaking-bad-s01e01',
    '720p',
    '1.5GB',
    'xyz789'
);