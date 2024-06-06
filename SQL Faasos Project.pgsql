DROP TABLE IF EXISTS driver;
CREATE TABLE driver(driver_id integer, reg_date date);

INSERT INTO driver(driver_id, reg_date) 
VALUES 
(1, '2021-01-01'),
(2, '2021-03-01'),
(3, '2021-08-01'),
(4, '2021-01-15');

DROP TABLE IF EXISTS ingredients;
CREATE TABLE ingredients(ingredients_id integer, ingredients_name VARCHAR);

INSERT INTO ingredients(ingredients_id, ingredients_name) 
VALUES 
(1, 'BBQ Chicken'),
(2, 'Chilli Sauce'),
(3, 'Chicken'),
(4, 'Cheese'),
(5, 'Kebab'),
(6, 'Mushrooms'),
(7, 'Onions'),
(8, 'Egg'),
(9, 'Peppers'),
(10, 'schezwan sauce'),
(11, 'Tomatoes'),
(12, 'Tomato Sauce');

DROP TABLE IF EXISTS rolls;
CREATE TABLE rolls(roll_id integer, roll_name VARCHAR);

INSERT INTO rolls(roll_id, roll_name) 
VALUES 
(1, 'Non Veg Roll'),
(2, 'Veg Roll');

DROP TABLE IF EXISTS rolls_recipes;
CREATE TABLE rolls_recipes(roll_id integer, ingredients VARCHAR);

INSERT INTO rolls_recipes(roll_id, ingredients) 
VALUES 
(1, '1,2,3,4,5,6,8,10'),
(2, '4,6,7,9,11,12');

DROP TABLE IF EXISTS driver_order;
CREATE TABLE driver_order(order_id integer, driver_id integer, pickup_time TIMESTAMP, distance VARCHAR, duration VARCHAR, cancellation VARCHAR);

INSERT INTO driver_order(order_id, driver_id, pickup_time, distance, duration, cancellation) 
VALUES
(1, 1, '2021-01-01 18:15:34', '20km', '32 minutes', ''),
(2, 1, '2021-01-01 19:10:54', '20km', '27 minutes', ''),
(3, 1, '2021-03-01 00:12:37', '13.4km', '20 mins', 'NaN'),
(4, 2, '2021-04-01 13:53:03', '23.4', '40', 'NaN'),
(5, 3, '2021-08-01 21:10:57', '10', '15', 'NaN'),
(6, 3, null, null, null, 'Cancellation'),
(7, 2, '2020-08-01 21:30:45', '25km', '25mins', null),
(8, 2, '2020-10-01 00:15:02', '23.4 km', '15 minute', null),
(9, 2, null, null, null, 'Customer Cancellation'),
(10, 1, '2020-11-01 18:50:20', '10km', '10minutes', null);

DROP TABLE IF EXISTS customer_orders;
CREATE TABLE customer_orders(order_id integer, customer_id integer, roll_id integer, not_include_items VARCHAR, extra_items_included VARCHAR, order_date TIMESTAMP);

INSERT INTO customer_orders(order_id, customer_id, roll_id, not_include_items, extra_items_included, order_date)
VALUES 
(1, 101, 1, '', '', '2021-01-01 18:05:02'),
(2, 101, 1, '', '', '2021-01-01 19:00:52'),
(3, 102, 1, '', '', '2021-02-01 23:51:23'),
(3, 102, 2, '', 'NaN', '2021-02-01 23:51:23'),
(4, 103, 1, '4', '', '2021-04-01 13:23:46'),
(4, 103, 1, '4', '', '2021-04-01 13:23:46'),
(4, 103, 2, '4', '', '2021-04-01 13:23:46'),
(5, 104, 1, null, '1', '2021-08-01 21:00:29'),
(6, 101, 2, null, null, '2021-08-01 21:03:13'),
(7, 105, 2, null, '1', '2021-08-01 21:20:29'),
(8, 102, 1, null, null, '2021-09-01 23:54:33'),
(9, 103, 1, '4', '1,5', '2021-10-01 11:22:59'),
(10, 104, 1, null, null, '2021-11-01 18:34:49'),
(10, 104, 1, '2,6', '1,4', '2021-11-01 18:34:49');

select * from customer_orders;
select * from driver_order;
select * from ingredients;
select * from driver;
select * from rolls;
select * from rolls_recipes;


-- HOW MANY ROLLS WERE ORDERED?
select count(*)
from customer_orders as co
join rolls as r
on co.roll_id = r.roll_id;

-- how many unique customer order were made?
select count(DISTINCT customer_id)
from customer_orders



-- how  many successfull orders were made by the driver?

select count(*) from driver_order
where cancellation is null or cancellation = '' or cancellation = 'NaN';

select driver_id , count(order_id)
from driver_order
where order_id not in (select order_id from driver_order where cancellation in ('Cancellation','Customer Cancellation') )
GROUP by driver_id;

-- how many each type of roll were delivered?
select temp1.roll_id , temp1.roll_name , count(*)
from
(select r.*,co.order_id,co.customer_id,co.order_date
from rolls as r
join customer_orders as co
on co.roll_id = r.roll_id) as temp1
join driver_order as temp2
on temp2.order_id = temp1.order_id
where temp2.cancellation is null or temp2.cancellation in ('','NaN')
group by temp1.roll_id , temp1.roll_name;


-- Method 2 using Case
select temp2.roll_id , temp2.roll_name,count(*)
from
(select *, case when temp2.cancellation in ('Customer Cancellation','Cancellation') then 'na' else 'yes' end as cancellation_order 
from
(select r.*,co.order_id,co.customer_id,co.order_date
from rolls as r
join customer_orders as co
on co.roll_id = r.roll_id) as temp1
join driver_order as temp2
on temp2.order_id = temp1.order_id) as temp2
where cancellation_order <> 'na'
group by 1,2;

-- how  many veg and non veg rolls are ordered by each customer?
select temp1.customer_id,temp1.roll_name,count(*)
from
(select r.*,co.order_id,co.customer_id,co.order_date
from rolls as r
join customer_orders as co
on co.roll_id = r.roll_id) as temp1
group by temp1.roll_id,temp1.roll_name,temp1.customer_id
order by 1;

-- method2

select co.customer_id,r.roll_id,r.roll_name,count(*)
from rolls as r
join customer_orders as co
on co.roll_id = r.roll_id
group by co.customer_id,r.roll_id,r.roll_name
order by 1 asc;


-- what and when is the maximim no. of roles delivered in a single delivery ?


select dro.order_id , temp4.*
from driver_order as dro
join 
(SELECT temp3.only_date,count(*)
from
(SELECT *,case when temp2.cancellation is null or temp2.cancellation in ('','NaN') THEN date(temp2.pickup_time) else date(TIMESTAMP '1000-01-01') end as only_date
from
(select co.*,temp1.driver_id,temp1.pickup_time,temp1.distance,temp1.duration,temp1.cancellation
from customer_orders as co
inner join driver_order as temp1
on temp1.order_id = co.order_id
where temp1.cancellation is null or temp1.cancellation in ('','NaN')) as temp2) as temp3
group by temp3.only_date
order by 2 DESC
limit 1) as temp4
on temp4.only_date = date(dro.pickup_time);


-- for each customers , how many delivered rolls had atleast one change and how many have no change in it ?


with cte as (SELECT * ,case WHEN temp3.not_include_items_change = 'no' and temp3.extra_items_included_change = 'no' THEN 'NO' ELSE 'YES' END as final_change
from(select * , case when temp2.not_include_items = '' or temp2.not_include_items is null then 'no' else 'yes' end as not_include_items_change,case when temp2.extra_items_included in ('','NaN')  or temp2.extra_items_included is null then 'no' else 'yes' end as extra_items_included_change
from 
(select co.*,temp1.driver_id,temp1.pickup_time,temp1.distance,temp1.duration,temp1.cancellation, case WHEN temp1.cancellation is null or temp1.cancellation in ('','NaN') then 'yes' ELSE 'no' END as orders
from customer_orders as co
inner join driver_order as temp1
on temp1.order_id = co.order_id) as temp2
where temp2.orders = 'yes') as temp3)


-- no changes
-- select cte.customer_id,count(*)
-- from cte
-- where cte.not_include_items_change = 'no' and cte.extra_items_included_change = 'no'
-- group by cte.customer_id

-- atleast 1 change

-- select count(*)
-- from cte
-- where cte.not_include_items_change = 'yes' or cte.extra_items_included_change = 'yes';

SELECT cte.customer_id,cte.final_change,count(*)
from cte
group by cte.customer_id,cte.final_change
order by 2 asc;




-- how many cutomer have both inclusion and exclusion ?


select *
from
(select * , case when temp2.not_include_items = '' or temp2.not_include_items is null then 'no' else 'yes' end as not_include_items_change,case when temp2.extra_items_included in ('','NaN')  or temp2.extra_items_included is null then 'no' else 'yes' end as extra_items_included_change
from 
(select co.*,temp1.driver_id,temp1.pickup_time,temp1.distance,temp1.duration,temp1.cancellation, case WHEN temp1.cancellation is null or temp1.cancellation in ('','NaN') then 'yes' ELSE 'no' END as orders
from customer_orders as co
inner join driver_order as temp1
on temp1.order_id = co.order_id) as temp2
where temp2.orders = 'yes') as temp5
where temp5.not_include_items_change = 'yes' and temp5.extra_items_included_change = 'yes';





-- what is the total number of rolls order for each hour of the day?
select hour ,count(*)
from
(select *,case WHEN order_id <> 0 then extract(HOUR from order_date) else 0 END as hour
from customer_orders)
group by hour;

-- what are the totl order based on days of week?

select weekday ,count(*)
from
(select *,case WHEN order_id <> 0 then extract(dow from order_date) else 0 END as weekday
from customer_orders)
group by weekday;


-- what is the average time in minutes it took for each driver to arrive at faasos HQ to pickup the order 
select temp2.driver_id,avg(temp2.time_absolute) ,sum(temp2.time_absolute),count(*)
from
(select temp1.*, case WHEN temp1.time>0 then time else 60 + time END as time_absolute
from (select co.*,dro.driver_id,dro.pickup_time,dro.distance,dro.duration,extract (MINUTE from dro.pickup_time - co.order_date) as time
from customer_orders as co
join driver_order as dro
on dro.order_id = co.order_id
where dro.cancellation in ('','NaN') or dro.cancellation is null)as temp1)as temp2
group by 1;

-- is there relation between no. of roles and  how long order takes to prepare?
SELECT temp2.customer_id,count(*),avg(time_absolute)
from
(select *,case when time > 0 then time else 60 + time end as time_absolute
from
(select co.*,dro.driver_id,dro.pickup_time,dro.distance,dro.duration,dro.cancellation,extract(MINUTE from dro.pickup_time - co.order_date) as time
from customer_orders as co
join driver_order as dro
on dro.order_id = co.order_id
where dro.pickup_time is not null)as temp1)as temp2
group by 1;



-- what is the avg distnce travelled for each customer?
select customer_id , avg(temp1.distance_float)
from
(select co.*,dro.driver_id,dro.pickup_time,dro.distance,dro.duration,dro.cancellation,cast(replace(lower(dro.distance),'km','') as real) as distance_float
from customer_orders as co
join driver_order as dro
on dro.order_id = co.order_id
where dro.pickup_time is not null) as temp1
group by 1;


-- what is the difference between longest and shortest delivery times for all orders?


select max(time_duration),min(time_duration)
from
(select co.*,dro.driver_id,dro.pickup_time,dro.distance,dro.duration,dro.cancellation,cast(replace(replace(replace(lower(dro.duration),'minutes',''),'mins',''),'minute','') as int) as time_duration
from customer_orders as co
join driver_order as dro
on dro.order_id = co.order_id
where dro.pickup_time is not null);


-- what is the average speed for each driver for each order  ?
select driver_id , avg(speed)
from
(select temp1.*,(60*distance_float)/time_duration as speed
from 
(select co.*,dro.driver_id,dro.pickup_time,dro.distance,dro.duration,dro.cancellation,cast(replace(replace(replace(lower(dro.duration),'minutes',''),'mins',''),'minute','') as int) as time_duration,cast(replace(lower(dro.distance),'km','') as real) as distance_float
from customer_orders as co
join driver_order as dro
on dro.order_id = co.order_id
where dro.pickup_time is not null) as temp1)
group by 1;

