# Retail-operation-and-revenue-analysis
Retail Operations and Revenue Analysis is a MySQL-based analytics project focused on uncovering business insights from retail data. Using joins, CTEs, window functions, and customer segmentation, the project analyzes revenue trends, sales performance, product performance, and operational metrics to support data-driven decision-making.

# Project Structure
├── Retail_operation_and_revenue_analysis.sql
├── customers.csv
├── orders.csv
├── order_items.csv
├── products.csv
├── returns.csv
└── README.md

# Database Schema
The project uses five normalized tables that reflect a real retail data model. The customers table stores customer details including region and signup date. The orders table records each transaction linked to a customer. The order_items table captures the individual products within each order including quantity and unit price. The products table holds the product catalog with categories and pricing. The returns table logs returned items along with the reason for return.

# Queries & Business Questions
The project includes ten analytical queries, each addressing a specific business question. 
The first two look at monthly revenue trends and revenue broken down by region. 
Queries three and four identify the top ten highest-spending customers and the best-selling products by revenue. 
Query five segments customers into High, Medium, and Low value tiers based on total spend. 
Query six ranks product categories by revenue using a window function. 
Query seven calculates a running cumulative revenue total across all months. 
Query eight measures the return rate for each product category. 
Query nine finds repeat customers who have placed three or more orders. 
Query ten compares average order value across different regions.

# Key SQL Concepts Demonstrated

The project covers a range of SQL techniques including INNER and LEFT JOINs across multiple tables, aggregations using SUM, COUNT, and AVG with GROUP BY and HAVING clauses, CTEs for breaking complex logic into readable steps, window functions including RANK and cumulative SUM OVER for running totals and rankings, CASE statements for customer segmentation, and DATE_FORMAT for grouping data by month.

# Tools Used

MySQL was used for query execution and database management. MySQL Workbench was used for writing queries and viewing results.

# Author

Lionel Mendonsa
