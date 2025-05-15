-- 1. Basic SELECT queries with WHERE and ORDER BY
-- Find all customers from New York, ordered by name
SELECT customer_id, first_name, last_name, email, city
FROM customers
WHERE city = 'New York'
ORDER BY last_name, first_name;

-- 2. GROUP BY with aggregate functions
-- Calculate total sales by product category
SELECT 
    p.category,
    COUNT(oi.order_id) AS order_count,
    SUM(oi.quantity) AS total_units_sold,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM 
    order_items oi
JOIN 
    products p ON oi.product_id = p.product_id
GROUP BY 
    p.category
ORDER BY 
    total_revenue DESC;

-- 3. JOIN operations
-- Find all orders with customer details and order status (INNER JOIN)
SELECT 
    o.order_id,
    o.order_date,
    c.first_name,
    c.last_name,
    c.email,
    o.total_amount,
    o.status
FROM 
    orders o
INNER JOIN 
    customers c ON o.customer_id = c.customer_id
WHERE 
    o.order_date BETWEEN '2023-01-01' AND '2023-12-31'
ORDER BY 
    o.order_date DESC;

-- 4. LEFT JOIN to find customers who haven't ordered
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email
FROM 
    customers c
LEFT JOIN 
    orders o ON c.customer_id = o.customer_id
WHERE 
    o.order_id IS NULL;

-- 5. Subquery to find products with above-average prices
SELECT 
    product_id,
    product_name,
    price
FROM 
    products
WHERE 
    price > (SELECT AVG(price) FROM products)
ORDER BY 
    price DESC;

-- 6. Correlated subquery to find customers who spent more than average
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(o.total_amount) AS total_spent
FROM 
    customers c
JOIN 
    orders o ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name
HAVING 
    SUM(o.total_amount) > (
        SELECT AVG(total_amount) 
        FROM orders
        WHERE customer_id IS NOT NULL
    )
ORDER BY 
    total_spent DESC;

-- 7. Create a view for monthly sales analysis
CREATE VIEW monthly_sales AS
SELECT 
    DATE_TRUNC('month', order_date) AS month,
    COUNT(order_id) AS order_count,
    SUM(total_amount) AS total_sales,
    AVG(total_amount) AS avg_order_value
FROM 
    orders
GROUP BY 
    DATE_TRUNC('month', order_date)
ORDER BY 
    month;

-- 8. Optimize queries with indexes
CREATE INDEX idx_customer_email ON customers(email);
CREATE INDEX idx_order_customer_date ON orders(customer_id, order_date);
CREATE INDEX idx_product_category ON products(category);

-- 9. Complex query with multiple joins and aggregation
-- Customer lifetime value analysis
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.join_date,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent,
    SUM(o.total_amount) / COUNT(DISTINCT o.order_id) AS avg_order_value,
    DATEDIFF(DAY, MIN(o.order_date), MAX(o.order_date)) AS customer_duration_days
FROM 
    customers c
JOIN 
    orders o ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name, c.join_date
ORDER BY 
    total_spent DESC
LIMIT 20;

-- 10. Product sales performance (Pareto analysis)
WITH product_sales AS (
    SELECT 
        p.product_id,
        p.product_name,
        p.category,
        SUM(oi.quantity) AS units_sold,
        SUM(oi.quantity * oi.unit_price) AS revenue,
        RANK() OVER (ORDER BY SUM(oi.quantity * oi.unit_price) DESC) AS revenue_rank
    FROM 
        order_items oi
    JOIN 
        products p ON oi.product_id = p.product_id
    GROUP BY 
        p.product_id, p.product_name, p.category
)
SELECT 
    product_id,
    product_name,
    category,
    units_sold,
    revenue,
    revenue_rank,
    SUM(revenue) OVER (ORDER BY revenue_rank) / SUM(revenue) OVER () AS cumulative_revenue_percentage
FROM 
    product_sales
ORDER BY 
    revenue_rank;