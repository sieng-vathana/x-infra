-- Run against the delivery-service database. It is not an order-service table.
CREATE TABLE IF NOT EXISTS delivery_quotes (
    id BIGINT NOT NULL AUTO_INCREMENT, store_id BIGINT NOT NULL, provider_type VARCHAR(32) NOT NULL,
    pickup_latitude DECIMAL(10,7) NOT NULL, pickup_longitude DECIMAL(10,7) NOT NULL,
    destination_latitude DECIMAL(10,7) NOT NULL, destination_longitude DECIMAL(10,7) NOT NULL,
    distance_km DECIMAL(10,2) NOT NULL, quoted_fee DECIMAL(12,2) NOT NULL, currency_code VARCHAR(3) NOT NULL,
    status VARCHAR(16) NOT NULL, expires_at DATETIME NOT NULL, created_at DATETIME NOT NULL,
    PRIMARY KEY (id), INDEX ix_delivery_quote_store_status (store_id, status)
);

CREATE TABLE IF NOT EXISTS deliveries (
    id BIGINT NOT NULL AUTO_INCREMENT, order_id BIGINT NOT NULL, store_id BIGINT NOT NULL, quote_id BIGINT NOT NULL,
    provider_type VARCHAR(32) NOT NULL, status VARCHAR(32) NOT NULL, tracking_number VARCHAR(80),
    rider_name VARCHAR(120), rider_phone VARCHAR(32), delivery_fee DECIMAL(12,2), courier_cost DECIMAL(12,2),
    cod_amount DECIMAL(12,2), remitted_amount DECIMAL(12,2), remitted_at DATETIME,
    failure_reason VARCHAR(500), created_at DATETIME NOT NULL, updated_at DATETIME NOT NULL,
    PRIMARY KEY (id), CONSTRAINT uk_delivery_order UNIQUE (order_id), CONSTRAINT uk_delivery_quote UNIQUE (quote_id), CONSTRAINT uk_delivery_tracking UNIQUE (tracking_number)
);
