-- Migration: Add description, is_featured, is_global, created_at, updated_at to categories table

ALTER TABLE categories ADD COLUMN IF NOT EXISTS description TEXT NULL AFTER category_name;
ALTER TABLE categories ADD COLUMN IF NOT EXISTS is_featured BOOLEAN NOT NULL DEFAULT FALSE AFTER sort_order;
ALTER TABLE categories ADD COLUMN IF NOT EXISTS is_global BOOLEAN NOT NULL DEFAULT TRUE AFTER is_featured;
ALTER TABLE categories ADD COLUMN IF NOT EXISTS created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER status;
ALTER TABLE categories ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP AFTER created_at;
