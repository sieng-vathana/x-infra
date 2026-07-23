-- Run against the inventory-service database. Do not run automatically in production.
CREATE TABLE IF NOT EXISTS stock_balances (
    id BIGINT NOT NULL AUTO_INCREMENT,
    store_id BIGINT NOT NULL,
    variant_id BIGINT NOT NULL,
    quantity_on_hand BIGINT NOT NULL DEFAULT 0,
    quantity_reserved BIGINT NOT NULL DEFAULT 0,
    version BIGINT,
    PRIMARY KEY (id),
    CONSTRAINT uk_stock_balance_store_variant UNIQUE (store_id, variant_id)
);

CREATE TABLE IF NOT EXISTS inventory_movements (
    id BIGINT NOT NULL AUTO_INCREMENT,
    store_id BIGINT NOT NULL,
    variant_id BIGINT NOT NULL,
    movement_type VARCHAR(32) NOT NULL,
    quantity_delta BIGINT NOT NULL,
    reference_type VARCHAR(40),
    reference_id VARCHAR(80),
    performed_by BIGINT,
    note VARCHAR(500),
    created_at DATETIME NOT NULL,
    PRIMARY KEY (id),
    INDEX ix_inventory_movement_store_variant (store_id, variant_id)
);

CREATE TABLE IF NOT EXISTS stock_reservations (
    id BIGINT NOT NULL AUTO_INCREMENT,
    store_id BIGINT NOT NULL,
    variant_id BIGINT NOT NULL,
    order_id BIGINT NOT NULL,
    quantity BIGINT NOT NULL,
    status VARCHAR(16) NOT NULL,
    expires_at DATETIME NOT NULL,
    PRIMARY KEY (id),
    INDEX ix_stock_reservation_order (order_id),
    INDEX ix_stock_reservation_expiry (status, expires_at)
);
