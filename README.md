# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `sql_project_1`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

5. ## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `sql_project_1`.
- **Table Creation**: A table named `sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE sql_project_1;

CREATE TABLE sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.
- 
```sql
select * from sales limit 10

select count(*) from sales

-- checking null values:
select * from sales
where transactions_id is null;

select * from sales
where sale_date is null;

select * from sales
where 
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or
	gender is null
	or
	age is null
	or
	category is null
	or
	quantiy is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null

--Average age:
select round(avg(age)) from sales;


update sales
set age = (
	select round(avg(age)) from sales
)
where age is null;

-- Remove the null vales:
delete from sales
where 
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or
	gender is null
	or
	age is null
	or
	category is null
	or
	quantiy is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null;

```

### 3. Data Analysis:

-- How many sales we have?
```sql 
select count(*) as total_sales from sales;
```

-- How many unique customers we have?
```sql 
select count(distinct customer_id) as total_customers from sales;
```

-- How many unique categories we have and Names?
```sql 
select count(distinct category) as unique_categories from sales;
```

```sql
select distinct category as categories_names from sales;
```

### 4. Data Analysis & Findings:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
  select * 
  from sales 
  where sale_date = '2022-11-05'
```
2. **2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
select * 
from sales
where category = 'Clothing'
	and
	quantiy >=4
	and 
	TO_CHAR(sale_date,'YYYY-MM') = '2022-11';
```
3. **Write a SQL query to calculate the total sales (total_sale) for each category?**:
```sql
select  
	category,
	sum(total_sale) as total_sales,
	count(*) as total_orders
from sales 
group by category;
```
4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category**:
```sql
select  round(avg(age)) as average_age from sales where category = 'Beauty';
```
5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
select * from sales where total_sale > 1000;
```
6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each categ**:
```sql
select gender,category,count(*) as total_transactios 
from sales 
group by gender,category 
order by count(*) desc;
```
7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
select year,month,average_sales
from (
	select  
		EXTRACT(YEAR FROM sale_date) as year,
		EXTRACT(MONTH FROM sale_date) as month,
		round(avg(total_sale)) as average_sales,
		rank() over(partition by EXTRACT(YEAR FROM sale_date) order by round(avg(total_sale)) desc) as rnk
	from sales
	group by year,month) as t1
where rnk = 1;
```
8. **Write a SQL query to find the top 5 customers based on the highest total sales**:
```sql
select customer_id,sum(total_sale) as total_sales
from sales
group by customer_id
order by sum(total_sale) desc 
limit 5;
```
9. **Write a SQL query to find the number of unique customers who purchased items from each category**:
```sql
select category, count(distinct(customer_id)) as unique_customer 
from sales
group by category;
```
10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
WITH cte_hourly 
as(
	select *,
		CASE
			WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
			WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		END as shift	
	from sales
)
select 
	shift,
	count(*) as total_orders 
from cte_hourly 
group by shift 
order by total_orders
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.
