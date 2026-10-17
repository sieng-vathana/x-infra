-- Store the Bakong account that receives the POS KHQR payments for each business.
ALTER TABLE businesses
    ADD COLUMN IF NOT EXISTS bakong_account_id VARCHAR(32) NULL;
