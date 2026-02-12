--checking the content of tables
select * from customer.customers_dataset
limit 100;

select * from customer.geolocation_dataset
limit 100;

select * from customer.order_items_dataset
limit 100;

select * from customer.order_payments_dataset
limit 100;

select * from customer.order_reviews_dataset
limit 100;

select * from customer.orders_dataset
limit 100;

select * from customer.product_category_name_translation
limit 100;

select * from customer.products_dataset
limit 100;

select * from customer.sellers_dataset
limit 100;

/*----------------------PRODUCT DATASET OPERATIONS-----------------------*/

--linking the product category name from product_dataset table to
--the translated version in product_category_name_translatin table
select COUNT (DISTINCT product_category_name) from customer.products_dataset;

select COUNT (DISTINCT product_category_name) FROM customer.product_category_name_translation;

-- distinct null values found in customer.products_dataset

--handling these null values and giving english translation as 'Unknown'
SELECT
    p.product_id,
    p.product_category_name,
    COALESCE(
        t.product_category_name_english,
        'Unknown'
        ) AS product_category
FROM customer.products_dataset p
LEFT JOIN customer.product_category_name_translation t
ON p.product_category_name = t.product_category_name;


-- no of 'Unknown' rows or unmapped product names
SELECT
    COUNT(*) AS unmapped_products
FROM customer.products_dataset p
LEFT JOIN customer.product_category_name_translation t
ON p.product_category_name = t.product_category_name
WHERE t.product_category_name_english IS NULL;

-- making new table with english product catgory name column
CREATE TABLE customer.products_dataset_updated AS
SELECT
    p.product_id,
    p.product_category_name AS product_category_portu,
    COALESCE(
        t.product_category_name_english,
        'Unknown'
    ) AS product_category_eng,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm
FROM customer.products_dataset p
LEFT JOIN customer.product_category_name_translation t
ON p.product_category_name = t.product_category_name;

--SELECT * FROM customer.products_dataset_updated LIMIT 100;

--adding primary key
ALTER TABLE customer.products_dataset_updated
ADD PRIMARY KEY (product_id);

--adding index for faster execution
CREATE INDEX idx_products_updated_category
ON customer.products_dataset_updated(product_category_eng);


SELECT
    product_category_eng,
    product_weight_g as weight_grams,
    product_length_cm*product_height_cm*product_width_cm as volume_cub_cm
FROM customer.products_dataset_updated
ORDER BY volume_cub_cm DESC;

SELECT 
    product_category_eng,
    COUNT(*) AS no_of_products
FROM customer.products_dataset_updated
GROUP BY product_category_eng
ORDER BY no_of_products DESC;


SELECT 
    product_category_eng,
    SUM(price) AS total_price__of_products,
    SUM(price) - SUM(freight_value) as total_cost_of_products
FROM customer.products_dataset_updated p
LEFT JOIN customer.order_items_dataset o
ON p.product_id = o.product_id
GROUP BY product_category_eng
ORDER BY total_price__of_products DESC;

--fix the names of states or locations
-- find the location of most bought products
SELECT * FROM customer.sellers_dataset
WHERE seller_city = '04482255'
ORDER BY seller_city;

SELECT o.seller_id FROM customer.order_items_dataset o
INNER JOIN customer.sellers_dataset s
ON o.seller_id = s.seller_id
WHERE s.seller_city = '04482255';

--deleting this outlier row from related tables
DELETE FROM customer.order_items_dataset
WHERE seller_id = 'ceb7b4fb9401cd378de7886317ad1b47';

DELETE FROM customer.sellers_dataset
WHERE seller_id = 'ceb7b4fb9401cd378de7886317ad1b47';

--
SELECT DISTINCT seller_city, seller_state FROM customer.sellers_dataset
ORDER BY seller_city;


--making a clean and updated (city data labelled) sellers table
CREATE TABLE customer.sellers_dataset_updated AS
SELECT
    seller_id,
    seller_zip_code_prefix,
    seller_city AS seller_city_raw,
    LOWER(TRIM(SPLIT_PART(seller_city, '/', 1))) AS seller_city_clean,
    seller_state,
    CASE
        WHEN seller_city LIKE '%@%' THEN 'invalid'
        WHEN seller_city LIKE '%/%' THEN 'needs_review'
        ELSE 'clean'
    END AS city_quality_flag
FROM customer.sellers_dataset;

ALTER TABLE customer.sellers_dataset_updated
ADD CONSTRAINT sellers_dataset_updated_pkey PRIMARY KEY (seller_id);

CREATE INDEX idx_sellers_city_clean
ON customer.sellers_dataset_updated (seller_city_clean);