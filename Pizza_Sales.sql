-- Retrieve the total number of orders placed.

SELECT COUNT(order_id) from orders as total_orders

-- Calculate the total revenue generated from pizza sales.pizzas
SELECT 
    ROUND(SUM(OD.quantity * P.price), 2) AS Total_Revenue
FROM
    order_details OD
        INNER JOIN
    pizzas P ON OD.pizza_id = P.pizza_id;

-- Identify the highest-priced pizza.
SELECT 
    pizza_type_id AS Pizza_Type
FROM
    pizzas
WHERE
    price = (SELECT 
            MAX(price)
        FROM
            pizzas);

-- Identify the most common pizza size ordered.
SELECT 
    COUNT(O.order_details_id) AS num_orders, P.size
FROM
    pizzas P
        JOIN
    order_details O ON P.pizza_id = O.pizza_id
GROUP BY P.size
ORDER BY num_orders DESC
LIMIT 1;

SELECT pizza_type FROM pizzas 
WHERE price = (SELECT Max(price) from pizzas);

-- Determine the distribution of orders by hour of the day.

SELECT 
    HOUR(order_time) AS Hour_of_Day,
    COUNT(order_id) AS Count_of_Orders
FROM
    orders
GROUP BY HOUR(order_time);

-- Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT 
    ROUND(AVG(quantity)) AS Average_Pizzas_Per_Day
FROM
    (SELECT 
        DATE(orders.order_date),
            SUM(order_details.quantity) AS quantity
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY DATE(orders.order_date)) AS orders_per_day;

-- Calculate cumulative revenue over time 

select order_date, 
sum(revenue) over(order by order_date) as cum_revenue from
(select orders.order_date, sum(order_details.quantity * pizzas.price) as revenue
from orders join order_details on orders.order_id = order_details.order_id
join pizzas on order_details.pizza_id = pizzas.pizza_id
group by orders.order_date) as sales;
;
