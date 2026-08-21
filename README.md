# SQL Analytics & Data Warehouse Reporting Engine

## Overview

This project focuses on advanced business intelligence (BI) analytics, data segmentation, exploratory data analysis (EDA), and automated reporting views built on a SQL Server Data Warehouse architecture. Utilizing structured star-schema tables (`dbo.fact_sales`, `dbo.dim_customers`, and `dbo.dim_products`), the SQL scripts compute critical KPI metrics, customer and product lifetime values, cumulative growth trends, and multi-tier data segmentations to power business decision-making.

---

## Technical Highlights & Analytical Use Cases

- **Time Series & Cumulative Analysis:** Aggregated monthly sales, running totals (`SUM OVER`), and moving price averages (`AVG OVER`).
- **Year-over-Year (YoY) & Performance Comparison:** Applied window functions (`LAG`, `PARTITION BY`) to track YoY changes and flag products performing above or below average.
- **Part-to-Whole Analysis:** Evaluated category impact relative to overall revenue using percentage calculations.
- **Data Segmentation Models:** Classified products by cost tiers and segmented customers into `VIP`, `Regular`, and `New` tiers based on revenue and account lifespan.
- **Automated Reporting Views:** Built `dbo.report_customers` and `dbo.report_product` views calculating Recency, Lifespan, Average Order Value (AOV), Monthly Spend, and Product Performance tiers.

---

## Technologies Used

- **Database:** Microsoft SQL Server
- **Language:** T-SQL (Transact-SQL)
- **Tooling:** SQL Server Management Studio (SSMS)

---

## Advanced Technical Skills

- Window Functions (`SUM`, `AVG`, `LAG`, `PARTITION BY`)
- Common Table Expressions (CTEs)
- Database Views (`CREATE VIEW`)
- Data Segmentation & Bucketing (`CASE WHEN`)
- KPI Calculation (Recency, Lifespan, AOV, Monthly Spend)
- Conditional Aggregations & Joins (`LEFT JOIN`)
- Advanced Date Functions (`DATEDIFF`, `DATETRUNC`, `FORMAT`)

---

## Repository Structure

```text
.
├── scripts/
│   ├── analytics/
│   │   ├── changes_over_time.sql
│   │   ├── cumulative_analysis.sql
│   │   ├── performance_analysis.sql
│   │   ├── part_to_whole_analysis.sql
│   │   └── data_segmentation.sql
│   └── views/
│       ├── report_customers.sql
│       └── report_product.sql
└── README.md

- Data Warehousing
- Star Schema Design
- Fact & Dimension Modeling
- ETL Pipeline Development
- Data Transformation
- Reporting View Creation
- Common Table Expressions (CTEs)
- SQL Joins & Aggregations
- Business Intelligence Fundamentals

---

## Project Architecture

```text
Raw Data
    │
    ▼
Bronze Layer
    │
    ▼
Silver Layer
    │
    ▼
Gold Layer
    │
    ▼
Reporting Views
    │
    ▼
Business Intelligence & Analytics
```

---

## Repository Structure

```text
.
├── datasets/
├── scripts/
│   ├── bronze/
│   ├── silver/
│   ├── gold/
│   └── reporting/
└── README.md
```

---

## Acknowledgement

This project is an implementation of the **SQL Data Warehouse Project** by **Data With Baraa**, completed for learning and portfolio purposes.

Original repository:
https://github.com/DataWithBaraa/sql-data-warehouse-project
