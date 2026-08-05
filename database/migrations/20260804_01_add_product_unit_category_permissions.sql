-- Add product Unit and Category menu permissions and grant them to every role.
-- Safe to run repeatedly in x_dev and x_prod.

START TRANSACTION;

INSERT INTO permissions (permission_code, permission_name, module_name, description)
SELECT 'x-product:unit', 'Product unit', 'PRODUCT', 'Product Unit menu access'
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM permissions WHERE permission_code = 'x-product:unit'
);

INSERT INTO permissions (permission_code, permission_name, module_name, description)
SELECT 'x-product:category', 'Product category', 'PRODUCT', 'Product Category menu access'
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM permissions WHERE permission_code = 'x-product:category'
);

INSERT INTO role_permissions (role_id, permission_id)
SELECT roles.id, product_permissions.id
FROM roles
JOIN permissions AS product_permissions
  ON product_permissions.permission_code IN ('x-product:unit', 'x-product:category')
 AND product_permissions.id = (
     SELECT MIN(canonical_permission.id)
     FROM permissions AS canonical_permission
     WHERE canonical_permission.permission_code = product_permissions.permission_code
 )
WHERE NOT EXISTS (
    SELECT 1
    FROM role_permissions
    WHERE role_permissions.role_id = roles.id
      AND role_permissions.permission_id = product_permissions.id
);

COMMIT;
