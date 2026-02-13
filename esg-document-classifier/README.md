E-Commerce Business Analysis using PostgreSQL
=============================================

**Project Overview**
This project builds a complete end-to-end SQL analytics pipeline on a Brazilian e-commerce dataset. The objective is to design a structured relational database, perform data cleaning and validation, and generate actionable business insights using advanced SQL techniques.
The project demonstrates database design, data engineering, and business intelligence capabilities using PostgreSQL.

**Objectives**
Design normalized relational schema with constraints and indexes
Perform bulk data ingestion using COPY
Clean and validate raw transactional data
Compute key business KPIs
Perform time-series and revenue analysis
Analyze seller performance and customer lifecycle
Evaluate delivery performance and its impact on customer satisfaction

**Tools & Technologies**
PostgreSQL
SQL (Advanced queries & window functions)
Data validation & integrity checks
CTEs, Aggregations, Ranking functions

**Project Structure**
create.sql → Database schema creation with primary keys, foreign keys & indexes
load_dataset.sql → Bulk data loading using COPY
data_cleaning.sql → Data enrichment and transformation
data_validation.sql → Duplicate checks, null validation, integrity validation
business_analysis.sql → KPI computation and business insights

**Key KPIs Computed**
Revenue by category and state
Month-over-month revenue growth
Cumulative revenue trend
Average Order Value (AOV)
Customer Lifetime Value (CLV)
Seller revenue ranking
Cancellation rate
Low-review rate
Delivery delay impact on review score

**Key Business Insights**
High-revenue categories do not always correspond to high customer satisfaction.
Delivery delays are strongly correlated with low review scores.
Customer dissatisfaction is broadly distributed across sellers rather than concentrated in a few.
A small subset of sellers drive a significant share of state-level revenue.
Repeat customers represent a small but high-value segment.

**Advanced SQL Concepts Used**
Window functions (LAG, RANK, ROW_NUMBER, SUM OVER)
CTEs for structured analytics
Revenue contribution percentage analysis
Benchmarking using partitioned averages
Time-series trend analysis

**Dataset**
Brazilian E-Commerce Public Dataset (Olist).
Dataset not included in repository due to size constraints.

**Author**
Ashwani Kumar
Data Analyst | Business Intelligence | SQL
