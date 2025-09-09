-- 1) Create database
CREATE DATABASE IF NOT EXISTS suretrust_project;
USE suretrust_project;

-- 2) Drop old objects (order matters due to FKs)
DROP EVENT IF EXISTS process_responses_hourly;
DROP PROCEDURE IF EXISTS process_responses;
DROP TABLE IF EXISTS processing_log;
DROP TABLE IF EXISTS form_responses;
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS meetings;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS form_responses_raw;  -- staging for CSV

-- 3) Core tables
CREATE TABLE users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(150) UNIQUE
);

CREATE TABLE meetings (
  meeting_id INT AUTO_INCREMENT PRIMARY KEY,
  meeting_name VARCHAR(100) NOT NULL,
  meeting_date DATE NOT NULL
);

CREATE TABLE attendance (
  attendance_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  meeting_id INT,
  join_time DATETIME,
  leave_time DATETIME,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (meeting_id) REFERENCES meetings(meeting_id)
);

CREATE TABLE form_responses (
  response_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  meeting_id INT,
  feedback TEXT,
  response_time DATETIME,
  is_processed TINYINT(1) DEFAULT 0,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (meeting_id) REFERENCES meetings(meeting_id)
);

CREATE TABLE processing_log (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  meeting_id INT,
  user_id INT,
  status ENUM('processed','error'),
  error_message VARCHAR(255),
  processed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4) STAGING TABLE for Google Sheet CSV (import here with the Wizard)
--    If your CSV headers are "Timestamp,Name,Email,Meeting ID,Feedback"
--    map them to these columns during import.
CREATE TABLE form_responses_raw (
  raw_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(150),
  meeting_id INT NULL,
  feedback VARCHAR(255),
  timestamp DATETIME
);

-- 5) (Optional) Sample data for quick testing
INSERT IGNORE INTO users (name, email) VALUES
('Rahul Sharma', 'rahul@example.com'),
('Priya Nair', 'priya@example.com'),
('Amit Kumar', 'amit@example.com');

INSERT IGNORE INTO meetings (meeting_name, meeting_date) VALUES
('Team Sync', '2025-08-20'),
('Project Review', '2025-08-22');

INSERT INTO attendance (user_id, meeting_id, join_time, leave_time) VALUES
(1, 1, NOW(), NOW()),
(3, 1, NOW(), NOW()),
(2, 2, NOW(), NOW());

INSERT INTO form_responses (user_id, meeting_id, feedback, response_time) VALUES
(1, 1, 'Great meeting', NOW()),
(2, 1, 'I missed the end', NOW()),
(2, 2, 'Good session overall', NOW()),
(3, 2, 'Interesting discussion', NOW());

-- 6) Stored procedure (single clean definition)
DELIMITER $$
CREATE PROCEDURE process_responses()
BEGIN
  DECLARE done INT DEFAULT 0;
  DECLARE v_response_id INT;
  DECLARE v_user_id INT;
  DECLARE v_meeting_id INT;

  DECLARE cur CURSOR FOR 
    SELECT response_id, user_id, meeting_id 
    FROM form_responses 
    WHERE is_processed = 0;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  OPEN cur;
  read_loop: LOOP
    FETCH cur INTO v_response_id, v_user_id, v_meeting_id;
    IF done THEN LEAVE read_loop; END IF;

    IF (SELECT COUNT(*) FROM attendance 
        WHERE user_id = v_user_id AND meeting_id = v_meeting_id) > 0 THEN
      UPDATE form_responses SET is_processed = 1 WHERE response_id = v_response_id;
      INSERT INTO processing_log (meeting_id, user_id, status, error_message) 
      VALUES (v_meeting_id, v_user_id, 'processed', NULL);
    ELSE
      INSERT INTO processing_log (meeting_id, user_id, status, error_message) 
      VALUES (v_meeting_id, v_user_id, 'error', 'No attendance record');
    END IF;
  END LOOP;
  CLOSE cur;
END$$
DELIMITER ;

-- 7) (Optional) Schedule it hourly (requires event_scheduler = ON)
SET GLOBAL event_scheduler = ON;
CREATE EVENT process_responses_hourly
ON SCHEDULE EVERY 1 HOUR
DO CALL process_responses();

SELECT * FROM form_responses_raw LIMIT 10;


INSERT INTO users (name, email)
SELECT r.name, r.email
FROM form_responses_raw r
LEFT JOIN users u ON u.email = r.email
WHERE u.user_id IS NULL;

INSERT INTO form_responses (user_id, meeting_id, feedback, response_time)
SELECT u.user_id, r.meeting_id, r.feedback, r.timestamp
FROM form_responses_raw r
JOIN users u ON u.email = r.email;

CALL process_responses();

SELECT * FROM form_responses ORDER BY response_id DESC;
SELECT * FROM processing_log ORDER BY processed_at DESC;
CALL process_responses();

SELECT * FROM form_responses ORDER BY response_id DESC;
SELECT * FROM processing_log ORDER BY processed_at DESC;

DROP TABLE IF EXISTS form_responses_raw2;
DROP TABLE IF EXISTS form_responses3;
DROP TABLE IF EXISTS form_responses5;

CREATE TABLE form_responses_raw (
  Name VARCHAR(100),
  Email VARCHAR(150),
  Feedback VARCHAR(255),
  Timestamp DATETIME
);

CREATE EVENT IF NOT EXISTS process_responses_event
ON SCHEDULE EVERY 1 HOUR
DO
  CALL process_responses();

INSERT INTO form_responses (user_id, meeting_id, feedback, response_time)
SELECT u.user_id, 1, r.Feedback, r.Timestamp
FROM form_responses_raw r
JOIN users u ON u.email = r.Email;

INSERT INTO attendance (user_id, meeting_id, join_time, leave_time)
VALUES
(2, 1, NOW(), NOW()),   -- Priya for meeting 1
(3, 2, NOW(), NOW());   -- Amit for meeting 2

CALL process_responses();
SELECT * FROM form_responses ORDER BY response_id DESC;
SELECT * FROM processing_log ORDER BY processed_at DESC;

TRUNCATE TABLE form_responses_raw;

SELECT meeting_id, COUNT(*) AS valid_responses
FROM form_responses
WHERE is_processed = 1
GROUP BY meeting_id;

SELECT meeting_id, COUNT(*) AS errors
FROM processing_log
WHERE status = 'error'
GROUP BY meeting_id;

SHOW TABLES;

SELECT * FROM users;
SELECT * FROM meetings;
SELECT * FROM attendance;

-- Check first 10 records from raw responses
SELECT * FROM form_responses_raw LIMIT 10;

CALL process_responses(); 

SELECT * FROM processing_log;
SELECT * FROM form_responses;

CALL process_responses();