CREATE TABLE customer.geolocation_dataset
(
    geolocation_zip_code_prefix NUMERIC,
    geolocation_lat NUMERIC(16,13),
    geolocation_lng NUMERIC(16,13),
    geolocation_city TEXT,
    geolocation_state TEXT
);


CREATE TABLE customer.product_category_name_translation
(
    product_category_name TEXT PRIMARY KEY,
    product_category_name_english TEXT
);

CREATE TABLE customer.customers_dataset
(
    customer_id VARCHAR PRIMARY KEY,
    customer_unique_id VARCHAR,
    customer_zip_code_prefix NUMERIC,
    customer_city TEXT,
    customer_state TEXT
);

CREATE TABLE customer.sellers_dataset
(
    seller_id VARCHAR PRIMARY KEY,
    seller_zip_code_prefix NUMERIC,
    seller_city TEXT,
    seller_state TEXT
);

CREATE TABLE customer.products_dataset
(
    product_id VARCHAR PRIMARY KEY,
    product_category_name TEXT,
    product_name_length NUMERIC,
    product_description_length NUMERIC,
    product_photos_qty INTEGER,
    product_weight_g NUMERIC,
    product_length_cm NUMERIC,
    product_height_cm NUMERIC,
    product_width_cm NUMERIC,

    CONSTRAINT fk_products_category
        FOREIGN KEY (product_category_name)
        REFERENCES customer.product_category_name_translation (product_category_name)
);

CREATE TABLE customer.orders_dataset
(
    order_id VARCHAR PRIMARY KEY,
    customer_id VARCHAR  NOT NULL,
    order_status TEXT,
    order_purchase_timestamp TIMESTAMPTZ,
    order_approved_at TIMESTAMPTZ,
    order_delivered_carrier_date TIMESTAMPTZ,
    order_delivered_customer_date TIMESTAMPTZ,
    order_estimated_delivery_date TIMESTAMPTZ,

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES customer.customers_dataset (customer_id)
);

CREATE TABLE customer.order_items_dataset
(
    order_id VARCHAR NOT NULL,
    order_item_id INTEGER NOT NULL,
    product_id VARCHAR NOT NULL,
    seller_id VARCHAR NOT NULL,
    shipping_limit_date TIMESTAMPTZ,
    price NUMERIC(10,2),

    CONSTRAINT chk_price_positive
        CHECK (price >= 0),

    freight_value NUMERIC(8,2),

    CONSTRAINT chk_freight_positive
        CHECK (freight_value >= 0),

    CONSTRAINT pk_order_items
        PRIMARY KEY (order_id, order_item_id),

    CONSTRAINT fk_items_order
        FOREIGN KEY (order_id)
        REFERENCES customer.orders_dataset (order_id),

    CONSTRAINT fk_items_product
        FOREIGN KEY (product_id)
        REFERENCES customer.products_dataset (product_id),

    CONSTRAINT fk_items_seller
        FOREIGN KEY (seller_id)
        REFERENCES customer.sellers_dataset (seller_id)
);


CREATE TABLE customer.order_payments_dataset
(
    order_id VARCHAR NOT NULL,
    payment_sequential INTEGER NOT NULL,
    payment_type TEXT,
    payment_installments INTEGER,
    payment_value NUMERIC(10,2),

    CONSTRAINT pk_order_payments
        PRIMARY KEY (order_id, payment_sequential),

    CONSTRAINT fk_payments_order
        FOREIGN KEY (order_id)
        REFERENCES customer.orders_dataset (order_id)
);

CREATE TABLE customer.order_reviews_dataset
(
    review_id VARCHAR NOT NULL,
    order_id VARCHAR NOT NULL,
    review_score INTEGER,

    CONSTRAINT chk_review_score
        CHECK (review_score BETWEEN 1 AND 5),

    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMPTZ,
    review_answer_timestamp TIMESTAMPTZ,

    CONSTRAINT pk_order_reviews
        PRIMARY KEY (review_id, order_id),

    CONSTRAINT fk_reviews_order
        FOREIGN KEY (order_id)
        REFERENCES customer.orders_dataset (order_id)
);


-- Index for faster joins
CREATE INDEX idx_orders_customer_id ON customer.orders_dataset (customer_id);
CREATE INDEX idx_order_items_product_id ON customer.order_items_dataset (product_id);
CREATE INDEX idx_order_items_seller_id ON customer.order_items_dataset (seller_id);
CREATE INDEX idx_order_payments_order_id ON customer.order_payments_dataset (order_id);
CREATE INDEX idx_order_reviews_order_id ON customer.order_reviews_dataset (order_id);