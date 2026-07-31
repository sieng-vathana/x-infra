-- Run against the store-service database. Do not run automatically in production.
CREATE TABLE IF NOT EXISTS store_images (
    id BIGINT NOT NULL AUTO_INCREMENT,
    store_id BIGINT NOT NULL,
    image_url TEXT NOT NULL,
    is_primary BOOLEAN NOT NULL DEFAULT FALSE,
    sort_order INT NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    INDEX ix_store_image_store_sort (store_id, sort_order)
);
