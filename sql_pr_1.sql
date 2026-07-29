
-- create Table

create table sales(
		transactions_id	int primary key,
		sale_date date,
		sale_time time,
		customer_id	int,
		gender varchar(10),
		age	int,
		category varchar(50),
		quantiy	int,
		price_per_unit float,
		cogs float,
		total_sale float

);

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



-- Data Exploration:


-- How many sales we have?
select count(*) as total_sales from sales;

-- How many unique customers we have?
select count(distinct customer_id) as total_customers from sales;

-- How many unique categories we have and Names?
select count(distinct category) as unique_categories from sales;

select distinct category as categories_names from sales;

-- Data Analysis:
select * from sales

-- 1.Write a SQL query to retrieve all columns for sales made on '2022-11-05:
select * 
from sales 
where sale_date = '2022-11-05'

-- 2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and 
--the quantity sold is more than 4 in the month of Nov-2022:
select * 
from sales
where category = 'Clothing'
	and
	quantiy >=4
	and 
	TO_CHAR(sale_date,'YYYY-MM') = '2022-11';

-- 3.Write a SQL query to calculate the total sales (total_sale) for each category?
select  
	category,
	sum(total_sale) as total_sales,
	count(*) as total_orders
from sales 
group by category;

-- 4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
select  round(avg(age)) as average_age from sales where category = 'Beauty'

-- 5.Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from sales where total_sale > 1000;

-- 6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender 
--in each category
select gender,category,count(*) as total_transactios 
from sales 
group by gender,category 
order by count(*) desc;

-- 7.Write a SQL query to calculate the average sale for each month. 
--Find out best selling month in each year
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

-- 8.**Write a SQL query to find the top 5 customers based on the highest total sales

select customer_id,sum(total_sale) as total_sales
from sales
group by customer_id
order by sum(total_sale) desc 
limit 5;

-- 9.Write a SQL query to find the number of unique customers who purchased items from each category
select category, count(distinct(customer_id)) as unique_customer 
from sales
group by category;

-- 10.Write a SQL query to create each shift and number of orders (
--Example Morning <12, Afternoon Between 12 & 17, Evening >17)
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

---END PROJECT---

