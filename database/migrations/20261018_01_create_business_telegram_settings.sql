-- Telegram alert settings for each business (x-business-service).
-- Hibernate creates this table on deploy (ddl-auto: update); this script is for databases managed by hand.
CREATE TABLE IF NOT EXISTS business_telegram_settings (
    business_id BIGINT NOT NULL,
    chat_id BIGINT NULL,
    chat_title VARCHAR(255) NULL,
    daily_summary BIT(1) NOT NULL,
    daily_summary_hour INT NOT NULL,
    khqr_alerts BIT(1) NOT NULL,
    link_code VARCHAR(32) NULL,
    link_code_expires_at DATETIME(6) NULL,
    low_stock_alerts BIT(1) NOT NULL,
    low_stock_threshold INT NOT NULL,
    order_alerts BIT(1) NOT NULL,
    summary_sent_on DATE NULL,
    updated_at DATETIME(6) NULL,
    PRIMARY KEY (business_id),
    UNIQUE KEY uk_business_telegram_link_code (link_code)
);
