USE pizzahut;
-- Retrieve the total number of orders placed.
select count(order_id) as total_orders
from orders;

-- Calculate the total revenue generated from pizza sales.
select 
round(sum(orders_details.quantity * pizzas.price),2) as total_sales
from orders_details join pizzas
on pizzas.pizza_id = orders_details.pizza_id;


-- Identify the highest-priced pizza.
select pizza_types.name, pizzas.price
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc limit 1;


-- Identify the most common pizza size ordered.
select pizzas.size, count(orders_details.order_details_id) as orders_count
from pizzas join orders_details
on pizzas.pizza_id = orders_details.pizza_id
group by pizzas.size 
order by orders_count desc;


-- List the top 5 most ordered pizza types along with their quantities.
select 
pizza_types.name, sum(orders_details.quantity) as quantity
from pizza_types
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
join orders_details on orders_details.pizza_id = pizzas.pizza_id
group by pizza_types.name
order by quantity desc
limit 5;

-- Join the necessary tables to find the total quantity of each pizza category ordered.
select pizza_types.category,
sum(orders_details.quantity) as quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join orders_details
on orders_details.pizza_id = pizzas.pizza_id
group by pizza_types.category 
order by quantity desc;

-- Determine the distribution of orders by hour of the day.

select hour(order_time) as hour, count(order_id) asorder_count
from orders
group by hour(order_time);


-- Join relevant tables to find the category-wise distribution of pizzas.

select category, count(name) from pizza_types
group by category;


-- Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT 
    ROUND(AVG(quantity), 0) AS avg_pizza_ordered_per_day
FROM (SELECT 
	orders.order_date, SUM(orders_details.quantity) AS quantity
    FROM orders
    JOIN 
	orders_details ON orders.order_id = orders_details.order_id
    GROUP BY orders.order_date) AS orders_quantity;
    

-- Determine the top 3 most ordered pizza types based on revenue.

select pizza_types.name,
sum(orders_details.quantity * pizzas.price) as revenue
from pizza_types join pizzas
on pizzas.pizza_type_id = pizza_types.pizza_type_id
join orders_details
on orders_details.pizza_id = pizzas.pizza_id
group by pizza_types.name order by revenue desc limit 3;


-- Calculate the percentage contribution of each pizza type to total revenue.
SELECT 
    pizza_types.category,
    ROUND(
	SUM(orders_details.quantity * pizzas.price) /
	( SELECT SUM(orders_details.quantity * pizzas.price)
	FROM orders_details
	JOIN pizzas ON pizzas.pizza_id = orders_details.pizza_id) * 100, 2) AS revenue_percentage
    FROM pizza_types
    JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
    JOIN orders_details ON orders_details.pizza_id = pizzas.pizza_id
    GROUP BY pizza_types.category
    ORDER BY revenue_percentage DESC;
    
    
-- Analyze the cumulative revenue generated over time.
SELECT order_date,
    SUM(revenue) OVER(ORDER BY order_date) AS cum_revenue
FROM (SELECT orders.order_date,
SUM(orders_details.quantity * pizzas.price) AS revenue
FROM orders_details
JOIN pizzas ON orders_details.pizza_id = pizzas.pizza_id
JOIN orders ON orders.order_id = orders_details.order_id
GROUP BY 
orders.order_date
) AS sales;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select name, revenue 
from (select category, name, revenue,
rank() over(partition by category order by revenue desc) as rn
from (select pizza_types.category, pizza_types.name,
sum((orders_details.quantity) * pizzas.price) as revenue
from pizza_types 
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
join orders_details on orders_details.pizza_id = pizzas.pizza_id
group by pizza_types.category, pizza_types.name
) as a ) as b where rn <= 3;




 




