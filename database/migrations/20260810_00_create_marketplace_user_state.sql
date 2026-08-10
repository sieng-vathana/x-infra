CREATE TABLE IF NOT EXISTS marketplace_favorites (
    id BIGINT NOT NULL AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    store_id BIGINT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT uk_marketplace_favorite_user_product UNIQUE (user_id, product_id),
    INDEX idx_marketplace_favorite_user (user_id)
);

CREATE TABLE IF NOT EXISTS marketplace_carts (
    id BIGINT NOT NULL AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT uk_marketplace_cart_user UNIQUE (user_id)
);

CREATE TABLE IF NOT EXISTS marketplace_cart_items (
    id BIGINT NOT NULL AUTO_INCREMENT,
    cart_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    store_id BIGINT NOT NULL,
    variant_id BIGINT NOT NULL,
    product_name VARCHAR(200) NOT NULL,
    thumbnail TEXT NULL,
    unit_price DECIMAL(19, 4) NOT NULL,
    currency_code VARCHAR(3) NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_marketplace_cart_item_cart FOREIGN KEY (cart_id) REFERENCES marketplace_carts (id),
    CONSTRAINT uk_marketplace_cart_product_variant UNIQUE (cart_id, product_id, variant_id),
    INDEX idx_marketplace_cart_item_cart (cart_id)
);
