-- Store the business-level rate used when POS converts catalog prices between USD and KHR.
ALTER TABLE businesses
    ADD COLUMN IF NOT EXISTS usd_to_khr_exchange_rate DECIMAL(19,6) NOT NULL DEFAULT 4000.000000;
