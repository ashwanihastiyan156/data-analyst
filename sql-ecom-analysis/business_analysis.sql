/* -------------JOINS--------------*/
SELECT
    o.order_id,
    o.order_purchase_timestamp,
    c.customer_unique_id,
    c.customer_city,
    c.customer_state
FROM customer.orders_dataset o
JOIN customer.customers_dataset c
  ON o.customer_id = c.customer_id;


SELECT
    o.order_id,
    oi.order_item_id,
    p.product_category_eng,
    oi.price,
    oi.freight_value
FROM customer.orders_dataset o
JOIN customer.order_items_dataset oi
  ON o.order_id = oi.order_id
JOIN customer.products_dataset_updated p
  ON oi.product_id = p.product_id;


SELECT
    oi.order_id,
    s.seller_city_clean,
    s.seller_state,
    oi.price
FROM customer.order_items_dataset oi
JOIN customer.sellers_dataset_updated s
  ON oi.seller_id = s.seller_id;

--category with most revenue
SELECT
    p.product_category_eng,
    SUM(oi.price + oi.freight_value) AS revenue
FROM customer.order_items_dataset oi
JOIN customer.products_dataset_updated p
  ON oi.product_id = p.product_id
GROUP BY p.product_category_eng
ORDER BY revenue DESC;

--state-wise performance
SELECT
    s.seller_state,
    COUNT(DISTINCT oi.order_id) AS orders,
    SUM(oi.price) AS revenue
FROM customer.order_items_dataset oi
JOIN customer.sellers_dataset_updated s
  ON oi.seller_id = s.seller_id
GROUP BY s.seller_state
ORDER BY revenue DESC;


--average order value: average revenue one order generates
SELECT
    SUM(oi.price + oi.freight_value) / COUNT(DISTINCT o.order_id) AS avg_order_value
FROM customer.orders_dataset o
JOIN customer.order_items_dataset oi
  ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';


--customer lifetime value: total revenue geneated by a customer across all their orders
SELECT
    customer_unique_id,
    SUM(oi.price + oi.freight_value) AS customer_lifetime_value
FROM customer.customers_dataset c
JOIN customer.orders_dataset o
  ON c.customer_id = o.customer_id
JOIN customer.order_items_dataset oi
  ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
ORDER BY customer_lifetime_value DESC;

/* I used "custome_unique_id", because "customer_id" is unique per order, but "customer_unique_id" is unique per customer.*/


--revenue per seller: revenue each seller generates
SELECT
    s.seller_id,
    s.seller_state,
    SUM(oi.price + oi.freight_value) AS seller_revenue
FROM customer.order_items_dataset oi
JOIN customer.orders_dataset o
  ON oi.order_id = o.order_id
JOIN customer.sellers_dataset_updated s
  ON oi.seller_id = s.seller_id
WHERE o.order_status = 'delivered'
GROUP BY s.seller_id, s.seller_state
ORDER BY seller_revenue DESC;


--cancellation rate: percentage of orders that got cancelled
SELECT
    COUNT(*) FILTER (WHERE order_status = 'canceled')::FLOAT
    / COUNT(*) AS cancellation_rate
FROM customer.orders_dataset;


--low review rate: review rate assuming review with score less or equal to 2 is low
SELECT
    COUNT(*) FILTER (WHERE r.review_score <= 2)::FLOAT
    / COUNT(*) AS low_review_rate
FROM customer.orders_dataset o
JOIN customer.order_reviews_dataset r
  ON o.order_id = r.order_id
WHERE o.order_status = 'delivered';


--delivery time: time taken to deliver order in a state (only considering delivered orders)
SELECT
    c.customer_state,
    AVG(
        o.order_delivered_customer_date 
        - o.order_purchase_timestamp
    ) AS avg_delivery_days
FROM customer.orders_dataset o
JOIN customer.customers_dataset c
  ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY avg_delivery_days;


/*----------BUSINESS ANALYSIS INSIGHTS------------*/

--month over month revenue growth
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
        SUM(oi.price + oi.freight_value) AS revenue
    FROM customer.orders_dataset o
    JOIN customer.order_items_dataset oi
      ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY month
)
SELECT
    month,
    revenue,
    revenue - LAG(revenue) OVER (ORDER BY month) AS mom_growth
FROM monthly_revenue;


--cumulative revenue over time
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
        SUM(oi.price + oi.freight_value) AS revenue
    FROM customer.orders_dataset o
    JOIN customer.order_items_dataset oi
      ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY month
)
SELECT
    month,
    revenue,
    SUM(revenue) OVER (ORDER BY month) AS cumulative_revenue
FROM monthly_revenue;


--customer spend growth over time: order-level details of customer's spend growth over time
SELECT
    c.customer_unique_id,
    o.order_purchase_timestamp,
    SUM(oi.price + oi.freight_value)
      OVER (
        PARTITION BY c.customer_unique_id
        ORDER BY o.order_purchase_timestamp
      ) AS running_customer_spend
FROM customer.customers_dataset c
JOIN customer.orders_dataset o
  ON c.customer_id = o.customer_id
JOIN customer.order_items_dataset oi
  ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';



--rank of sellers by revenue in a state
SELECT
    s.seller_id,
    s.seller_state,
    SUM(oi.price) as revenue,
    RANK() OVER (
        PARTITION BY s.seller_state
        ORDER BY SUM(oi.price) DESC
        ) AS seller_rank_in_state
FROM customer.sellers_dataset_updated s
JOIN customer.order_items_dataset oi
ON s.seller_id = oi.seller_id
JOIN customer.orders_dataset o
ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY s.seller_state, s.seller_id;


--top n sellers per state
SELECT *
FROM (
    SELECT
        s.seller_state,
        s.seller_id,
        SUM(oi.price) AS revenue,
        ROW_NUMBER() OVER (
            PARTITION BY s.seller_state
            ORDER BY SUM(oi.price) DESC
        ) AS rn
    FROM customer.order_items_dataset oi
    JOIN customer.sellers_dataset_updated s
      ON oi.seller_id = s.seller_id
    JOIN customer.orders_dataset o
      ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY s.seller_state, s.seller_id
) ranked
WHERE rn <= 3;


--rank products by revenue within category
SELECT
    p.product_category_eng,
    p.product_id,
    SUM(oi.price) AS revenue,
    RANK() OVER (
        PARTITION BY p.product_category_eng
        ORDER BY SUM(oi.price) DESC
    ) AS product_rank
FROM customer.order_items_dataset oi
JOIN customer.products_dataset_updated p
  ON oi.product_id = p.product_id
GROUP BY p.product_category_eng, p.product_id;


--% revenue contribution per category
SELECT
    pr.product_category_eng,
    SUM(oi.price + oi.freight_value) as category_revenue,
    SUM(oi.price + oi.freight_value)
     / SUM(SUM(oi.price + oi.freight_value)) OVER ()as revenue_share
FROM customer.order_items_dataset oi
JOIN customer.products_dataset_updated pr
ON oi.product_id = pr.product_id
GROUP BY pr.product_category_eng;


----% revenue contribution within category
SELECT
    pr.product_id,
    pr.product_category_eng,
    SUM(oi.price + oi.freight_value) as revenue,
    SUM(oi.price + oi.freight_value)
     / SUM(SUM(oi.price + oi.freight_value)) OVER (
        PARTITION BY pr.product_category_eng
     )as revenue_share
FROM customer.order_items_dataset oi
JOIN customer.products_dataset_updated pr
ON oi.product_id = pr.product_id
GROUP BY pr.product_category_eng, pr.product_id;


--average delivery time: per order vs per category
SELECT
    p.product_category_eng,
    o.order_id,
    (o.order_delivered_customer_date - o.order_purchase_timestamp) AS delivery_days,
    AVG(
        o.order_delivered_customer_date - o.order_purchase_timestamp
    ) OVER (
        PARTITION BY p.product_category_eng
    ) AS avg_category_delivery
FROM customer.orders_dataset o
JOIN customer.order_items_dataset oi
  ON o.order_id = oi.order_id
JOIN customer.products_dataset_updated p
  ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered';


--review score : per order vs category average
SELECT
    p.product_category_eng,
    r.review_score,
    AVG(r.review_score) OVER (
        PARTITION BY p.product_category_eng
    ) AS avg_category_rating
FROM customer.order_reviews_dataset r
JOIN customer.orders_dataset o
  ON r.order_id = o.order_id
JOIN customer.order_items_dataset oi
  ON o.order_id = oi.order_id
JOIN customer.products_dataset_updated p
  ON oi.product_id = p.product_id;



/*----------------ANALYSIS VIEWS-----------------*/

--base view
CREATE VIEW category_review_benchmark AS
SELECT
    o.order_id,
    p.product_category_eng,
    r.review_score,
    AVG(r.review_score) OVER (
        PARTITION BY p.product_category_eng
    ) AS category_avg_review
FROM customer.orders_dataset o
JOIN customer.order_reviews_dataset r
  ON o.order_id = r.order_id
JOIN customer.order_items_dataset oi
  ON o.order_id = oi.order_id
JOIN customer.products_dataset_updated p
  ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered';


SELECT * FROM category_review_benchmark;


--in which categories, multiple orders perform below their own average
SELECT
    product_category_eng,
    COUNT(*) FILTER (
        WHERE review_score < category_avg_review
    ) AS no_of_orders_below_avg_review,
    COUNT(*) AS total_no_of_orders_per_category,
    COUNT(*) FILTER (
        WHERE review_score < category_avg_review
    ) * 100.00 / COUNT(*) AS percentage_of_below_avg_review_orders
FROM category_review_benchmark
GROUP BY product_category_eng
ORDER BY percentage_of_below_avg_review_orders DESC;
--diapers_and_hygiene and security_and_services have more than or equal to 50% of orders
--rated below their category average, indicating persistent quality or fulfillment issues.


--are low review scores clustered in certain categories? (Assuming review score 2 or less as low)
SELECT
    product_category_eng,
    COUNT(*) FILTER (WHERE review_score <= 2) as loW_review_orders,
    COUNT(*) as total_no_of_reviews,
    COUNT(*) FILTER (WHERE review_score <= 2) * 1.00 / COUNT(*) as low_review_rate
FROM category_review_benchmark
GROUP BY product_category_eng
ORDER BY low_review_rate DESC;
--Low review scores are concentrated in a limited number of categories: nine categories exceed a 20% low-review threshold, with security_and_services showing the highest dissatisfaction rate at roughly 50%


-- do high value categories also have low reviews?
CREATE VIEW category_revenue AS
SELECT
    p.product_category_eng,
    SUM(oi.price + oi.freight_value) AS revenue
FROM customer.order_items_dataset oi
JOIN customer.orders_dataset o
  ON oi.order_id = o.order_id
JOIN customer.products_dataset_updated p
  ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered'
GROUP BY p.product_category_eng;

SELECT * FROM category_revenue;

--insight using revenue and review scores
SELECT
    r.product_category_eng,
    c.revenue,
    COUNT(*) FILTER(WHERE r.review_score <= 2) * 1.0 / COUNT(*) AS low_review_rate
FROM category_review_benchmark r
JOIN category_revenue c
  ON r.product_category_eng = c.product_category_eng
GROUP BY r.product_category_eng, c.revenue
ORDER BY c.revenue DESC;
--Several high-revenue categories show moderate-to-high low-review rates, indicating that strong sales performance does not necessarily translate into positive customer experience
--office_furniture is a clear quality outlier, with over 25% of orders receiving low ratings—nearly double the platform average—despite contributing moderate revenue
--Certain categories (cool_stuff, stationery, computers) consistently maintain low-review rates below 12%, suggesting better product quality control or fulfillment reliability compared to the platform average


/*----------------seller performance view--------------*/
CREATE VIEW seller_performance_view AS
SELECT
    s.seller_id,
    s.seller_state,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    SUM(oi.price + oi.freight_value) AS revenue,
    COUNT(*) FILTER (WHERE r.review_score <= 2) AS low_review_orders,
    COUNT(r.review_score) AS total_reviewed_orders,
    COUNT(*) FILTER (WHERE r.review_score <= 2) * 1.0
      / NULLIF(COUNT(r.review_score), 0) AS low_review_rate
FROM customer.order_items_dataset oi
JOIN customer.orders_dataset o
  ON oi.order_id = o.order_id
JOIN customer.sellers_dataset_updated s
  ON oi.seller_id = s.seller_id
LEFT JOIN customer.order_reviews_dataset r
  ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY s.seller_id, s.seller_state;


SELECT * FROM seller_performance_view
ORDER BY revenue DESC;


--are few sellers responsible for most low reviews?
SELECT *
FROM (
    SELECT
        seller_id,
        low_review_orders,
        cumulative_low_reviews * 1.0 / total_low_reviews
          AS cumulative_low_review_pct
    FROM (
        SELECT
            seller_id,
            low_review_orders,
            SUM(low_review_orders) OVER () AS total_low_reviews,
            SUM(low_review_orders) OVER (
                ORDER BY low_review_orders DESC
            ) AS cumulative_low_reviews
        FROM seller_performance_view
    ) t1
) t2
WHERE cumulative_low_review_pct <= 0.80;

--Even after considering all sellers, only about 78% of low-review orders are explained by seller-level attribution.
--So, Customer dissatisfaction is not driven by a small subset of sellers. Instead, low-review orders are broadly distributed across the seller base, suggesting systemic issues rather than isolated seller-specific problems



/*--------------customer lifecycle--------------------*/

CREATE VIEW customer_lifecycle_view AS
SELECT
    c.customer_unique_id,
    o.order_id,
    o.order_purchase_timestamp,
    ROW_NUMBER() OVER (
        PARTITION BY c.customer_unique_id
        ORDER BY o.order_purchase_timestamp
    ) AS order_number
FROM customer.customers_dataset c
JOIN customer.orders_dataset o
  ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered';

SELECT * FROM customer_lifecycle_view
ORDER BY order_number DESC;

--first time or repeat customer
SELECT
    CASE
        WHEN order_number = 1 THEN 'first_time'
        ELSE 'repeat'
    END AS customer_type,
    COUNT(DISTINCT customer_unique_id) AS customers
FROM customer_lifecycle_view
GROUP BY customer_type;
-- first time: 93358 and repeat: 2801



--delivery delay impact on review scores
SELECT
    CASE
        WHEN o.order_delivered_customer_date 
             <= o.order_estimated_delivery_date
        THEN 'on_time'
        ELSE 'late'
    END AS delivery_status,
    COUNT(*) AS total_orders,
    COUNT(*) FILTER (WHERE r.review_score <= 2) AS low_review_orders,
    COUNT(*) FILTER (WHERE r.review_score <= 2) * 1.0
      / COUNT(*) AS low_review_rate
FROM customer.orders_dataset o
JOIN customer.order_reviews_dataset r
  ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY delivery_status;


--delivery delay duration vs review scores
SELECT
    CASE
        WHEN o.order_delivered_customer_date 
             <= o.order_estimated_delivery_date
        THEN 'on_time'
        ELSE 'late'
    END AS delivery_status,
    AVG(r.review_score) AS avg_review_score
FROM customer.orders_dataset o
JOIN customer.order_reviews_dataset r
  ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY delivery_status;

/*These two results imply that:
"Delivery delays are the strongest driver of customer dissatisfaction in the dataset.
Orders delivered late show a low-review rate of ~54%, compared to just ~9% for on-time deliveries.
Additionally, late deliveries receive an average review score of 2.56 versus 4.29 for on-time orders"*/

