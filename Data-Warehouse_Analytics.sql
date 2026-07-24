USE DataWarehouseAnalytics
GO
---Changes Over Time
SELECT FORMAT(order_date, 'yyyy-MMM') as date_year, sum(sales_amount) as total_sales,
COUNT(DISTINCT customer_key) as total_customer, SUM(quantity) as total_quantity
from dbo.fact_sales
where order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'yyyy-MMM')
ORDER BY FORMAT(order_date, 'yyyy-MMM')

---Cumluative Analysis, (proggression over time)
SELECT 
order_date, 
total_sales,
SUM(total_sales) OVER (PARTITION BY order_date ORDER BY order_date) AS running_total_sales,
AVG(avg_price) OVER (PARTITION BY order_date ORDER BY order_date) AS moving_avg_price
FROM
(
SELECT DATETRUNC(MONTH,order_date) order_date, SUM(sales_amount) as total_sales,
AVG(price) as avg_price
FROM dbo.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH,order_date)
) t

/*Performance Analysis, 
(analyzing yearly performance of products by comparing their sales to both the average sales performance and the previous year sales)
*/
WITH yearly_prodcut_sales AS (
SELECT 
YEAR(f.order_date) as Order_year, p.product_name, SUM(f.sales_amount) as Current_sales
FROM dbo.fact_sales f
LEFT JOIN dbo.dim_products p
ON f.product_key = p.product_key
WHERE f.order_date IS NOT NULL
GROUP BY YEAR(f.order_date),p.product_name
)
SELECT  
Order_year,
product_name,
Current_sales,
AVG(Current_sales) OVER (PARTITION BY product_name) AS avg_sales,
Current_sales - AVG(Current_sales) OVER (PARTITION BY product_name) AS diff_avg,
CASE WHEN Current_sales - AVG(Current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Average'
     WHEN Current_sales - AVG(Current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Average'
     ELSE 'Average'
END 'Avg', 
---Year-Over-Year Analysis
LAG(Current_sales) OVER (PARTITION BY product_name ORDER BY Order_year) py_sales,
Current_sales - LAG(Current_sales) OVER (PARTITION BY product_name ORDER BY Order_year) diff_py,
CASE WHEN LAG(Current_sales) OVER (PARTITION BY product_name ORDER BY Order_year) > 0 THEN 'Increasing'
     WHEN LAG(Current_sales) OVER (PARTITION BY product_name ORDER BY Order_year) < 0 THEN 'Decreasing'
     ELSE 'No Change'
END py_change
FROM yearly_prodcut_sales
ORDER BY product_name, Order_year

/*---Part-To-Whole Analysis 
(Analyze how an individual part is performing ccompared to the overall, to understand which catagory have the greatest impact on the company)
*/
WITH category_sales AS (
SELECT
category,
SUM(sales_amount) total_sales
FROM dbo.fact_sales f
LEFT JOIN dbo.dim_products p
ON f.product_key = p.product_key
GROUP BY category)

SELECT
category,
total_sales,
SUM(total_Sales) OVER () overall_sales,
CONCAT(ROUND((CAST(total_sales AS FLOAT)/SUM(total_Sales) OVER ())*100, 2),'%') AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC

---Data Segmentation (Group the data based on a specific range. Helps understand the correlation between two measures.)

/*segment products into cost range and count how many product fall into each segment*/
WITH product_segments AS (
SELECT
product_key,
product_name,
cost,
CASE WHEN cost < 100 THEN 'Below 100'
     WHEN cost BETWEEN 100 AND 500 THEN '100-500'
     WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
     ELSE 'Above 1000'
END cost_range
FROM dbo.dim_products)

SELECT
cost_range,
COUNT(product_key) total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC

/*Group customers into three segments based in their spending behaviour:
- VIP: Customers with at least 12 months of history and spending more than $5,000.
- Regular: Customers with at least 12 months of history but spending $5,000 or less.
- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/
WITH customer_spending AS (
SELECT 
c.customer_key,
SUM(sales_amount) AS total_spending,
MIN(order_date) AS first_month,
MAX(order_date) AS last_month,
DATEDIFF(MONTH, MIN(order_Date), MAX(order_Date)) as lifespan
FROM dbo.fact_sales f
LEFT JOIN dbo.dim_customers c 
ON f.customer_key = c.customer_key
GROUP BY c.customer_key
)

SELECT
customer_segments,
COUNT(customer_key) AS total_customers
FROM (
      SELECT
      customer_key,
      CASE WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
           WHEN lifespan >=12 AND total_spending <= 5000 THEN 'Regular'
           ELSE 'NEW'
      END customer_segments
      from customer_spending) t

GROUP BY customer_segments
ORDER BY total_customers DESC

/* 
Customer Report:
This report consolidates key customer metrics and behaviours

Highlights: 
1. Gathers essential fields such as names, ages, and transaction details.
2. segments customers into categories (VIP, Regular, New) and age groups.
3. Aggregates customer level metrics:
- total orders
- total quantity purchased
- total products
- lifespan (in months)
4. Calculates valuable KPIs
- recency(months since last order)
*/
CREATE VIEW dbo.report_customers AS
WITH base_query AS (
SELECT 
    f.order_number,
    f.product_key,
    f.order_date,
    f.sales_amount,
    c.customer_key,
    c.customer_number,
    CONCAT(c.first_name,' ',c.last_name) AS customer_name,
    DATEDIFF(year, c.birthdate, GETDATE()) age
    FROM dbo.fact_sales f
    LEFT JOIN dbo.dim_customers c
    ON c.customer_key = f.customer_key
    WHERE order_date IS NOT NULL)

,customer_aggregation AS (
SELECT 
    customer_key,
    customer_number,
    customer_name,
    age,
    COUNT (DISTINCT order_number) AS total_orders,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT product_key) AS total_products,
    MAX(order_date) AS last_order_date,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan
FROM base_query
GROUP BY 
    customer_key,
    customer_number,
    customer_name,
    age)

SELECT
customer_key,
customer_number,
customer_name,
age,
CASE WHEN age < 20 THEN 'Under 20'
     WHEN age BETWEEN 20 AND 29 THEN '20-29'
     WHEN age BETWEEN 30 AND 39 THEN '30-39'
     WHEN age BETWEEN 40 AND 49 THEN '40-49'
     ELSE '50 and Above'
END age_group,
CASE WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
     WHEN lifespan >=12 AND total_sales <= 5000 THEN 'Regular'
     ELSE 'NEW'
END customer_segments,
last_order_date,
DATEDIFF(MONTH, last_order_date, GETDATE()) AS recency,
total_orders,
total_sales,
total_products,
lifespan,
---computate avg order value
CASE WHEN total_sales=0 THEN 0
     ELSE total_sales/total_orders
END AS avg_order_value,
---computate avg monthly spend
CASE WHEN lifespan = 0 THEN total_sales
     ELSE total_sales / lifespan
END AS avg_montly_spend
from customer_aggregation

/*Customer Report:
This report consolidates key product metrics and behaviours
*/
CREATE VIEW dbo.report_product AS 
WITH base_query AS (
SELECT f.order_number,
       f.order_date,
       f.customer_key,
       f.sales_amount,
       f.quantity,
       p.product_key,
       p.product_name,
       p.category,
       p.subcategory,
       p.cost
FROM dbo.fact_sales f
LEFT JOIN dbo.dim_products p 
     ON f.product_key = p.product_key
WHERE order_date IS NOT NULL 
)

,product_aggregations AS (

SELECT product_key,
       product_name,
       category,
       subcategory,
       cost,
       DATEDIFF(MONTH, MIN(order_date), MAX(order_Date)) AS lifespan,
       MAX(order_date) AS last_sale_date,
       COUNT(DISTINCT order_number) AS total_orders,
       COUNT(DISTINCT customer_key) AS total_customers,
       SUM(sales_amount) AS total_sales,
       SUM(quantity) AS total_quantity,
       ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity,0)),1) AS avg_selling_price
FROM base_query
GROUP BY 
       product_key,
       product_name,
       category,
       subcategory,
       cost
)

SELECT
     product_key,
     product_name,
     category,
     subcategory,
     cost,
     last_sale_date,
     DATEDIFF(MONTH, last_sale_date, GETDATE()) AS recency_in_months,
     CASE WHEN total_sales > 50000 THEN 'High-Performer'
          WHEN total_sales >= 10000 THEN 'Mid-range'
          ELSE 'Low-Performer'
    END AS product_segment,
    lifespan,
    total_orders,
    total_sales,
    total_quantity,
    total_customers,
    avg_selling_price,
    ---Average Order Revenue
    CASE WHEN total_orders = 0 THEN 0
         ELSE total_sales / total_orders
    END AS avg_order_revenue,

    ---Average Monthly Revenue
    CASE WHEN lifespan = 0 THEN total_sales
         ELSE total_sales / lifespan
    END AS avg_monthly_revenue

FROM product_aggregations

