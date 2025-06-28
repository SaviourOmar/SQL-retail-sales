-- SQL - Retail Sales Analysis
create database SQLproject1;
use SQLproject1;
sales
-- create table
drop table if exists sales ;
create table sales (
transactions_id int primary key,	
sale_date date, 	
sale_time time,	
customer_id int,
gender varchar (15),	
age int,	
category varchar(15),	
quantiy int,	
price_per_unit float,	
cogs float,	
total_sale float
);

select*from sales ;

-- count of rows
select count(*) as count_rows from sales ;

-- checking for null values
select*from sales 
where sale_date is null 
or sale_date is null
or sale_time is null
or customer_id is null
or gender is null
or category is null
or quantiy is null
or cogs is null
or total_sale is null;

-- rename column
alter table sales
rename column quantiy to quantity;

-- DATA EXPLORATION
-- HOW MANY SALES MADE
select count(*) from sales;

-- number of unqiue customers
select count(distinct customer_id) as total_customers from sales; 

 select distinct category from sales;

-- SOLVING BUSINESS KEY PROBLEMS
select* from sales;
-- 1. write a query to retrieve all columns for sales made on "2022-11-05"
select* from sales
where sale_date = '2022-11-05';

-- write a query to retrieve where the category is clothes and quantity sold is more than 3 and in the month of nov-2022

select *
from sales
where category = 'clothing'
and
sale_date like '2022-11%'
and
quantity > 3
;

-- write query to  calculate the total sales for each category
select category, 
sum(total_sale) as net_sale,
count(*) as total_orders from sales
group by category;

# write query to find average age of customer who purchased from the beauty category

select round(avg(age),2) as Average_age_baeuty
from sales;

# write query write transactions is greater than 1000
select *
from sales
where total_sale > 1000;

# write query where total number of transaction made by each gender in each category

select category, gender,
count(*)
from sales
group by category, gender
order by 1;

# write query to calculate avg sales for each month,findout the the best selling month in each year.

SELECT
    year,
    month,
    Average_sale
FROM
    (
        SELECT
            YEAR(sale_date) AS year,
            MONTH(sale_date) AS month,
            ROUND(AVG(total_sale), 2) AS Average_sale,
            RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS rnk -- Corrected: removed 'as rank' inside OVER() and renamed to 'rnk'
        FROM
            sales
        GROUP BY
            YEAR(sale_date),
            MONTH(sale_date) -- Corrected: Use actual column names or their aliases in GROUP BY
    ) AS t1
WHERE
    rnk = 1; -- Corrected: Use 'rnk' as the alias for the rank column;
# order by 1,3 desc;

# write a query to find the top 5 customers based on the highest total sales

select customer_id, 
	   sum(total_sale) as total_sales from sales
group by customer_id
order by total_sales desc
limit 5;

# write a query to find number of unique customers who purchased from each category

select category,
	   count( distinct customer_id) as unique_customers
from sales
group by category;

# write a query to create each shift and number of orders (Example Morning <=12, afternoon between 12& 17 and evening >17)

with hourly_sales  -- creating a CTE
as
(
select*,
	case 
		when hour(sale_time) <12 then 'Morning'
        when hour(sale_time ) between 12 and 17 then 'afernoon'
        else 'Evening'
	end as shift
from sales
)
select shift,
  count(*) as total_orders 
from hourly_sales
group by shift;