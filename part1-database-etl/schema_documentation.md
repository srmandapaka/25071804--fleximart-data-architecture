
# Entity-Relationship Description (Text Format)

## ENTITY: customers
### Purpose: Stores customer information
#### Attributes:
  1. customer_id: Unique identifier (Primary Key)
  2. first_name: Customer's first name
  3. last_name: Customer's last name
  4. email: Customer's email address
  5. phone: Customer's phone
  6. city: Customer's city
  7. registration_date: Customer's registration date

#### Relationships:
  1. One customer can place MANY orders (1:M with orders table)

## ENTITY: products
### Purpose: Stores products information
#### Attributes:
  1. product_id: Unique identifier (Primary Key)
  2. product_name: Product's name
  3. category: Product's category
  4. price: Product's price
  5. stock_quantity: Product's quantity that is available in the stock

#### Relationships:
  1. One product can be part of many orders (1:M with orders table)
  2. one order can have many products (M:1 with orders table)

## ENTITY: orders
### Purpose: Stores order information 
#### Attributes:
  1. order_id: Unique identifier (Primary Key)
  2. customer_id: Customer's id (Foreign key)
  3. order_date: Customer's order date 
  4. total_amount: Order's total amount

#### Relationships:
  1. One customer can have many orders (1:M with orders table) 

## ENTITY: order_items
### Purpose: Order details  
#### Attributes:
  1. order_item_id: Unique identifier (Surrogate Key)
  2. order_id: Order's id (Foreign key)
  3. product_id: Product's id (Foreign key) 
  4. quantity: quantity (number of products) in the order 
  5. unit_price: total price per unit
  6. subtotal: subtotal (creating by total_amount dividing with 2)

#### Relationships:
  1. order items have one to one relationship with orders (1:1 with orders table)
  2. order items have one to many relationship with products (1:M)


#  Normalization Explanation

## Explain why this design is in 3NF
#### For the database design to be 3NF it needs to meet at least 2NF. And for it need to to be 2NF, it needs to meet at least 1NF.

##### How the database design is meeting 1NF
If we look at the tables, customer table, products table, orders table, order_items table, all of them are containing each row as unique with no 1 to many. For e.g.,customer holding one phone number even though customer's can have more than one phone number, but the phone numbers are not getting added against one customer at row level.

##### How the database design is meeting 2NF
If we look at all tables that were mentioned above, all non-key attributes depend on the **entire** primary key with no partial dependencies. if we take products table, we clearly have all product categories/names against the product_id. And there were no scenarios where order_items having the product categories, names in that, as these details are pertinant to product level hence didn't present in the order_items table  

##### How the database design is meeting 3NF
If we see the above tables, no non-key attributes depend on other non-key attributes (meaning no transitive dependencies). For e.g., if we see the order_items, we don't see quantity dependent on (say) product_id, as it is quantity ordered by customer so we have ensured this is taken care. 


# Sample Data Representation
---
## customers table
|customer_id|first_name|last_name|email|phone|city|registration_date|
|---        |---       |---      |---  |---  |--- |---
|1	| Rahul	| Sharma	| rahul.sharma@gmail.com |  	+919876543210|	Bangalore |	2023-01-15
|2	| Priya	| Patel    |priya.patel@yahoo.com |	+919988776655	| Mumbai| 	2023-02-20
|3	|Amit	|Kumar	|Unknown4	|+919765432109	|Delhi |2023-03-10 

## products table 
|product_id|product_name|category|price|stock_quantity|
|---       |---         |---     |---  |---           |
|1	| Samsung Galaxy S21	| Electronics	| 45999.00 |  	150|
|2	| Nike Running Shoes	| Fashion    |3499.00 |	80 |
|3	|Apple MacBook Pro	|Electronics	|2999.00	|45	|

## orders table 
|order_id|customer_id|order_date|total_amount|status|
|---       |---         |---     |---  |---           |
|1	| 1	| 2024-01-15	| 45999.00 |  	Completed|
|2	| 2	| 2024-01-16    | 5998.00 |	Completed |
|3	| 3	| 2024-01-15	| 52999.00	|Completed	|

## order_items table
|order_item_id|order_id|product_id|quantity|unit_price|sutotal|
|---        |---       |---      |---  |---  |--- 
|83	| 8	| 3	| 1 |  1299.00|	649.50 
|253	| 25	| 3    |1 |	1999.00	| 999.50
|1001	|1	|1	|1	|45999.00	|22999.5 