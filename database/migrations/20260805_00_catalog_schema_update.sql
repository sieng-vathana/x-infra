-- ============================================================================
-- Migration: Add missing catalog columns (description, is_featured, is_global, created_at, updated_at)
-- Run this script against the MySQL database (x_prod / x_dev)
-- ============================================================================

-- 1. Update categories table
ALTER TABLE categories ADD COLUMN IF NOT EXISTS description TEXT NULL AFTER category_name;
ALTER TABLE categories ADD COLUMN IF NOT EXISTS is_featured BOOLEAN NOT NULL DEFAULT FALSE AFTER sort_order;
ALTER TABLE categories ADD COLUMN IF NOT EXISTS is_global BOOLEAN NOT NULL DEFAULT TRUE AFTER is_featured;
ALTER TABLE categories ADD COLUMN IF NOT EXISTS created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER status;
ALTER TABLE categories ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP AFTER created_at;

-- 2. Update units table
ALTER TABLE units ADD COLUMN IF NOT EXISTS description TEXT NULL AFTER unit_name;
ALTER TABLE units ADD COLUMN IF NOT EXISTS is_global BOOLEAN NOT NULL DEFAULT TRUE AFTER description;
ALTER TABLE units ADD COLUMN IF NOT EXISTS created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER status;
ALTER TABLE units ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP AFTER created_at;

-- 3. Update brands table
ALTER TABLE brands ADD COLUMN IF NOT EXISTS description TEXT NULL AFTER brand_name;
ALTER TABLE brands ADD COLUMN IF NOT EXISTS is_featured BOOLEAN NOT NULL DEFAULT FALSE AFTER logo;
ALTER TABLE brands ADD COLUMN IF NOT EXISTS is_global BOOLEAN NOT NULL DEFAULT TRUE AFTER is_featured;
ALTER TABLE brands ADD COLUMN IF NOT EXISTS created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER status;
ALTER TABLE brands ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP AFTER created_at;

-- 4. Update taxes table
ALTER TABLE taxes ADD COLUMN IF NOT EXISTS description TEXT NULL AFTER tax_name;
ALTER TABLE taxes ADD COLUMN IF NOT EXISTS is_default BOOLEAN NOT NULL DEFAULT FALSE AFTER percentage;
ALTER TABLE taxes ADD COLUMN IF NOT EXISTS is_global BOOLEAN NOT NULL DEFAULT TRUE AFTER is_default;
ALTER TABLE taxes ADD COLUMN IF NOT EXISTS created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER status;
ALTER TABLE taxes ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP AFTER created_at;
