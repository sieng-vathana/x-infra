-- Run this file after 20260723_01 against the shop-service database.
-- It is separate because some MySQL versions do not refresh index metadata
-- until after the table-rename statement completes.
SET @has_old_index := (SELECT COUNT(*) FROM information_schema.statistics
                       WHERE table_schema = DATABASE() AND table_name = 'stores'
                         AND index_name = 'uk_shop_business_code');
SET @has_new_index := (SELECT COUNT(*) FROM information_schema.statistics
                       WHERE table_schema = DATABASE() AND table_name = 'stores'
                         AND index_name = 'uk_store_business_code');
SET @sql := IF(@has_old_index = 1 AND @has_new_index = 0,
               'ALTER TABLE `stores` RENAME INDEX `uk_shop_business_code` TO `uk_store_business_code`',
               'SELECT 1');
PREPARE statement FROM @sql;
EXECUTE statement;
DEALLOCATE PREPARE statement;
