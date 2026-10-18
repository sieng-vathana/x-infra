-- Loyalty points by phone number (x-customer-service) and the points each order redeems or earns (x-order-service).
-- Hibernate creates these tables and columns on deploy (ddl-auto: update); this script is for databases managed by hand.
-- The LOYALTY value of order_discounts.method and order_item_discounts.method is added by the order service's own
-- Flyway migration V1__allow_loyalty_discount_method, which runs on its startup.
ALTER TABLE customers
    ADD COLUMN phone_normalized VARCHAR(40) NULL,
    ADD COLUMN loyalty_points BIGINT NOT NULL DEFAULT 0;

CREATE TABLE IF NOT EXISTS loyalty_programs (
    business_id BIGINT NOT NULL,
    enabled BIT(1) NOT NULL,
    member_discount_percent DECIMAL(5, 2) NOT NULL,
    min_redeem_points BIGINT NOT NULL,
    point_value_usd DECIMAL(10, 4) NOT NULL,
    points_per_usd DECIMAL(10, 2) NOT NULL,
    updated_at DATETIME(6) NULL,
    PRIMARY KEY (business_id)
);

CREATE TABLE IF NOT EXISTS loyalty_transactions (
    id BIGINT NOT NULL AUTO_INCREMENT,
    balance_after BIGINT NOT NULL,
    business_id BIGINT NOT NULL,
    created_at DATETIME(6) NOT NULL,
    customer_id BIGINT NOT NULL,
    order_id BIGINT NULL,
    order_no VARCHAR(64) NULL,
    points BIGINT NOT NULL,
    type ENUM('EARN', 'REDEEM') NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_loyalty_order_type (order_id, type),
    KEY idx_loyalty_customer_created (customer_id, created_at)
);

ALTER TABLE orders
    ADD COLUMN loyalty_points_redeemed BIGINT NOT NULL DEFAULT 0,
    ADD COLUMN loyalty_points_earned BIGINT NULL;
