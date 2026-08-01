-- Customers are business-wide. store_id is optional metadata for the
-- originating/default store and must not restrict customer visibility.
ALTER TABLE customers
    ADD COLUMN store_id BIGINT NULL AFTER business_id,
    ADD INDEX idx_customers_business_store (business_id, store_id);
