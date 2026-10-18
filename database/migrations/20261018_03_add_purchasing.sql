-- Purchasing support for x-product-service and x-inventory-service.
-- The services use Hibernate ddl-auto=update in the current deployment, so Hibernate creates these objects
-- on deploy. Apply this migration only to databases managed by hand, after confirming the target schema.

ALTER TABLE suppliers
    ADD COLUMN contact_name VARCHAR(160) NULL,
    ADD COLUMN payment_terms VARCHAR(64) NULL;

CREATE TABLE IF NOT EXISTS purchase_orders (
    id BIGINT NOT NULL AUTO_INCREMENT,
    business_id BIGINT NOT NULL,
    store_id BIGINT NOT NULL,
    supplier_id BIGINT NOT NULL,
    supplier_name VARCHAR(160) NOT NULL,
    po_number VARCHAR(32) NULL,
    status VARCHAR(16) NOT NULL,
    currency_code VARCHAR(3) NOT NULL,
    order_date DATE NOT NULL,
    expected_date DATE NULL,
    note VARCHAR(500) NULL,
    created_by BIGINT NULL,
    ordered_at DATETIME(6) NULL,
    received_at DATETIME(6) NULL,
    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NULL,
    version BIGINT NULL,
    PRIMARY KEY (id),
    CONSTRAINT uk_purchase_order_po_number UNIQUE (po_number),
    INDEX idx_purchase_order_business_store (business_id, store_id)
);

CREATE TABLE IF NOT EXISTS purchase_order_lines (
    id BIGINT NOT NULL AUTO_INCREMENT,
    purchase_order_id BIGINT NOT NULL,
    variant_id BIGINT NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    variant_name VARCHAR(255) NULL,
    sku VARCHAR(100) NULL,
    qty_ordered BIGINT NOT NULL,
    qty_received BIGINT NOT NULL,
    unit_cost DECIMAL(12, 4) NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_purchase_order_lines_order
        FOREIGN KEY (purchase_order_id) REFERENCES purchase_orders (id)
);

CREATE TABLE IF NOT EXISTS supplier_returns (
    id BIGINT NOT NULL AUTO_INCREMENT,
    business_id BIGINT NOT NULL,
    store_id BIGINT NOT NULL,
    supplier_id BIGINT NOT NULL,
    supplier_name VARCHAR(160) NOT NULL,
    return_number VARCHAR(32) NULL,
    purchase_order_id BIGINT NULL,
    status VARCHAR(16) NOT NULL,
    currency_code VARCHAR(3) NOT NULL,
    reason VARCHAR(255) NOT NULL,
    note VARCHAR(500) NULL,
    created_by BIGINT NULL,
    completed_at DATETIME(6) NULL,
    created_at DATETIME(6) NOT NULL,
    version BIGINT NULL,
    PRIMARY KEY (id),
    CONSTRAINT uk_supplier_return_number UNIQUE (return_number),
    INDEX idx_supplier_return_business_store (business_id, store_id)
);

CREATE TABLE IF NOT EXISTS supplier_return_lines (
    id BIGINT NOT NULL AUTO_INCREMENT,
    supplier_return_id BIGINT NOT NULL,
    variant_id BIGINT NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    variant_name VARCHAR(255) NULL,
    sku VARCHAR(100) NULL,
    quantity BIGINT NOT NULL,
    unit_cost DECIMAL(12, 4) NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_supplier_return_lines_return
        FOREIGN KEY (supplier_return_id) REFERENCES supplier_returns (id)
);
