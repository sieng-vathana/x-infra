ALTER TABLE customers
    ADD COLUMN IF NOT EXISTS user_id BIGINT NULL AFTER id;

ALTER TABLE customers
    ADD UNIQUE INDEX IF NOT EXISTS uk_customer_business_user (business_id, user_id);

ALTER TABLE customers
    ADD INDEX IF NOT EXISTS idx_customers_user (user_id);
