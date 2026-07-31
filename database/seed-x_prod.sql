-- ============================================================================
-- X Platform — Create RBAC tables + seed data for x_prod
-- ============================================================================

-- 1. Tables (matches Hibernate schema from x-user-service)
CREATE TABLE IF NOT EXISTS permissions (
    id BIGINT NOT NULL AUTO_INCREMENT,
    description TEXT,
    module_name VARCHAR(255),
    permission_code VARCHAR(255),
    permission_name VARCHAR(255),
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS roles (
    id BIGINT NOT NULL AUTO_INCREMENT,
    business_id BIGINT,
    created_at DATETIME(6),
    description TEXT,
    is_system BIT(1),
    role_code VARCHAR(255),
    role_name VARCHAR(255),
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS role_permissions (
    id BIGINT NOT NULL AUTO_INCREMENT,
    permission_id BIGINT,
    role_id BIGINT,
    PRIMARY KEY (id),
    KEY FK_role_perms_perm (permission_id),
    KEY FK_role_perms_role (role_id),
    CONSTRAINT FK_role_perms_perm FOREIGN KEY (permission_id) REFERENCES permissions (id),
    CONSTRAINT FK_role_perms_role FOREIGN KEY (role_id) REFERENCES roles (id)
);

CREATE TABLE IF NOT EXISTS users (
    id BIGINT NOT NULL AUTO_INCREMENT,
    created_at DATETIME(6),
    email VARCHAR(255),
    failed_attempt INT,
    full_name VARCHAR(255),
    gender VARCHAR(255),
    is_locked BIT(1),
    last_login DATETIME(6),
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(255),
    pin_code VARCHAR(255),
    profile_image TEXT,
    status INT,
    updated_at DATETIME(6),
    username VARCHAR(255) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY UK_users_username (username)
);

CREATE TABLE IF NOT EXISTS store_members (
    id BIGINT NOT NULL AUTO_INCREMENT,
    created_at DATETIME(6),
    store_id BIGINT,
    role_id BIGINT,
    user_id BIGINT,
    PRIMARY KEY (id),
    KEY FK_sm_role (role_id),
    KEY FK_sm_user (user_id),
    CONSTRAINT FK_sm_role FOREIGN KEY (role_id) REFERENCES roles (id),
    CONSTRAINT FK_sm_user FOREIGN KEY (user_id) REFERENCES users (id)
);

-- 2. Permissions (39 codes)
INSERT IGNORE INTO permissions (permission_code, permission_name, module_name, description) VALUES
('x-user:read', 'User read', 'USER', 'Seeded RBAC'),
('x-user:create', 'User create', 'USER', 'Seeded RBAC'),
('x-user:update', 'User update', 'USER', 'Seeded RBAC'),
('x-user:delete', 'User delete', 'USER', 'Seeded RBAC'),
('x-business:read', 'Business read', 'BUSINESS', 'Seeded RBAC'),
('x-business:create', 'Business create', 'BUSINESS', 'Seeded RBAC'),
('x-business:update', 'Business update', 'BUSINESS', 'Seeded RBAC'),
('x-business:delete', 'Business delete', 'BUSINESS', 'Seeded RBAC'),
('x-store:read', 'Store read', 'STORE', 'Seeded RBAC'),
('x-store:create', 'Store create', 'STORE', 'Seeded RBAC'),
('x-store:update', 'Store update', 'STORE', 'Seeded RBAC'),
('x-store:delete', 'Store delete', 'STORE', 'Seeded RBAC'),
('x-customer:read', 'Customer read', 'CUSTOMER', 'Seeded RBAC'),
('x-customer:create', 'Customer create', 'CUSTOMER', 'Seeded RBAC'),
('x-customer:update', 'Customer update', 'CUSTOMER', 'Seeded RBAC'),
('x-customer:delete', 'Customer delete', 'CUSTOMER', 'Seeded RBAC'),
('x-product:read', 'Product read', 'PRODUCT', 'Seeded RBAC'),
('x-product:create', 'Product create', 'PRODUCT', 'Seeded RBAC'),
('x-product:update', 'Product update', 'PRODUCT', 'Seeded RBAC'),
('x-product:delete', 'Product delete', 'PRODUCT', 'Seeded RBAC'),
('x-inventory:read', 'Inventory read', 'INVENTORY', 'Seeded RBAC'),
('x-inventory:create', 'Inventory create', 'INVENTORY', 'Seeded RBAC'),
('x-inventory:update', 'Inventory update', 'INVENTORY', 'Seeded RBAC'),
('x-inventory:delete', 'Inventory delete', 'INVENTORY', 'Seeded RBAC'),
('x-inventory:stock-in', 'Inventory stock-in', 'INVENTORY', 'Seeded RBAC'),
('x-inventory:stock-out', 'Inventory stock-out', 'INVENTORY', 'Seeded RBAC'),
('x-inventory:reserve', 'Inventory reserve', 'INVENTORY', 'Seeded RBAC'),
('x-order:read', 'Order read', 'ORDER', 'Seeded RBAC'),
('x-order:create', 'Order create', 'ORDER', 'Seeded RBAC'),
('x-order:update', 'Order update', 'ORDER', 'Seeded RBAC'),
('x-order:delete', 'Order delete', 'ORDER', 'Seeded RBAC'),
('x-order:refund', 'Order refund', 'ORDER', 'Seeded RBAC'),
('x-order:cancel', 'Order cancel', 'ORDER', 'Seeded RBAC'),
('x-delivery:read', 'Delivery read', 'DELIVERY', 'Seeded RBAC'),
('x-delivery:create', 'Delivery create', 'DELIVERY', 'Seeded RBAC'),
('x-delivery:update', 'Delivery update', 'DELIVERY', 'Seeded RBAC'),
('x-delivery:delete', 'Delivery delete', 'DELIVERY', 'Seeded RBAC'),
('x-delivery:quote', 'Delivery quote', 'DELIVERY', 'Seeded RBAC'),
('x-delivery:remit', 'Delivery remit', 'DELIVERY', 'Seeded RBAC'),
('x-storage:read', 'Storage read', 'STORAGE', 'Seeded RBAC'),
('x-storage:create', 'Storage create', 'STORAGE', 'Seeded RBAC'),
('x-storage:update', 'Storage update', 'STORAGE', 'Seeded RBAC'),
('x-storage:delete', 'Storage delete', 'STORAGE', 'Seeded RBAC'),
('x-storage:upload', 'Storage upload', 'STORAGE', 'Seeded RBAC'),
('x-payment:read', 'Payment read', 'PAYMENT', 'Seeded RBAC'),
('x-payment:create', 'Payment create', 'PAYMENT', 'Seeded RBAC'),
('x-payment:update', 'Payment update', 'PAYMENT', 'Seeded RBAC'),
('x-payment:delete', 'Payment delete', 'PAYMENT', 'Seeded RBAC'),
('x-payment:capture', 'Payment capture', 'PAYMENT', 'Seeded RBAC'),
('x-payment:refund', 'Payment refund', 'PAYMENT', 'Seeded RBAC'),
('x-report:read', 'Report read', 'REPORT', 'Seeded RBAC'),
('x-bff:read', 'Bff read', 'BFF', 'Seeded RBAC');

-- 3. Roles (business_id=1, is_system=true)
INSERT IGNORE INTO roles (role_code, role_name, business_id, is_system, description) VALUES
('OWNER', 'Business Owner', 1, 1, 'Seeded RBAC'),
('MANAGER', 'Store Manager', 1, 1, 'Seeded RBAC'),
('CASHIER', 'Cashier', 1, 1, 'Seeded RBAC');

SET @owner_id  = (SELECT MIN(id) FROM roles WHERE role_code = 'OWNER');
SET @mgr_id    = (SELECT MIN(id) FROM roles WHERE role_code = 'MANAGER');
SET @cashier_id = (SELECT MIN(id) FROM roles WHERE role_code = 'CASHIER');

-- OWNER → ALL permissions
INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT @owner_id, id FROM permissions;

-- MANAGER → full product/inventory/order/store/customer/delivery/storage + read-only on business, user, payment, bff, report
INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT @mgr_id, id FROM permissions WHERE permission_code IN (
    'x-product:read','x-product:create','x-product:update','x-product:delete',
    'x-inventory:read','x-inventory:create','x-inventory:update','x-inventory:delete',
    'x-inventory:stock-in','x-inventory:stock-out','x-inventory:reserve',
    'x-order:read','x-order:create','x-order:update','x-order:delete',
    'x-order:refund','x-order:cancel',
    'x-store:read','x-store:create','x-store:update','x-store:delete',
    'x-customer:read','x-customer:create','x-customer:update','x-customer:delete',
    'x-delivery:read','x-delivery:create','x-delivery:update','x-delivery:delete',
    'x-delivery:quote','x-delivery:remit',
    'x-storage:read','x-storage:create','x-storage:update','x-storage:delete',
    'x-storage:upload',
    'x-report:read',
    'x-business:read',
    'x-user:read',
    'x-payment:read',
    'x-bff:read'
);

-- CASHIER → read catalog/store/business/storage + create+read orders + create+read payment (with capture)
INSERT IGNORE INTO role_permissions (role_id, permission_id)
SELECT @cashier_id, id FROM permissions WHERE permission_code IN (
    'x-product:read',
    'x-inventory:read',
    'x-order:read','x-order:create',
    'x-customer:read','x-customer:create',
    'x-payment:read','x-payment:create','x-payment:capture',
    'x-store:read',
    'x-business:read',
    'x-storage:read',
    'x-bff:read'
);

-- 4. Default admin user (password: Admin@123456)
INSERT IGNORE INTO users (username, password, full_name, email, status, is_locked, failed_attempt)
VALUES ('admin', '$2b$10$IeyR/9/m/9al8j3KtNIXeeA54r6oqw9HlMEGUBcK4kNzV7/iw7JBK', 'System Administrator', 'admin@x.local', 1, 0, 0);

SET @admin_id = (SELECT MIN(id) FROM users WHERE username = 'admin');

-- 5. Store membership (admin → store 101, OWNER)
INSERT IGNORE INTO store_members (user_id, store_id, role_id)
VALUES (@admin_id, 101, @owner_id);

SELECT 'x_prod seed completed' AS result;
