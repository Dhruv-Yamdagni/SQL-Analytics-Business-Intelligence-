# SQL Analytics & Business Intelligence Engine

## Overview

This project implements an advanced SQL analytics engine designed to extract actionable business intelligence from dimensional data models (`dbo.fact_sales`, `dbo.dim_customers`, and `dbo.dim_products`). It covers key analytical patterns, including cumulative trend analysis, Year-over-Year (YoY) performance tracking, multi-tier data segmentation, and production-ready reporting views for customer and product metrics[cite: 1].

---

## Project Objectives

- Perform time-series and cumulative growth analysis on sales metrics[cite: 1].
- Track YoY product performance against historical averages[cite: 1].
- Conduct part-to-whole analysis to determine category revenue impact[cite: 1].
- Segment customers and products based on lifetime spend, age, and cost ranges[cite: 1].
- Build reusable database reporting views (`dbo.report_customers` and `dbo.report_product`) to calculate core business KPIs[cite: 1].

---

## Technical Skills Applied

- **Window Functions:** `SUM() OVER()`, `AVG() OVER()`, `LAG()`[cite: 1]
- **Common Table Expressions (CTEs):** Multi-step aggregation pipelines[cite: 1]
- **Database Views:** `CREATE VIEW` for modular reporting[cite: 1]
- **Data Segmentation & Conditional Logic:** Multi-condition `CASE WHEN` statements[cite: 1]
- **KPI Calculations:** Recency, Account Lifespan, Average Order Value (AOV), Monthly Spend, Average Selling Price[cite: 1]
- **Date & Time Manipulation:** `DATETRUNC()`, `DATEDIFF()`, `FORMAT()`, `YEAR()`[cite: 1]
- **Relational Joins:** `LEFT JOIN` on star-schema keys[cite: 1]

---

## Key Analytics & Reports Included

### 1. Analytical Queries
- **Changes Over Time:** Monthly sales, distinct customer counts, and product quantities[cite: 1].
- **Cumulative Analysis:** Running sales totals and moving average prices using window partitioning[cite: 1].
- **Performance & YoY Analysis:** Product sales performance relative to overall product averages and prior-year sales (`LAG`)[cite: 1].
- **Part-To-Whole Analysis:** Percentage contribution of each product category to total sales[cite: 1].
- **Data Segmentation:** Product distribution across cost tiers and customer grouping (`VIP`, `Regular`, `New`)[cite: 1].

### 2. Business Reporting Views
- **Customer Insights View (`dbo.report_customers`):** Aggregates customer order history, age groups, tiering (`VIP`, `Regular`, `New`), recency in months, lifespan, AOV, and average monthly spend[cite: 1].
- **Product Insights View (`dbo.report_product`):** Tracks product category performance, sales recency, performance tiering (`High-Performer`, `Mid-range`, `Low-Performer`), order revenue, and average selling price[cite: 1].

---

## Technologies Used

- **Database Management System:** Microsoft SQL Server[cite: 1]
- **Query Language:** T-SQL (Transact-SQL)[cite: 1]
- **Development Environment:** SQL Server Management Studio (SSMS)[cite: 1]

---

## Repository Structure

```text
.
├── datasets/
├── docs/
├── scripts/
├── Data-Warehouse_Analytics.sql
└── README.md
