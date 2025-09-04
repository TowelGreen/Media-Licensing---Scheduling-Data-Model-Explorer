CREATE DATABASE media_scheduler;
-- Reset & Rebuild Media Scheduler Database
USE media_scheduler;

------------------------------------------------------
-- 0. Drop existing tables in reverse FK order
------------------------------------------------------
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS schedule;
DROP TABLE IF EXISTS license;
DROP TABLE IF EXISTS media;
DROP TABLE IF EXISTS content;
DROP TABLE IF EXISTS platform;
DROP TABLE IF EXISTS genre;
DROP TABLE IF EXISTS rating;
DROP TABLE IF EXISTS language;
SET FOREIGN_KEY_CHECKS = 1;

------------------------------------------------------
-- 1. Supporting Tables
------------------------------------------------------
CREATE TABLE genre (
    genre_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE rating (
    rating_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE language (
    language_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);

------------------------------------------------------
-- 2. Platform
------------------------------------------------------
CREATE TABLE platform (
    platform_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    region VARCHAR(50) NOT NULL
);

------------------------------------------------------
-- 3. Content
------------------------------------------------------
CREATE TABLE content (
    content_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL
);

------------------------------------------------------
-- 4. Media
------------------------------------------------------
CREATE TABLE media (
    media_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    duration_minutes INT,
    release_year INT,
    genre_id INT,
    rating_id INT,
    language_id INT,
    FOREIGN KEY (genre_id) REFERENCES genre(genre_id),
    FOREIGN KEY (rating_id) REFERENCES rating(rating_id),
    FOREIGN KEY (language_id) REFERENCES language(language_id)
);

------------------------------------------------------
-- 5. License
------------------------------------------------------
CREATE TABLE license (
    license_id INT PRIMARY KEY AUTO_INCREMENT,
    content_id INT NOT NULL,
    platform_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    exclusive BOOLEAN DEFAULT 0,
    FOREIGN KEY (content_id) REFERENCES content(content_id),
    FOREIGN KEY (platform_id) REFERENCES platform(platform_id)
);

------------------------------------------------------
-- 6. Schedule
------------------------------------------------------
CREATE TABLE schedule (
    schedule_id INT PRIMARY KEY AUTO_INCREMENT,
    media_id INT NOT NULL,
    platform_id INT NOT NULL,
    air_datetime DATETIME NOT NULL,
    duration_minutes INT,
    FOREIGN KEY (media_id) REFERENCES media(media_id),
    FOREIGN KEY (platform_id) REFERENCES platform(platform_id)
);

-- Reset & Rebuild Media Scheduler Database
USE media_scheduler;

-- Step 0: Clear existing data
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE schedule;
TRUNCATE license;
TRUNCATE media;
TRUNCATE content;
TRUNCATE platform;
TRUNCATE genre;
TRUNCATE rating;
TRUNCATE language;
SET FOREIGN_KEY_CHECKS = 1;

------------------------------------------------------
-- 1. Supporting Tables
------------------------------------------------------
INSERT INTO genre (name) VALUES
('Sci-Fi'), ('Historical'), ('Animation'), ('Drama'),
('Action'), ('Fantasy'), ('Thriller');

INSERT INTO rating (name) VALUES
('PG-13'), ('R'), ('PG'), ('G');

INSERT INTO language (name) VALUES
('English'), ('Korean'), ('Spanish');

------------------------------------------------------
-- 2. Platforms
------------------------------------------------------
INSERT INTO platform (name, region) VALUES
('Netflix', 'US'), ('Netflix', 'EU'),
('Disney+', 'US'), ('Disney+', 'LATAM'),
('HBO Max', 'US'), ('Prime Video', 'US'),
('BBC One', 'UK'),
('Hulu', 'US'),
('NOW TV', 'UK'),
('Canal+', 'FR');

------------------------------------------------------
-- 3. Content
------------------------------------------------------
INSERT INTO content (title) VALUES
('Inception'), ('Gladiator'), ('Toy Story'), ('Parasite'),
('The Matrix'), ('Frozen'), ('The Dark Knight'), ('Interstellar'),
('Avengers: Endgame'), ('Finding Nemo'), ('Avatar 3'),
('Quantum Rift'),
('Starlight Saga');

------------------------------------------------------
-- 4. Media
------------------------------------------------------
INSERT INTO media (title, duration_minutes, release_year, genre_id, rating_id, language_id) VALUES
('Inception', 148, 2010, 1, 1, 1),
('Gladiator', 155, 2000, 2, 2, 1),
('Toy Story', 81, 1995, 3, 3, 1),
('Parasite', 132, 2019, 4, 2, 2),
('The Matrix', 136, 1999, 1, 2, 1),
('Frozen', 102, 2013, 6, 3, 1),
('The Dark Knight', 152, 2008, 5, 1, 1),
('Interstellar', 169, 2014, 1, 1, 1),
('Avengers: Endgame', 181, 2019, 5, 1, 1),
('Finding Nemo', 100, 2003, 3, 3, 1),
('Avatar 3', 195, 2026, 1, 1, 1),
('Quantum Rift', 135, 2025, 1, 1, 1),
('Starlight Saga', 120, 2024, 6, 3, 1);

------------------------------------------------------
-- 5. Licenses
------------------------------------------------------
INSERT INTO license (content_id, platform_id, start_date, end_date, exclusive) VALUES
-- Original test cases
(1, 1, '2025-01-01', '2025-12-31', 0), -- Inception
(2, 5, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 20 DAY), 0), -- Gladiator expiring soon
(4, 1, '2025-01-01', '2025-12-31', 1), -- Parasite exclusive

-- Neutral entries
(5, 6, '2025-02-01', '2025-08-31', 0),
(6, 3, '2025-01-15', '2025-12-31', 0),
(7, 1, '2025-01-01', '2025-12-31', 0),
(8, 2, '2025-03-01', '2025-12-31', 0),
(9, 4, '2025-01-01', '2025-06-30', 0),
(10, 3, '2025-01-01', '2025-12-31', 0),

-- Avatar 3 multi-region license
(11, 1, '2025-08-01', '2026-08-01', 0), -- Netflix US
(11, 2, '2025-08-01', '2026-08-01', 0), -- Netflix EU
(11, 4, '2025-08-01', '2026-08-01', 0), -- Disney+ LATAM

-- Avengers: Endgame multi-region license
(9, 1, '2025-07-01', '2026-07-01', 0), -- Netflix US
(9, 2, '2025-07-10', '2026-07-10', 0), -- Netflix EU
(9, 4, '2025-07-20', '2026-07-20', 0), -- Disney+ LATAM

-- Quantum Rift multi-region license
(12, 8, '2025-09-01', '2026-09-01', 0), -- Hulu US
(12, 9, '2025-09-01', '2026-09-01', 0), -- NOW TV UK
(12, 10, '2025-09-02', '2026-09-02', 0), -- Canal+ FR

-- Starlight Saga overexposure license on Prime Video
(13, 6, '2025-08-01', '2026-08-01', 0);

------------------------------------------------------
-- 6. Schedules
------------------------------------------------------
INSERT INTO schedule (media_id, platform_id, air_datetime, duration_minutes) VALUES
-- Query 1: Overlaps
(1, 1, '2025-08-15 20:00:00', 120),
(1, 1, '2025-08-15 21:00:00', 120),
(1, 2, '2025-08-17 20:00:00', 120),

-- Query 2: License expiring soon
(2, 5, '2025-08-25 20:00:00', 150),

-- Query 3: Schedules without valid licenses
(3, 3, '2025-08-18 18:00:00', 90),

-- Query 4: License conflicts
(4, 1, '2025-08-20 20:00:00', 130),
(4, 3, '2025-08-21 20:00:00', 130),

-- Neutral
(5, 6, '2025-08-10 20:00:00', 140),
(6, 3, '2025-07-25 18:00:00', 100),
(7, 1, '2025-09-05 21:00:00', 150),
(8, 2, '2025-08-30 20:00:00', 165),
(9, 4, '2025-05-10 20:00:00', 180),
(10, 3, '2025-06-15 17:00:00', 95),

-- Query 5: Avatar 3 multi-region same-week (simultaneous)
(11, 1, '2025-08-05 20:00:00', 195), -- US
(11, 2, '2025-08-06 21:00:00', 195), -- EU
(11, 4, '2025-08-07 22:00:00', 195), -- LATAM

-- Query 5: Avengers: Endgame multi-region (staggered but within range)
(9, 1, '2025-07-01 20:00:00', 181), -- US
(9, 2, '2025-07-10 21:00:00', 181), -- EU
(9, 4, '2025-07-20 22:00:00', 181), -- LATAM

-- Test 1: Quantum Rift - Perfect Simultaneous Release (within 24 hours)
(12, 8, '2025-09-01 20:00:00', 135), -- Hulu US
(12, 9, '2025-09-01 22:00:00', 135), -- NOW TV UK
(12, 10, '2025-09-02 01:00:00', 135), -- Canal+ FR

-- Test 2: Starlight Saga - Overexposure
(13, 6, '2025-08-20 18:00:00', 120),
(13, 6, '2025-08-20 20:30:00', 120),
(13, 6, '2025-08-20 23:00:00', 120),

-- Test 3: Starlight Saga - Suspicious Gap
(13, 6, '2025-09-01 19:00:00', 120),
(13, 6, '2025-10-01 19:00:00', 120);