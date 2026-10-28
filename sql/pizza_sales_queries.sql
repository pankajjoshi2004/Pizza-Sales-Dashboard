-- =====================================================
-- Pizza Sales Analysis (2015) - SQL queries
-- Database: pizza_db | Table: pizza_sales
-- Note: if order_date is stored as text (dd-mm-yyyy), convert it first:
--   STR_TO_DATE(order_date, '%d-%m-%Y')
-- =====================================================

USE pizza_db;

-- ---------- KPIs ----------

-- Total Revenue
SELECT ROUND(SUM(total_price), 2) AS Total_Revenue
FROM pizza_sales;

-- Average Order Value
SELECT ROUND(SUM(total_price) / COUNT(DISTINCT order_id), 2) AS Average_Order_Value
FROM pizza_sales;

-- Total Pizzas Sold
SELECT SUM(quantity) AS Total_Pizzas_Sold
FROM pizza_sales;

-- Total Orders
SELECT COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales;

-- Average Pizzas Per Order
SELECT ROUND(SUM(quantity) / COUNT(DISTINCT order_id), 2) AS Avg_Pizzas_Per_Order
FROM pizza_sales;

-- ---------- Trends ----------

-- Daily trend for total orders
SELECT DAYNAME(order_date) AS order_day,
       COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY DAYNAME(order_date), DAYOFWEEK(order_date)
ORDER BY DAYOFWEEK(order_date);

-- Monthly trend for total orders
SELECT MONTHNAME(order_date) AS month_name,
       COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY MONTHNAME(order_date), MONTH(order_date)
ORDER BY MONTH(order_date);

-- Hourly trend for total orders (extra analysis, not in the dashboard)
SELECT HOUR(order_time) AS order_hour,
       COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY HOUR(order_time)
ORDER BY order_hour;

-- ---------- Sales distribution ----------

-- % of sales by pizza category
SELECT pizza_category,
       ROUND(SUM(total_price), 2) AS total_revenue,
       ROUND(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales), 2) AS percentage
FROM pizza_sales
GROUP BY pizza_category
ORDER BY percentage DESC;

-- % of sales by pizza size
SELECT pizza_size,
       ROUND(SUM(total_price), 2) AS total_sales,
       ROUND(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales), 2) AS percentage
FROM pizza_sales
GROUP BY pizza_size
ORDER BY percentage DESC;

-- Total pizzas sold by pizza category
SELECT pizza_category,
       SUM(quantity) AS total_pizzas_sold
FROM pizza_sales
GROUP BY pizza_category
ORDER BY total_pizzas_sold DESC;

-- ---------- Best sellers (Top 5) ----------

-- Top 5 by revenue
SELECT pizza_name, ROUND(SUM(total_price), 2) AS total_revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_revenue DESC
LIMIT 5;

-- Top 5 by quantity
SELECT pizza_name, SUM(quantity) AS total_quantity
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_quantity DESC
LIMIT 5;

-- Top 5 by total orders
SELECT pizza_name, COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_orders DESC
LIMIT 5;

-- ---------- Worst sellers (Bottom 5) ----------

-- Bottom 5 by revenue
SELECT pizza_name, ROUND(SUM(total_price), 2) AS total_revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_revenue ASC
LIMIT 5;

-- Bottom 5 by quantity
SELECT pizza_name, SUM(quantity) AS total_quantity
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_quantity ASC
LIMIT 5;

-- Bottom 5 by total orders
SELECT pizza_name, COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_orders ASC
LIMIT 5;
