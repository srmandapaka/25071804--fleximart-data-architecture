# Query 1: Customer Purchase History (5 marks)

# Business Question: "Generate a detailed report showing each customer's name, email, total number of orders placed, 
#and total amount spent. Include only customers who have placed at least 2 orders and spent more than ₹5,000. 
#Order by total amount spent in descending order."
USE flipkart_bits

SELECT 
    c.first_name,
    c.last_name,
    c.email,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * oi.unit_price) AS total_amount_spent
FROM 
    customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name, c.email
HAVING 
    COUNT(DISTINCT o.order_id) >= 2
    AND SUM(oi.quantity * oi.unit_price) > 5000
ORDER BY 
    total_amount_spent DESC;

# OUTPUT 
# first_name last_name email total_orders total_amount_spent
# Lakshmi	Krishnan	Unknown4	2	85998.00
#Arjun	Rao	arjun.rao@gmail.com	2	82998.00
#Priya	Patel	priya.patel@yahoo.com	5	69992.00
#Karthik	Nair	karthik.nair@yahoo.com	2	57598.00
#Amit	Kumar	Unknown4	2	57496.00
#Swati	Desai	swati.desai@gmail.com	2	51498.00
#Rajesh	Kumar	rajesh.kumar@gmail.com	2	36595.00
#Anjali	Mehta	anjali.mehta@gmail.com	2	17598.00
#Ravi	Verma	Unknown4	2	10996.00
#Kavya	Reddy	Unknown4	2	5697.00
#Neha	Shah	neha.shah@gmail.com	2	5596.00
#Suresh	Patel	suresh.patel@outlook.com	2	5348.00

# Query 2: Product Sales Analysis (5 marks)

# Business Question: For each product category, show the category name, number of different products sold, total quantity sold, and
# total revenue generated. Only include categories that have generated more than ₹10,000 in revenue. Order by total revenue descending.

SELECT a.category, COUNT(DISTINCT a.product_name) AS number_of_products_sold,
    SUM(b.quantity) AS total_quantity_sold,
    SUM(b.quantity * b.unit_price) AS total_revenue
FROM 
    order_items b
    JOIN products a ON b.product_id = a.product_id
GROUP BY 
    a.category 
HAVING 
    SUM(b.quantity * b.unit_price) > 10000
ORDER BY 
    total_revenue DESC;

# OUTPUT
# category  number_of_products_sold total_quantity_sold total_revenue
#Electronics	9	25	550775.00
#Fashion	7	22	63878.00
#Groceries	4	42	18601.00

# Query 3: Monthly Sales Trend (5 marks)

# Business Question: "Show monthly sales trends for the year 2024. For each month, display the month name, total number of orders, 
#total revenue, and the running total of revenue (cumulative revenue from January to that month).
SELECT
    DATE_FORMAT(o.order_date, '%M') AS month_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * oi.unit_price) AS total_revenue,
    SUM(SUM(oi.quantity * oi.unit_price)) 
        OVER (ORDER BY DATE_FORMAT(o.order_date, '%M')) AS running_total_revenue
FROM 
    orders o
    JOIN order_items oi ON o.order_id = oi.order_id
WHERE 
    EXTRACT(YEAR FROM o.order_date) = 2024
GROUP BY 
    DATE_FORMAT(o.order_date, '%M')
ORDER BY 
    DATE_FORMAT(o.order_date, '%M');

# OUTPUT
#Month_Name total_order total_revenue running total_revenue
#April	6	84951.00	84951.00
#February	12	231231.00	316182.00
#January	9	133340.00	449522.00
#March	13	183732.00	633254.00