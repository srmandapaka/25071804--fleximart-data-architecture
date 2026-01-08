# FlexiMart Data Architecture Project

**Student Name:** Sriram Ravikanth Mandapaka
**Student ID:** bitsom_ba_25071804
**Email:** srmandapaka@gmail.com
**Date:** 07-JAN-2026

## Project Overview

##### I first built Python Code **etl_pipeline.ipynb** to do Extract, Transform and Load in **flipkart_bits** database using the 3 .CSV raw files given in assignment. Provided the database scheme details and sample data in tabular format in **schema_documentation.md** post that given business queries in **mysqlbusiness.sql** after loading the MYSQL extension in Python. Provided NOSQL analysis in **nosqlanalysis.md** with details about limitations of RDBMS, benefits of NOSQL, trade-offs along with loading of JSON file in MongoDB using **mongodb_operations.ipynb**. Finally, created **fleximart_dw** DB and tables for datawarehouse using **warehouse_schema.sql** and inserted data & queried in **warehouse_data.sql**     

## Repository Structure
├── part1-database-etl/
│   ├── etl_pipeline.py
│   ├── schema_documentation.md
│   ├── business_queries.sql
│   └── data_quality_report.txt
├── part2-nosql/
│   ├── nosql_analysis.md
│   ├── mongodb_operations.js
│   └── products_catalog.json
├── part3-datawarehouse/
│   ├── star_schema_design.md
│   ├── warehouse_schema.sql
│   ├── warehouse_data.sql
│   └── analytics_queries.sql
└── README.md

## Technologies Used

- Python 3.x, pandas, mysql-connector-python
- MySQL 8.0 / PostgreSQL 14
- MongoDB 6.0

## Setup Instructions

### Database Setup

```bash
# Create databases
mysql -u root -p -e "CREATE DATABASE flipkart_bits;"
mysql -u root -p -e "CREATE DATABASE fleximart_dw;"

# Run Part 1 - ETL Pipeline
python part1-database-etl/etl_pipeline.py

# Run Part 1 - Business Queries
mysql -u root -p fleximart < part1-database-etl/mysqlbusiness.sql

# Run Part 3 - Data Warehouse
mysql -u root -p fleximart_dw < part3-datawarehouse/warehouse_schema.sql
mysql -u root -p fleximart_dw < part3-datawarehouse/warehouse_data.sql
mysql -u root -p fleximart_dw < part3-datawarehouse/analytics_queries.sql


### MongoDB Setup

mongosh < part2-nosql/mongodb_operations.js

## Key Learnings

## Excellent real-time experience where we get the data and how to do ETL. We generally get the data from various combinations of transactional DB, ETL files, JSON files etc. so having done some of it will really associate the real-time problems and how to go about reading, cleasing the data, before loading the data in datawarehouse or datalake for performaing machine learning and AI aspects    

## Challenges Faced

1. # Syntax to the python first time around and also making sure what we got as a data, problem statement and how are we going about solving them  
2. # MongoDb along with JSON data management plus understanding the simplicity of what we can achieve with python extensions like MYSQL 