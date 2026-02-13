E-Commerce Business Analysis using PostgreSQL
=============================================

**Project Overview**
This project builds a complete end-to-end SQL analytics pipeline on a Brazilian e-commerce dataset. The objective is to design a structured relational database, perform data cleaning and validation, and generate actionable business insights using advanced SQL techniques.
The project demonstrates database design, data engineering, and business intelligence capabilities using PostgreSQL.

**Objectives**
1. Design normalized relational schema with constraints and indexes
2. Perform bulk data ingestion using COPY
3. Clean and validate raw transactional data
4. Compute key business KPIs
5. Perform time-series and revenue analysis
6. Analyze seller performance and customer lifecycle
7. Evaluate delivery performance and its impact on customer satisfaction

**Tools & Technologies**
1. PostgreSQL
2. SQL (Advanced queries & window functions)
3. Data validation & integrity checks
4. CTEs, Aggregations, Ranking functions

**Project Structure**
1. create.sql → Database schema creation with primary keys, foreign keys & indexes
2. load_dataset.sql → Bulk data loading using COPY
3. data_cleaning.sql → Data enrichment and transformation
4. data_validation.sql → Duplicate checks, null validation, integrity validation
5. business_analysis.sql → KPI computation and business insights

**Key KPIs Computed**
1. Revenue by category and state
2. Month-over-month revenue growth
3. Cumulative revenue trend
4. Average Order Value (AOV)
5. Customer Lifetime Value (CLV)
6. Seller revenue ranking
7. Cancellation rate
8. Low-review rate
9. Delivery delay impact on review score

**Key Business Insights**
1. High-revenue categories do not always correspond to high customer satisfaction.
2. Delivery delays are strongly correlated with low review scores.
3. Customer dissatisfaction is broadly distributed across sellers rather than concentrated in a few.
4. A small subset of sellers drive a significant share of state-level revenue.
5. Repeat customers represent a small but high-value segment.

**Advanced SQL Concepts Used**
1. Window functions (LAG, RANK, ROW_NUMBER, SUM OVER)
2. CTEs for structured analytics
3. Revenue contribution percentage analysis
4. Benchmarking using partitioned averages
5. Time-series trend analysis

**Dataset**
Brazilian E-Commerce Public Dataset (Olist).
Note: Dataset not included in repository due to size constraints.

**Author**
Ashwani Kumar
Data Analyst | Business Intelligence | SQL
