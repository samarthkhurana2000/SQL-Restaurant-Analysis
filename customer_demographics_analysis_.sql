--- Title :-        Restaurant Ratings Analysis
--- Created by :-   Samarth
--- Date :-         19-08-2023
--- Tool used:-     SQL ( MySQL Work Bnech)



-- Introduction
-- In this project, we will be analyzing restaurant ratings data to gain insights into the performance of various restaurants.
-- We will use SQL to extract, transform and analyze the data.
-- The insights gained from this analysis will be used to understand the factors that influence a restaurant's rating and make recommendations for improvement.
-- We will examine the relationship between different variables such as the location, cuisine and price range of the restaurants and their ratings.
-- We will also do sentiment analysis to analyse most favorable restaurants of customers


show databases;
use restaurant;

alter table consumers 
rename column ï»¿Consumer_ID to customer_id;

-- 1 Total Customer In Each City
select city,count(customer_id) as Total_customer
from consumers
group by city
order by Total_customer desc;

-- 2 Total Customer In Each State
select state,count(customer_id) as Total_customer
from consumers
group by state
order by Total_customer desc;

-- 3 Budget Level Of Customer
select budget,count(customer_id) as Total_customer
from consumers
where budget is not null
group by budget;

-- 4 Total Smokers by occupation
select count(customer_id) as smokers ,occupation
from consumers
where smoker='yes'
group by occupation;  

-- 5 Drinking Level Of Students
select drink_level ,count(customer_id) as students
from consumers
where occupation = 'Student' and occupation is not null
group by drink_level;

-- 6 Transporation method of customer
select transportation_method,count(customer_id)as Total_customers
from consumers
where Transportation_Method is not null
group by Transportation_Method
order by Total_customers;

-- 7 Add the age bucket Column
alter table consumers
add column age_bucket varchar(50);

-- 8 update age bucket column with case and when condition
update consumers
set age_bucket = case when age>60 then '61 and above'
when age>40 then '41-60'
when age>25 then '26-40'
when age>=18 then '18-25'
end
where age_bucket is null;

-- 9  Total Customer in each age bucket
select age_bucket , count(customer_id) as Total_Customer
from consumers
 group by age_bucket
 order by age_bucket;
 
 -- 10  Total customer count ad smoker count in each age bucket
 select count(customer_id) as Total_customers,
 count(case when smoker="yes" then customer_id end) as smokers_count,
 age_bucket
 from consumers
 group by age_bucket
 order by age_bucket;
 
 alter table consumer_preferences
 rename column ï»¿Consumer_ID to customer_id;
 
 -- 11 Top 20 preffered cuisine
 select count(customer_id) as Total_customer,preferred_cuisine
 from consumer_preferences
 group by Preferred_Cuisine
 order by total_customer desc
 limit 20;
 -- 12 preferred cuisine of each customer by customer id
 select customer_id,count(Preferred_Cuisine) as total_cuisine
 from consumer_preferences
 group by customer_id
 order by total_cuisine desc;
 
 -- 13 Customer budget analysis(count of each budget class) for each cuisine
 select b.Preferred_Cuisine,
 sum( case when budget="high" then 1 else 0 end) as HIGH,
 sum( case when budget="medium" then 1 else 0 end) as MEDIUM_,
 sum( case when budget="low" then 1 else 0 end) as LOW
 from consumers a
 join consumer_preferences b
 on a.customer_id=b.customer_id
 group by Preferred_Cuisine
 order by Preferred_Cuisine;
 
 
 -- 14 Find out count of  each cuisine of each state
select b.Preferred_Cuisine,
sum(case when a.state='morelos' then 1 else 0 end) as morelos,
sum(case when a.state='San Luis Potosi' then 1 else 0 end) as San_Luis_Potosi,
sum(case when a.state=' Tamaulipas' then 1 else 0 end) as Tamaulipas
from consumers a
join consumer_preferences b
on a.customer_id=b.customer_id
group by b. Preferred_Cuisine 
order by b.Preferred_Cuisine;


 
 -- 15 finding out count of each cuisine in each age bucket
 select b.preferred_cuisine,
 sum(case when a.age_bucket='18-25' then 1 else 0 end) as "18-25",
 sum( case when a.age_bucket='26-40' then 1 else 0 end) as "26-40",
 sum( case when a.age_bucket='41-60' then 1 else 0 end)as "41-60",
 sum(case when a.age_bucket='61 and above' then 1 else 0 end) as "61 and above"
 from consumers a
 join consumer_preferences b
 on a.customer_id=b.customer_id
 group by preferred_cuisine
 order by Preferred_Cuisine;
 