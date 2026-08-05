-- Migration: Seed x-product:brand and x-product:tax permissions into permissions and role_permissions tables

INSERT INTO permissions (permission_code, permission_name, module_name, description)
SELECT 'x-product:brand', 'Product brand', 'PRODUCT', 'Product Brand menu access'
WHERE NOT EXISTS (
    SELECT 1 FROM permissions WHERE permission_code = 'x-product:brand'
);

INSERT INTO permissions (permission_code, permission_name, module_name, description)
SELECT 'x-product:tax', 'Product tax', 'PRODUCT', 'Product Tax menu access'
WHERE NOT EXISTS (
    SELECT 1 FROM permissions WHERE permission_code = 'x-product:tax'
);

-- Grant x-product:brand and x-product:tax permissions to OWNER, MANAGER, CASHIER system roles
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
CROSS JOIN permissions p
WHERE r.role_code IN ('OWNER', 'MANAGER', 'CASHIER')
  AND p.permission_code IN ('x-product:brand', 'x-product:tax')
  AND NOT EXISTS (
      SELECT 1 FROM role_permissions rp WHERE rp.role_id = r.id AND rp.permission_id = p.id
  );
