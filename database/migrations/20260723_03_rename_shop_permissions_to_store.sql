-- Run this file against the user-service database.
-- Permission relationships use IDs, so they remain intact.
UPDATE `permissions`
SET permission_code = REPLACE(permission_code, 'x-shop:', 'x-store:'),
    permission_name = REPLACE(permission_name, 'Shop ', 'Store '),
    module_name = CASE WHEN module_name = 'SHOP' THEN 'STORE' ELSE module_name END
WHERE permission_code LIKE 'x-shop:%'
   OR module_name = 'SHOP';
