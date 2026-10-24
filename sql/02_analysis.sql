-- E-Commerce Sales Analysis | PostgreSQL 18
-- Run individual statements after importing data.
-- 'Canceled' is the exact spelling in the dataset.

-- 1. Data quality and status validation
SELECT COUNT(*) AS rows_imported,
       COUNT(DISTINCT order_no) AS unique_order_ids,
       MIN(order_date) AS first_order_date,
       MAX(order_date) AS last_order_date
FROM sales;

SELECT order_state, COUNT(*) AS orders
FROM sales
GROUP BY order_state
ORDER BY orders DESC;

-- 2. Core KPI: completed orders, amount and average order value
SELECT COUNT(*) AS completed_orders,
       ROUND(SUM(total_amount_usd), 2) AS completed_sales_usd,
       ROUND(AVG(total_amount_usd), 2) AS average_completed_order_usd
FROM sales
WHERE order_state = 'Completed';

-- 3. Monthly dashboard inputs with conditional aggregation
SELECT order_month,
       COUNT(*) AS all_orders,
       COUNT(*) FILTER (WHERE order_state = 'Completed') AS completed_orders,
       COUNT(*) FILTER (WHERE order_state = 'Canceled') AS canceled_orders,
       COUNT(*) FILTER (WHERE order_state IN ('Received', 'Delivered')) AS open_orders,
       COALESCE(SUM(total_amount_usd) FILTER (WHERE order_state = 'Completed'), 0) AS completed_sales_usd,
       ROUND(100.0 * COUNT(*) FILTER (WHERE order_state = 'Canceled')
             / NULLIF(COUNT(*), 0), 2) AS cancellation_rate_pct
FROM sales
GROUP BY order_month
ORDER BY order_month;

-- 4. Daily completed sales
SELECT order_date, COUNT(*) AS completed_orders,
       SUM(total_amount_usd) AS completed_sales_usd
FROM sales
WHERE order_state = 'Completed'
GROUP BY order_date
ORDER BY order_date;

-- 5. Month-over-month revenue change: CTE + LAG()
WITH monthly_sales AS (
    SELECT order_month, SUM(total_amount_usd) AS revenue
    FROM sales
    WHERE order_state = 'Completed'
    GROUP BY order_month
), sales_with_lag AS (
    SELECT order_month, revenue,
           LAG(revenue) OVER (ORDER BY order_month) AS previous_revenue
    FROM monthly_sales
)
SELECT order_month,
       ROUND(revenue, 2) AS completed_sales_usd,
       ROUND(previous_revenue, 2) AS previous_month_usd,
       ROUND(revenue - previous_revenue, 2) AS difference_usd,
       ROUND(100.0 * (revenue - previous_revenue)
             / NULLIF(previous_revenue, 0), 2) AS growth_pct
FROM sales_with_lag
ORDER BY order_month;

-- 6. Three largest completed orders per month: ROW_NUMBER()
WITH ranked_orders AS (
    SELECT order_month, order_no, total_amount_usd,
           ROW_NUMBER() OVER (
               PARTITION BY order_month
               ORDER BY total_amount_usd DESC, order_no
           ) AS revenue_rank
    FROM sales
    WHERE order_state = 'Completed'
)
SELECT order_month, order_no, total_amount_usd, revenue_rank
FROM ranked_orders
WHERE revenue_rank <= 3
ORDER BY order_month, revenue_rank;

-- 7. Feedback distribution; missing ratings are not negative ratings
SELECT COALESCE(NULLIF(feedback_rating, ''), 'Not rated') AS feedback,
       COUNT(*) AS orders
FROM sales
GROUP BY 1
ORDER BY orders DESC;
