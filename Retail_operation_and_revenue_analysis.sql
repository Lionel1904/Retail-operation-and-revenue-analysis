CREATE DATABASE IF NOT EXISTS mini_retail;
USE mini_retail;

DROP TABLE IF EXISTS returns;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    region VARCHAR(50),
    signup_date DATE
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2)
);

CREATE TABLE returns (
    return_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    return_reason VARCHAR(100)
);

USE mini_retail;

-- 1. Monthly revenue trend
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    ROUND(SUM(total_amount), 2) AS revenue,
    COUNT(*) AS total_orders
FROM orders
GROUP BY month
ORDER BY month;

-- 2. Revenue by region using JOIN
SELECT 
    c.region,
    ROUND(SUM(o.total_amount), 2) AS revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.region
ORDER BY revenue DESC;

-- 3. Top 10 customers
SELECT
    c.customer_name,
    c.region,
    ROUND(SUM(o.total_amount), 2) AS total_spent,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_name, c.region
ORDER BY total_spent DESC
LIMIT 10;

-- 4. Best-selling products
SELECT
    p.product_name,
    p.category,
    SUM(oi.quantity) AS units_sold,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_name, p.category
ORDER BY revenue DESC
LIMIT 10;

-- 5. Customer segmentation using CTE + CASE
WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.customer_name,
        ROUND(SUM(o.total_amount), 2) AS total_spent
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT
    customer_name,
    total_spent,
    CASE
        WHEN total_spent >= 3000 THEN 'High Value'
        WHEN total_spent >= 1500 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM customer_revenue
ORDER BY total_spent DESC;

-- 6. Product category ranking using window function
WITH category_sales AS (
    SELECT
        p.category,
        ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
    FROM order_items oi
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY p.category
)
SELECT
    category,
    revenue,
    RANK() OVER (ORDER BY revenue DESC) AS revenue_rank
FROM category_sales;

-- 7. Running monthly revenue
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS month,
        SUM(total_amount) AS revenue
    FROM orders
    GROUP BY month
)
SELECT
    month,
    ROUND(revenue, 2) AS monthly_revenue,
    ROUND(SUM(revenue) OVER (ORDER BY month), 2) AS running_revenue
FROM monthly_sales;

-- 8. Return rate by category using LEFT JOIN
SELECT
    p.category,
    COUNT(r.return_id) AS returned_items,
    COUNT(oi.order_item_id) AS sold_items,
    ROUND(COUNT(r.return_id) * 100.0 / COUNT(oi.order_item_id), 2) AS return_rate_percent
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN returns r
    ON oi.order_id = r.order_id
   AND oi.product_id = r.product_id
GROUP BY p.category
ORDER BY return_rate_percent DESC;

-- 9. Customers with 3 or more orders using HAVING
SELECT
    c.customer_name,
    COUNT(o.order_id) AS total_orders,
    ROUND(SUM(o.total_amount), 2) AS total_spent
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_name
HAVING COUNT(o.order_id) >= 3
ORDER BY total_orders DESC;

-- 10. Average order value by region
SELECT
    c.region,
    ROUND(AVG(o.total_amount), 2) AS avg_order_value
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.region
ORDER BY avg_order_value DESC;