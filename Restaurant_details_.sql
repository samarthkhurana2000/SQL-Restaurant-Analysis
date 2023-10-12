
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


alter table restaurants 
 rename column ï»¿Restaurant_ID to restaurant_id ;
 
 -- 16 Total Restaurant in Each State
 select state,count(restaurant_id) as Total_restaurant
 from restaurants
 group by state
 order by Total_restaurant desc;

 -- 17 Total Restaurant in Each State
 select city, count(restaurant_id) as Total_restaurant
 from restaurants
 group by city
 order by total_restaurant desc;
 
  -- 18 Total Restaurant by alcohol service
   select Alcohol_Service, count(restaurant_id) as Total_restaurant
 from restaurants
 group by alcohol_service
 order by total_restaurant desc;

  
  -- 19 Total Restaurant by smoking allowed
     select Smoking_Allowed, count(restaurant_id) as Total_restaurant
 from restaurants
 group by Smoking_Allowed
 order by total_restaurant desc;
 
  -- 20 smoking and alcohol analysis by total restaurant
  select smoking_allowed,alcohol_service,count(restaurant_id) as total_restaurant
  from restaurants
  group by Smoking_Allowed,Alcohol_Service
  order by total_restaurant desc;
  
  -- 21 Total restaurant by price
  select price,count(restaurant_id)as Total_restaurant
  from restaurants
  group by price
  order by total_restaurant desc;
  
  -- 22  Total restaurant By parking 
  select parking,count(restaurant_id) as Total_restaurant
  from restaurants
  group by parking
  order by Total_restaurant desc;
  
  alter table restaurant_cuisines
  rename column ï»¿Restaurant_ID to restaurant_id;
  
  -- 23 Total Restaurant by Cuisine
  select cuisine, count(restaurant_id) as Total_Restaurant
  from restaurant_cuisines
  group by cuisine
  order by total_restaurant desc;

-- 24  Preferred cuisine of each restaurant(name)
select a.name ,count( b.cuisine) as Cuisine
from restaurants a
join restaurant_cuisines b
on a.restaurant_id=b.restaurant_id
group by a.name
order by Cuisine desc;

-- 25 Restaurant Price analysis for Each Cuisine
select b.cuisine,
sum(case when price = 'high' then 1 else 0 end) as HIGH,
sum(case when price = 'medium' then 1 else 0 end) as MEDIUM_,
sum( case when price = 'Low' then 1 else 0 end) as LOW
from restaurants a 
join restaurant_cuisines b
on a.restaurant_id=b.restaurant_id
group by b.cuisine
order by b.cuisine; 

-- 26 Restaurant count of each cuisine in each state
select b.cuisine,
sum(case when state='Morelos' then 1 else 0 end) as MORELOS,
sum(case when state='Tamaulipas' then 1 else 0 end) as TAMAULIPAS,
sum( case when state= 'San Luis Potosi' then 1 else 0 end) as SAN_LUIS_POTOSI
from restaurants a
join restaurant_cuisines b
on a.restaurant_id=b.restaurant_id
group by b.cuisine
order by cuisine;