-- Run this file against the product-service database.
-- Rerunnable: it acts only while the old object names exist.
SET @has_shop_id := (SELECT COUNT(*) FROM information_schema.columns
                     WHERE table_schema = DATABASE() AND table_name = 'products' AND column_name = 'shop_id');
SET @has_store_id := (SELECT COUNT(*) FROM information_schema.columns
                      WHERE table_schema = DATABASE() AND table_name = 'products' AND column_name = 'store_id');
SET @sql := IF(@has_shop_id = 1 AND @has_store_id = 0,
               'ALTER TABLE `products` RENAME COLUMN `shop_id` TO `store_id`', 'SELECT 1');
PREPARE statement FROM @sql;
EXECUTE statement;
DEALLOCATE PREPARE statement;

SET @has_old_index := (SELECT COUNT(*) FROM information_schema.statistics
                       WHERE table_schema = DATABASE() AND table_name = 'products'
                         AND index_name = 'uk_product_shop_code');
SET @has_new_index := (SELECT COUNT(*) FROM information_schema.statistics
                       WHERE table_schema = DATABASE() AND table_name = 'products'
                         AND index_name = 'uk_product_store_code');
SET @sql := IF(@has_old_index = 1 AND @has_new_index = 0,
               'ALTER TABLE `products` RENAME INDEX `uk_product_shop_code` TO `uk_product_store_code`',
               'SELECT 1');
PREPARE statement FROM @sql;
EXECUTE statement;
DEALLOCATE PREPARE statement;
