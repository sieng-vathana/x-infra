-- For databases managed without Hibernate ddl-auto=update, run this before deploying the expiry-aware service.
-- Normal deployment creates the schema through Hibernate and backfills existing balances at service startup.
-- Existing aggregate stock is preserved as an undated opening lot so current balances remain unchanged.

CREATE TABLE IF NOT EXISTS inventory_batches (
    id BIGINT NOT NULL AUTO_INCREMENT,
    store_id BIGINT NOT NULL,
    variant_id BIGINT NOT NULL,
    batch_code VARCHAR(100),
    expiry_date DATE,
    source_type VARCHAR(40) NOT NULL,
    source_reference VARCHAR(100),
    quantity_received BIGINT NOT NULL DEFAULT 0,
    quantity_on_hand BIGINT NOT NULL DEFAULT 0,
    received_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    version BIGINT NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    INDEX idx_inventory_batch_store_expiry (store_id, expiry_date, quantity_on_hand),
    INDEX idx_inventory_batch_store_variant_expiry (store_id, variant_id, expiry_date)
);

CREATE TABLE IF NOT EXISTS stock_reservation_batch_allocations (
    id BIGINT NOT NULL AUTO_INCREMENT,
    reservation_id BIGINT NOT NULL,
    batch_id BIGINT NOT NULL,
    quantity BIGINT NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_reservation_batch_allocation (reservation_id, batch_id),
    INDEX idx_reservation_batch_allocation_reservation (reservation_id),
    INDEX idx_reservation_batch_allocation_batch (batch_id)
);

ALTER TABLE inventory_movements
    ADD COLUMN batch_id BIGINT NULL;

ALTER TABLE stock_reservations
    ADD COLUMN allow_negative_stock TINYINT(1) NOT NULL DEFAULT 0;

INSERT INTO inventory_batches (
    store_id, variant_id, batch_code, expiry_date, source_type, source_reference,
    quantity_received, quantity_on_hand, received_at, version
)
SELECT
    balance.store_id,
    balance.variant_id,
    NULL,
    NULL,
    CASE WHEN balance.quantity_on_hand < 0 THEN 'NEGATIVE_STOCK' ELSE 'OPENING_BALANCE' END,
    NULL,
    CASE WHEN balance.quantity_on_hand > 0 THEN balance.quantity_on_hand ELSE 0 END,
    balance.quantity_on_hand,
    CURRENT_TIMESTAMP,
    0
FROM stock_balances balance
LEFT JOIN inventory_batches existing_batch
  ON existing_batch.store_id = balance.store_id
 AND existing_batch.variant_id = balance.variant_id
WHERE balance.quantity_on_hand <> 0
  AND existing_batch.id IS NULL;
