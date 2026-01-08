# Query 1: Monthly Sales Drill-Down Analysis (5 marks)
USE fleximart_dw

SELECT
    d.year,
    d.quarter,
    d.month,
    SUM(f.total_amount) AS total_sales,
    SUM(f.quantity_sold) AS total_quantity
FROM fact_sales f
JOIN dim_date d 
    ON f.date_key = d.date_key
WHERE d.year = 2024
GROUP BY
    d.year,
    d.quarter,
    d.month
ORDER BY
    d.year,
    d.quarter,
    d.month;


#Query 2: Product Performance Analysis (5 marks)

SELECT
    p.product_name,
    p.category,
    SUM(f.total_amount) AS total_revenue,
    SUM(f.quantity_sold) AS total_quantity,
    ROUND(
        SUM(f.total_amount) * 100.0 
        / SUM(SUM(f.total_amount)) OVER (), 
        2
    ) AS revenue_percentage
FROM fact_sales f
JOIN dim_product p 
    ON f.product_key = p.product_key
GROUP BY
    p.product_name,
    p.category
ORDER BY
    total_revenue DESC
LIMIT 10;

# Query 3: Customer Segmentation Analysis (5 marks)

WITH customer_totals AS (
    SELECT
        c.customer_key,
        c.customer_name,
        SUM(f.total_amount) AS total_spent
    FROM fact_sales f
    JOIN dim_customer c 
        ON f.customer_key = c.customer_key
    GROUP BY
        c.customer_key,
        c.customer_name
),
segmented AS (
    SELECT
        customer_key,
        customer_name,
        total_spent,
        CASE
            WHEN total_spent > 50000 THEN 'High Value'
            WHEN total_spent BETWEEN 20000 AND 50000 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS segment
    FROM customer_totals
)
SELECT
    segment,
    COUNT(*) AS customer_count,
    SUM(total_spent) AS total_revenue,
    ROUND(AVG(total_spent), 2) AS avg_revenue_per_customer
FROM segmented
GROUP BY segment
ORDER BY 
    CASE segment
        WHEN 'High Value' THEN 1
        WHEN 'Medium Value' THEN 2
        WHEN 'Low Value' THEN 3
    END;