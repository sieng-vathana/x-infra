-- Local: ONE database for all services.
CREATE DATABASE IF NOT EXISTS x_local CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'x_local'@'localhost' IDENTIFIED BY 'x';
CREATE USER IF NOT EXISTS 'x_local'@'127.0.0.1' IDENTIFIED BY 'x';

GRANT ALL PRIVILEGES ON x_local.* TO 'x_local'@'localhost', 'x_local'@'127.0.0.1';
FLUSH PRIVILEGES;
