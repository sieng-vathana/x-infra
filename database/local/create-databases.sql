CREATE DATABASE IF NOT EXISTS vyntra_user CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS vyntra_business CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS vyntra_shop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS vyntra_product CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS vyntra_order CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'vyntra_local'@'localhost' IDENTIFIED BY '';
CREATE USER IF NOT EXISTS 'vyntra_local'@'127.0.0.1' IDENTIFIED BY '';

GRANT ALL PRIVILEGES ON vyntra_user.* TO 'vyntra_local'@'localhost', 'vyntra_local'@'127.0.0.1';
GRANT ALL PRIVILEGES ON vyntra_business.* TO 'vyntra_local'@'localhost', 'vyntra_local'@'127.0.0.1';
GRANT ALL PRIVILEGES ON vyntra_shop.* TO 'vyntra_local'@'localhost', 'vyntra_local'@'127.0.0.1';
GRANT ALL PRIVILEGES ON vyntra_product.* TO 'vyntra_local'@'localhost', 'vyntra_local'@'127.0.0.1';
GRANT ALL PRIVILEGES ON vyntra_order.* TO 'vyntra_local'@'localhost', 'vyntra_local'@'127.0.0.1';

FLUSH PRIVILEGES;
