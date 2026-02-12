--checking the duplicates in tables

SELECT
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state,
    COUNT(*) AS cnt
FROM customer.customers_dataset
GROUP BY
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
HAVING COUNT(*) > 1;

SELECT
    order_id,
    order_item_id,
    COUNT(*) AS cnt
FROM customer.order_items_dataset
GROUP BY
    order_id,
    order_item_id
HAVING COUNT(*) > 1;

SELECT
    order_id,
    COUNT(*) AS cnt
FROM customer.orders_dataset
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT
    order_id,
    payment_sequential,
    COUNT(*) AS cnt
FROM customer.order_payments_dataset
GROUP BY
    order_id,
    payment_sequential
HAVING COUNT(*) > 1;

SELECT
    review_id,
    COUNT(*) AS cnt
FROM customer.order_reviews_dataset
GROUP BY review_id
HAVING COUNT(*) > 1;

SELECT
    product_id,
    COUNT(*) AS cnt
FROM customer.products_dataset
GROUP BY product_id
HAVING COUNT(*) > 1;

SELECT
    seller_id,
    COUNT(*) AS cnt
FROM customer.sellers_dataset
GROUP BY seller_id
HAVING COUNT(*) > 1;

SELECT
    product_category_name,
    COUNT(*) AS cnt
FROM customer.product_category_name_translation
GROUP BY product_category_name
HAVING COUNT(*) > 1;

--no duplicates found

--row counts
SELECT COUNT(*) FROM customer.customers_dataset;
SELECT COUNT(*) FROM customer.orders_dataset;
SELECT COUNT(*) FROM customer.order_items_dataset;
SELECT COUNT(*) FROM customer.order_payments_dataset;
SELECT COUNT(*) FROM customer.order_reviews_dataset;


--date range
SELECT 
    MIN(order_purchase_timestamp),
    MAX(order_purchase_timestamp)
FROM customer.orders_dataset;
-- sep 2016 to oct 2018


--checking for null values
SELECT
    COUNT(*) AS total_rows,
    COUNT(customer_id) AS customer_id_not_null,
    COUNT(customer_unique_id) AS customer_unique_id_not_null
FROM customer.customers_dataset;

SELECT *
FROM customer.customers_dataset
WHERE customer_city IS NULL OR customer_state IS NULL;


SELECT *
FROM customer.orders_dataset
WHERE order_id IS NULL OR customer_id IS NULL OR order_purchase_timestamp IS NULL;