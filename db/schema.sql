-- Media Types Enum Table
CREATE TABLE media_types (
    id TINYINT UNSIGNED PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert basic media types
INSERT INTO media_types (id, type_name) VALUES 
(1, 'Movie'),
(2, 'TV Show');

-- Main Media Table
CREATE TABLE media (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    media_type_id TINYINT UNSIGNED NOT NULL,
    release_year YEAR,
    description TEXT,
    poster_url VARCHAR(512),
    imdb_id VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (media_type_id) REFERENCES media_types(id),
    INDEX idx_title (title),
    INDEX idx_release_year (release_year)
);

-- TV Show Seasons Table
CREATE TABLE tv_seasons (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    media_id BIGINT UNSIGNED NOT NULL,
    season_number INT UNSIGNED NOT NULL,
    title VARCHAR(255),
    air_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (media_id) REFERENCES media(id) ON DELETE CASCADE,
    UNIQUE KEY unique_season (media_id, season_number)
);

-- TV Show Episodes Table
CREATE TABLE tv_episodes (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    season_id BIGINT UNSIGNED NOT NULL,
    episode_number INT UNSIGNED NOT NULL,
    title VARCHAR(255),
    air_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (season_id) REFERENCES tv_seasons(id) ON DELETE CASCADE,
    UNIQUE KEY unique_episode (season_id, episode_number)
);

-- Streaming Sources Table
CREATE TABLE streaming_sources (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    base_url VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_name (name)
);

-- Stream Links Table
CREATE TABLE stream_links (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    media_id BIGINT UNSIGNED NOT NULL,
    episode_id BIGINT UNSIGNED,  -- NULL for movies
    source_id BIGINT UNSIGNED NOT NULL,
    url TEXT NOT NULL,
    quality VARCHAR(20),  -- e.g., '1080p', '720p', '4K'
    file_size VARCHAR(20), -- e.g., '2.1GB'
    is_working BOOLEAN DEFAULT TRUE,
    last_checked TIMESTAMP,
    pastebin_id VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (media_id) REFERENCES media(id) ON DELETE CASCADE,
    FOREIGN KEY (episode_id) REFERENCES tv_episodes(id) ON DELETE CASCADE,
    FOREIGN KEY (source_id) REFERENCES streaming_sources(id),
    INDEX idx_pastebin (pastebin_id),
    INDEX idx_working_status (is_working)
);

-- Link Validation History Table
CREATE TABLE link_validation_history (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    stream_link_id BIGINT UNSIGNED NOT NULL,
    checked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    was_working BOOLEAN NOT NULL,
    response_code INT,
    error_message TEXT,
    FOREIGN KEY (stream_link_id) REFERENCES stream_links(id) ON DELETE CASCADE,
    INDEX idx_checked_at (checked_at)
);