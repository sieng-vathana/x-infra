-- Store the Bakong account that receives the POS KHQR payments for each business.
-- Hibernate adds this column on deploy (ddl-auto: update); run this only on a database that lacks it.
ALTER TABLE businesses
    ADD COLUMN bakong_account_id VARCHAR(32) NULL;
