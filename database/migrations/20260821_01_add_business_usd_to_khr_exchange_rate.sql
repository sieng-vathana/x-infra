-- Store the business-level rate used when POS converts catalog prices between USD and KHR.
ALTER TABLE businesses
    ADD COLUMN IF NOT EXISTS usd_to_khr_exchange_rate DECIMAL(19,6) NOT NULL DEFAULT 4000.000000;

-- Repair legacy rows created before the POS exchange-rate setting existed, or
-- rows that were initialized with the invalid zero value.
UPDATE businesses
SET usd_to_khr_exchange_rate = 4000.000000
WHERE usd_to_khr_exchange_rate IS NULL OR usd_to_khr_exchange_rate <= 0;
