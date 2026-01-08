# Task 3.1: Star Schema Design Documentation (10 marks) - 1 hour
## Section 1: Schema Overview (4 marks)

The star schema is organized around a central fact table called fact_sales, which captures the detailed activity of the sales process. The grain of this table is defined as one row per product per order line item, meaning each record represents a single product sold within a specific order. This table supports analysis of the sales business process by storing the key quantitative measures associated with each transaction.
The fact_sales table contains several numeric facts
- quantity_sold, representing the number of units purchased in the line item
- unit_price, the price of the product at the moment of sale
- discount_amount, the discount applied to that line item
- total_amount, the final calculated amount after applying quantity, price, and discount
To provide analytical context, the fact table links to three dimension tables through foreign keys: date_key, product_key, and customer_key. These keys connect each sales transaction to the date it occurred, the product being sold, and the customer who made the purchase.
One of the key supporting dimensions is dim_date, a conformed date dimension used consistently across the warehouse for all time-based reporting. Each row in dim_date represents a single calendar date and is identified by a surrogate primary key, date_key, formatted as an integer in the style YYYYMMDD. The dimension includes rich descriptive attributes such as the actual date (full_date), the day of the week, numeric month, month name, quarter, year, and a Boolean flag indicating whether the date falls on a weekend. These attributes enable flexible slicing, filtering, and trend analysis across different time periods.
Together, the fact_sales table and its associated dimensions form a classic star schema that supports efficient analytical queries, allowing users to explore sales performance across time, products, and customers with speed and clarity.

## Section 2: Design Decisions (3 marks - 150 words)

### i. Why This Granularity (Transaction Line‑Item Level)

Choosing the grain of one row per product per order line item is intentional because:
#### a. It captures the most detailed level of sales activity
Every product sold with an order is represented individually. This allows us to:
- Measure exact quantities sold
- Track discounts applied at the line level
- Analyze pricing variations over time
- Understand product‑level performance within each order
#### b. It preserves full analytical flexibility
With the lowest level of detail stored, we can always aggregate upward later.
If we store only order‑level summaries, we would lose:
- Product‑level insights
- Multi‑product order breakdowns
- Line‑level discount behavior
#### c. It aligns with dimensional modeling principles. The recommendation is to choose the lowest possible grain so the fact table supports:
- Accurate aggregations
- Detailed drill‑downs
- Future analytical needs without redesign
This grain ensures the model remains robust as business questions evolve.

### ii. Why Surrogate Keys Instead of Natural Keys
Surrogate keys are used instead of natural keys for several reasons:
#### a. Natural keys change — surrogate keys do not
Real‑world identifiers like product codes or customer emails can change. Surrogate keys remain stable, ensuring:
- Historical accuracy
- No broken relationships
- No cascading updates
#### b. Surrogate keys support Slowly Changing Dimensions (SCD)
When a dimension changes (like customer moves to a new city), we can create a new dimension row with a new surrogate key.
This preserves history cleanly.
#### c. Surrogate keys improve performance
Integer keys:
- Join faster
- Index more efficiently
- Reduce storage footprint
#### d. They avoid messy or composite natural keys
Natural keys may be:
- Long strings
- Multi‑column combinations
- Inconsistent across systems
Surrogate keys give the warehouse a clean, uniform structure.

### iii. How This Design Supports Drill‑Down and Roll‑Up Operations
The star schema is built specifically to support OLAP-style navigation:
#### a. Drill‑down (more detail)
Because the fact table is at the lowest grain, users can drill down into:
- Year → Quarter → Month → Day (via dim_date)
- Category → Product (via dim_product)
- Customer segment → Customer (via dim_customer)
- Order → Line item
The detailed grain makes this possible.
#### b. Roll‑up (higher-level summaries)
Aggregations can be rolled up easily because dimensions contain hierarchical attributes:
- dim_date: day → month → quarter → year
- dim_product: SKU → category → department
- dim_customer: customer → region → country
The fact table’s atomic grain ensures all roll‑ups are accurate and consistent.
#### c. Star schema simplifies aggregation paths
Since all dimensions connect directly to the fact table:
- No complex joins
- No snowflake dependencies
- Fast group‑by operations
This is exactly why star schemas are preferred for BI workloads.

## Section 3: Sample Data Flow (3 marks)

Here’s a step‑by‑step sample data flow showing exactly how a single transaction moves from the source system → staging → dimensions → fact table in our star schema. 

### Sample Data Flow: Source → Data Warehouse (Star Schema)
Below is the original transaction from the OLTP system:
Source Transaction (OLTP)
|Field | Value |
|---   | ----|
|Order ID | 101|
| Order Date | 2024-01-15
|Customer Name | John Doe|
|Product | laptop|
|Quantity | 2|
|Unit Price | 50,000|

### 1. Extract (Source → Staging Layer)
First, the raw data is copied into a staging table without transformation:
stg_orders
|order_id  |order-date  |customer_name  |product_name  |qty  |price  | 
|---       |---         | ---           |---           |---  |---  | 
|101 | 2024-01-15 | john Doe | Laptop | 2 | 50000 |

Staging is used to clean, validate, and prepare data before loading into dimensions and facts.

### 2. Transform (Dimension Lookups & Surrogate Key Assignment)
a. Date Dimension Lookup
- Order Date = 2024‑01‑15
- Convert to surrogate key → 20240115
If the date doesn’t exist, ETL inserts it.

b. Product Dimension Lookup
Lookup “Laptop” in dim_product:
|product_key  |product_name  |category  | 
|---          |---           |---       |
|5 | laptop | Electronics 

→ Surrogate key found: product_key = 5

c. Customer Dimension Lookup
Lookup “John Doe” in dim_customer:
|customer_key|customer_name|city| 
|---         |---          |--  |
|12 | John Doe | Mumbai

→ Surrogate key found: customer_key = 12

### 3. Load Dimensions (If Needed)
If any dimension row is missing, ETL inserts it.
dim_date
{
  "date_key": 20240115,
  "full_date": "2024-01-15",
  "day_of_week": "Monday",
  "month": 1,
  "month_name": "January",
  "quarter": "Q1",
  "year": 2024,
  "is_weekend": false
}


dim_product
{
  "product_key": 5,
  "product_name": "Laptop",
  "category": "Electronics"
}


dim_customer
{
  "customer_key": 12,
  "customer_name": "John Doe",
  "city": "Mumbai"
}

### 4. Load Fact Table (fact_sales)
Now that all surrogate keys are available, ETL loads the fact row:
fact_sales
{
  "date_key": 20240115,
  "product_key": 5,
  "customer_key": 12,
  "quantity_sold": 2,
  "unit_price": 50000,
  "discount_amount": 0,
  "total_amount": 100000
}


This row now links to all three dimensions.

### 5. Final Star Schema View
fact_sales
|data_key|product_key|customer_key|qty|unit_price|total_amount| 
|---     |---        |---         |---|---       |----------  | 
|20240115|5|12|2|50000|100000|

dim_date
(date_key = 20240115 → January 15, 2024)
dim_product
(product_key = 5 → Laptop)
dim_customer
(customer_key = 12 → John Doe)

### 6. How BI Tools Use This
Because the fact row is linked to rich dimensions, analysts can instantly answer:
- Sales by month
- Sales by product category
- Sales by customer region
- Average selling price
- Revenue trends over time
All from this single transaction flowing correctly through the star schema.