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


-- 27 Ratings given by customer for restaurants
alter table ratings 
rename column ï»¿Consumer_ID to customer_id;

alter table restaurants
rename column Name to name_;

select a.name_,b.customer_id,b.overall_rating,b.food_rating,b.service_rating
from restaurants
join ratings
on a.restaurant_id=b.restaurant_id
order by b.restaurant_id;

-- 28 Average rating of each restaurant including its cuisine type
select a.name_,
round(avg(b.overall_rating),2) as overall_rating,
round(avg(b.food_rating),2) as food_rating,
round(avg(b.service_rating),2) as service_rating,
c.cuisine
from restaurants a 
join ratings b
on a.restaurant_id=b.Restaurant_ID
join restaurant_cuisines c
on b.Restaurant_ID=c.restaurant_id
group by a.name_,c.cuisine
order by a.name_;

-- 29 Creating New Column for sentiment Analysis
alter table ratings
add column overall_sentiment varchar(50);

alter table ratings
add column food_sentiment varchar(50);

alter table ratings
add column service_sentiment varchar(50);

select* from ratings;

-- 30  updating the new columns related to sentiment analysis

update ratings
set overall_sentiment= (case when overall_rating =0 then 'Negative'
						 when overall_rating= 1 then 'Neutral'
                        when overall_rating=2 then 'Positive'
                        end)
                        where overall_sentiment is NULL;
                        
update ratings
set food_sentiment= (case when food_rating =0 then 'Negative'
						 when food_rating= 1 then 'Neutral'
                        when food_rating=2 then 'Positive'
                        end)
                        where food_sentiment is NULL;
                        
 update ratings
 set service_sentiment= ( case when service_rating=0 then 'Negative'
                              when service_rating=1 then 'Neutral' 
                              when service_rating= 2 then 'Positive'
                              end)
                           where service_sentiment is null;   
-- 31 Conduct a sentimental analysis  by total count of customer
-- Analysis of overall_sentiment by total customer
create view overall_ as
select overall_sentiment,
count(customer_id) as total_customer
from ratings
group by overall_sentiment;

-- Analysis of food sentiment by total customer
create view food_ as
select food_sentiment,count(customer_id) as total_customer
from ratings
group by food_sentiment;

-- analysis of service sentimemnt by total customer
create view service_ as 
select service_sentiment,count(customer_id) as total_customer
from ratings 
group by service_sentiment;

-- main code of the sentimental analysis of total count of customers
select a.overall_sentiment as sentiment,
a.total_customer as overall__rating,
b.total_customer as  food__rating,
c.total_customer as service__rating
from overall_ a
join food_ b
on a.overall_sentiment=b.food_sentiment
join service_ c
on b.food_sentiment=c.service_sentiment;

-- 32 List of customer visiting local or  outside restaurant
select a.customer_id,
a.overall_sentiment,
a.food_sentiment,
a.service_sentiment,
b.City as customer_city,
c.name_ as restaurant_name,
c.City as restaurant_city,
case when b.city=c.city then "Local" else "Outside" end as location_preference
from ratings a
join consumers b
on  a.customer_id=b.customer_id
join restaurants c
on a.Restaurant_ID=c.restaurant_id;



-- 33 count of customers visiting local or outside restaurant
select 
	Location_preference,
	count(*) as total_customers,
	count( distinct id) as distinct_customers
from 	(    SELECT 
			 a.customer_id as id,
			 b.city as customer_city,
			 c.name_,
			 c.city as restaurant_city,
			 a.overall_sentiment,
			 a.food_sentiment,
			 a.service_sentiment,
			 CASE WHEN b.city = c.city THEN 'Local' ELSE 'Outside' END as Location_preference
	      from       ratings a
	      join consumers as b
	      on         a.customer_id = b.customer_id
		 join restaurants as c
	      on        a.restaurant_id = c.restaurant_id ) as cte
group by  Location_preference;




-- 34 Trends of customer visiting outside restaurants
select customer_id,
customer_city,
restaurant_city,
concat_ws('-',customer_city,restaurant_city) as direction,
restaurant_name
from( select a.customer_id,
a.overall_sentiment,
a.food_sentiment,
a.service_sentiment,
b.City as customer_city,
c.City as restaurant_city,
c.name_ as restaurant_name,
case when b.City=c.City then"Local" else"Outside" end as location_preference
from ratings a
join consumers b
on a.customer_id=b.customer_id
join restaurants c
on a.restaurant_id=c.restaurant_id) as cte
where location_preference="Outside";


-- 35 Analysis of cuisine preferred and cuisine consumed
select b.customer_id,a.Preferred_Cuisine,c.cuisine,d.name_
from consumer_preferences a
join ratings b
on a.customer_id=b.customer_id
join restaurant_cuisines c
on b.Restaurant_ID=c.Restaurant_ID
join restaurants d
on c.restaurant_id=d.restaurant_id;

-- 36 Best restaurant for each cuisines by different ratings


create view average_analysis as (
select 
	   a.name_,
	   round(avg(b.overall_rating),2)as overall_Rating,
	   round(avg(b.food_rating),2)as food_rating,
	   round(avg(b.service_rating),2)as service_rating,
	   c.cuisine
from      restaurants  a 
join ratings  b
on        a.restaurant_id = b.restaurant_id
join restaurant_cuisines  c
on       a.restaurant_id = c.restaurant_id
group by   a.name_,c.cuisine
order by   c.cuisine);
	

create view best  as (
select 
     cuisine,
     First_value(name_) over(partition by cuisine ORDER BY overall_rating desc) as best_for_overall,
     First_value(name_) over(partition by cuisine ORDER BY food_rating desc) as best_for_food,
     First_value(name_) over(partition by cuisine ORDER BY service_rating desc) as best_for_service
from average_analysis);

select   *
from     best
group by cuisine, best_for_overall, best_for_food, best_for_service
order by cuisine;	


-- 37 Best cuisines bydifferent ratings
select
first_value(Cuisine) over(order by overall_rating desc) as overall,
first_value(Cuisine) over(order by food_rating desc) as food,
first_value(Cuisine) over(order by service_rating desc) as service
from average_analysis_ratings
limit 1; 

-- 38 total customer with highet rating in all categories of rating
select count(customer_id) as total_customers
from ratings
where Overall_Rating=2 and
food_rating=2 and
service_rating =2;




 
