-- Run this file against the shop-service database.
-- Rerunnable: it acts only while the old object names exist.
SET @has_shops := (SELECT COUNT(*) FROM information_schema.tables
                   WHERE table_schema = DATABASE() AND table_name = 'shops');
SET @has_stores := (SELECT COUNT(*) FROM information_schema.tables
                    WHERE table_schema = DATABASE() AND table_name = 'stores');
SET @sql := IF(@has_shops = 1 AND @has_stores = 0,
               'RENAME TABLE `shops` TO `stores`', 'SELECT 1');
PREPARE statement FROM @sql;
EXECUTE statement;
DEALLOCATE PREPARE statement;
