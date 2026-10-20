CREATE Database food_delivery;
USE food_delivery;
USE food_delivery;
DESCRIBE deliveries;
-- Q1: What is the total number of orders?
SELECT COUNT(*) AS total_orders FROM deliveries;
-- Insight: The dataset contains 44,968 order records.

-- How many orders are there,and what are the average,minimum and maximum delivery times?
SELECT COUNT(*) AS total_orders,
       ROUND(AVG(time_taken_min), 1) AS avg_time,
       MIN(time_taken_min) AS Min_time,
       MAX(time_taken_min)AS  Max_time
FROM deliveries;
-- insight:The dataset contains 44968 records with the average delivery time taken is 26.3 and minimum is The rows are 44968 and avg time taken is 26.3 and minimum time taken is 10 and maximum is 54 



-- Q.does traffic affect delivery time? 
USE food_delivery;
SELECT road_traffic_density,
    COUNT(*) AS orders,
    ROUND(AVG(time_taken_min), 1) AS avg_time
FROM food_delivery.deliveries
GROUP BY road_traffic_density
ORDER BY avg_time DESC;
-- insight:jam traffic takes about 31 min vs 21 min in low traffic(about 10 min longer)
-- recommendation:Add more delivery partners during jams and show real extended time to customers.and offer some discount or off according to delay and also can offer a complimentary food.



-- Q3: does weather affect delivery time?
SELECT weather_conditions,
COUNT(*) AS orders,
ROUND(avg(time_taken_min), 1) AS avg_time
FROM deliveries
GROUP BY weather_conditions
ORDER BY avg_time DESC;
-- insight:fog and cloudy weather are slowest (about 28 min); sunny is fastest (21 min).
-- recommendation:comapny can give bonus to delivery partners in cloudy and fog condition and can update customer early about delay.
        

-- Q4: which vehicle type is fastest?
SELECT type_of_vehicle,
COUNT(*) AS orders,
ROUND(avg(time_taken_min) ,1) AS avg_time
FROM deliveries
GROUP BY type_of_vehicle
ORDER BY avg_time DESC;
-- insight:motorcycle is slowest about 28 min and electric scooter is fastest about 25 min
-- recommendation:


-- Q5: which order type takes longest?
SELECT type_of_order,
COUNT(*) AS orders,
ROUND(Avg(time_taken_min), 1) AS avg_time
FROM deliveries
GROUP BY type_of_order
ORDER BY avg_time DESC;
-- insight:All four order types take about ___ min, so order type has no real effect.
-- recommenation: Focus on traffic and weather, not on what is ordered


-- Q6: which traffic and weather combinations are slowest?
SELECT road_traffic_density,weather_conditions,
COUNT(*) AS orders,
ROUND(avg(time_taken_min), 1) AS avg_time
FROM deliveries
GROUP BY road_traffic_density,weather_conditions
Having COUNT(*) >=100
ORDER BY avg_time DESC
LIMIT 5;
-- insight:
-- recommendation:



-- Q7.festival days vs. normal days
SELECT festival,
COUNT(*) AS orders,
ROUND(avg(time_taken_min), 1) AS avg_time
FROM deliveries
GROUP BY festival
ORDER BY avg_time DESC;
-- insight:
-- recommendation:



-- -- Q7b: city type
SELECT city,
COUNT(*) AS orders,
ROUND(avg(time_taken_min), 1) AS avg_time
FROM deliveries
GROUP BY city
ORDER BY avg_time DESC;
-- insight:
-- recommendation:



-- Q8: rating bands
SELECT CASE WHEN delivery_person_ratings <=4.5 THEN '4.5 or below'
            WHEN delivery_person_ratings <=4.8 THEN '4.6 to 4.8'
            ELSE '4.9 to 5.0' END AS rating_band,
COUNT(*) AS orders,
ROUND(avg(time_taken_min), 1) AS avg_time
FROM deliveries
GROUP BY rating_band
ORDER BY avg_time DESC;
-- insight
-- recommendation:


-- Q9: busiest hours and their delivery time
SELECT order_hour,
COUNT(*) AS orders,
ROUND(avg(time_taken_min), 1) AS avg_time
FROM deliveries
GROUP BY order_hour
ORDER BY orders DESC;
-- insight:
-- recommendation:



-- Q10: what percentage of orders are slow, for each traffic level?
WITH flagged as(
SELECT road_traffic_density,+
CASE WHEN time_taken_min > 35 THEN 1 ELSE 0 END AS is_slow
FROM Deliveries
)
SELECT road_traffic_density,
COUNT(*) AS orders,
SUM(is_slow) AS slow_orders,
ROUND(100.0*SUM(is_slow)/COUNT(*), 1) as pct_slow_orders
FROM flagged
GROUP BY road_traffic_density
ORDER BY pct_slow_orders DESC;
-- insight:
-- recommendation:


-- Q11: rank the vehicle types inside each cityS
SELECT city,type_of_vehicle,
COUNT(*) AS orders,
ROUND(avg(time_taken_min), 1) AS avg_time,
RANK() OVER (PARTITION BY city ORDER BY avg(time_taken_min)) AS speed_rank
FROM deliveries
GROUP BY city,type_of_vehicle
ORDER BY city,speed_rank DESC;
-- insight:
-- recommendation:



-- Q12: does carrying multiple deliveries slow an order down?
SELECT multiple_deliveries,
COUNT(*) AS orders,
ROUND(avg(time_taken_min), 1) AS avg_time
FROM deliveries
GROUP BY multiple_deliveries
ORDER BY multiple_deliveries DESC;
-- insight:
-- recommendation:


-- who are the 5 highest-rated partners in each city?
SELECT city, delivery_person_id, orders, avg_rating, avg_time, rank_in_city
FROM (
    SELECT city,
           delivery_person_id,
           COUNT(*) AS orders,
           ROUND(AVG(delivery_person_ratings), 2) AS avg_rating,
           ROUND(AVG(time_taken_min), 1) AS avg_time,
           ROW_NUMBER() OVER (PARTITION BY city
                              ORDER BY AVG(delivery_person_ratings) DESC, COUNT(*) DESC) AS rank_in_city
    FROM deliveries
    WHERE city <> 'Unknown'
    GROUP BY city, delivery_person_id
    HAVING COUNT(*) >= 10
) AS ranked
WHERE rank_in_city <= 5
ORDER BY city, rank_in_city;
-- insight:
-- recommendation:


-- Q.14ais the traffic and weather effect the same in each city type?
-- Q14a: traffic by city
SELECT city, road_traffic_density,
       COUNT(*) AS orders,
       ROUND(AVG(time_taken_min), 1) AS avg_time
FROM deliveries
WHERE city <> 'Unknown'
GROUP BY city, road_traffic_density
ORDER BY city, avg_time DESC;
-- insight:
-- recommendation:


-- Q14b: weather by city
-- Q14b: weather by city
SELECT city, weather_conditions,
       COUNT(*) AS orders,
       ROUND(AVG(time_taken_min), 1) AS avg_time
FROM deliveries
WHERE city IN ('Metropolitan', 'Urban')
GROUP BY city, weather_conditions
ORDER BY city, avg_time DESC;
-- insight:
-- recommendation:



-- Q15: vehicle type and vehicle condition
SELECT type_of_vehicle, vehicle_condition,
       COUNT(*) AS orders,
       ROUND(AVG(time_taken_min), 1) AS avg_time
FROM deliveries
GROUP BY type_of_vehicle, vehicle_condition
ORDER BY type_of_vehicle, vehicle_condition;
-- insight:
-- recommendation:





