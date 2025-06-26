--Create Table
CREATE TABLE Retail_Sales
(
transactions_id INT Primary key,
sale_date Date,
sale_time Time,
customer_id INT,
gender Varchar(15),
age INT,
category Varchar(15),
quantiy INT,
price_per_unit Float,
cogs Float,
total_sale Float
);

--Insert value into table
Select * from Retail_Sales

--Data Cleaning
--Checking Null Value
Select * from Retail_Sales
where transactions_id Is Null
OR
sale_date Is Null OR
sale_time Is Null OR
customer_id Is Null OR
gender Is Null OR
age Is Null OR
category Is Null OR
quantiy Is Null OR
price_per_unit Is Null OR
cogs Is Null OR
total_sale Is Null;

-- Delete NUll Value Col
Delete from Retail_Sales
where transactions_id Is Null
OR
sale_date Is Null OR
sale_time Is Null OR
customer_id Is Null OR
gender Is Null OR
age Is Null OR
category Is Null OR
quantiy Is Null OR
price_per_unit Is Null OR
cogs Is Null OR
total_sale Is Null;

--Data Exploration
--How many Sales we have
select count(*)as Total Sale from Retail_Sales

--How many uniquecustomer we have
Select Count(Distinct(Customer_id)) from Retail_Sales

-- How Many Unique category we have
select distinct (category) from Retail_Sales
--Data Analysis
-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
Select * from Retail_Sales
where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
Select * from Retail_Sales
where category='Clothing' And To_Char(sale_date,'yyyy-mm')='2022-11'
And quantiy>=4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category,Sum(total_sale) as Total_Sale
from Retail_Sales
group By category;
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select round(avg(age),2)
from Retail_Sales
where category ='Beauty';
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from Retail_Sales
where total_sale>1000;
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select category,gender,count(*) As Total_Transaction
from Retail_Sales
group by category,gender
order by category

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select year,month,Avg_sale
from(
Select
 Extract(Year from sale_date)as year,
 Extract(Month from sale_date) as month,
 avg(total_sale) as Avg_sale,
 Rank()Over(partition by extract(year from sale_date) Order by avg(total_sale) Desc)as rank
 from Retail_Sales
 Group By 1,2
) as t1
where rank=1
 
 
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
select customer_id,sum(total_sale)
from Retail_Sales
group by customer_id
order by sum(total_sale) Desc
limit 5

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select category,count(distinct customer_id) as Unique_Customer
from Retail_Sales
group by category
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
with hourly_sale
As
(
Select *,
case
when extract(hour from sale_time)<12 then 'Morning'
when extract(hour from sale_time) between 12 and 16 Then 'Afternoon' 
else 'Evening'
end as shift
from Retail_Sales)
select shift,count(*)as total_orders
from hourly_sale
group by shift

--which gender contribute more to total sale
select gender,sum(total_sale)
from Retail_Sales
group By gender

--What is the distribution of customer purchases by age group (e.g., 18–25, 26–35, etc.)?
With age_group
As
(
select *,
Case
when age<=25 then 'Junior'
when age between 26 and 40 then 'Adult'
else 'Senior'
end as age_category
from Retail_Sales
)
select age_category,Count(*) As Total_Order
from age_group
group by age_category;

--Which product category has the highest quantity sold?
select category,count(quantiy)
from Retail_Sales
group by category
Order By count(quantiy) Desc
Limit 1

--How many transactions exceed a profit margin of 80%?
SELECT 
    COUNT(*) AS high_margin_transactions
FROM 
    Retail_Sales
WHERE 
    (total_sale - cogs) / NULLIF(cogs, 0) > 0.80;


