/*
Description:
This script bulk loads CSV datasets into PostgreSQL tables
using COPY statements. The loading order respects foreign key
dependencies to ensure referential integrity.

Instructions:
- Update file paths as per your local system.
- Execute within a transaction block.
*/



COPY customer.geolocation_dataset
FROM 'D:/Ashwani/SQL/Project/brazil_ecom/olist_geolocation_dataset.csv'
DELIMITER ','
CSV HEADER
NULL '';


COPY customer.product_category_name_translation
FROM 'D:/Ashwani/SQL/Project/brazil_ecom/product_category_name_translation.csv'
DELIMITER ','
CSV HEADER
NULL '';

COPY customer.customers_dataset
FROM 'D:/Ashwani/SQL/Project/brazil_ecom/olist_customers_dataset.csv'
DELIMITER ','
CSV HEADER
NULL '';

COPY customer.sellers_dataset
FROM 'D:/Ashwani/SQL/Project/brazil_ecom/olist_sellers_dataset.csv'
DELIMITER ','
CSV HEADER
NULL '';

COPY customer.products_dataset
FROM 'D:/Ashwani/SQL/Project/brazil_ecom/olist_products_dataset.csv'
DELIMITER ','
CSV HEADER
NULL '';

COPY customer.orders_dataset
FROM 'D:/Ashwani/SQL/Project/brazil_ecom/olist_orders_dataset.csv'
DELIMITER ','
CSV HEADER
NULL '';

COPY customer.order_items_dataset
FROM 'D:/Ashwani/SQL/Project/brazil_ecom/olist_order_items_dataset.csv'
DELIMITER ','
CSV HEADER
NULL '';

COPY customer.order_payments_dataset
FROM 'D:/Ashwani/SQL/Project/brazil_ecom/olist_order_payments_dataset.csv'
DELIMITER ','
CSV HEADER
NULL '';

COPY customer.order_reviews_dataset
FROM 'D:/Ashwani/SQL/Project/brazil_ecom/olist_order_reviews_dataset.csv'
DELIMITER ','
CSV HEADER
NULL '';
