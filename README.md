#  SQL Pizza Sales Analysis Project

##  Overview
This project analyzes pizza sales data using **MySQL** queries.  
It includes insights into revenue, top-selling pizzas, category performance, and customer order behavior.  
The project demonstrates the use of SQL functions like **JOIN**, **GROUP BY**, **RANK**, **WINDOW FUNCTIONS**, and **AGGREGATIONS** to extract valuable business insights from raw sales data.

---

##  Key Objectives
- Calculate total number of orders and total revenue.
- Identify top-performing pizzas and their categories.
- Analyze order trends by time and date.
- Determine contribution of each pizza type to total sales.
- Track cumulative revenue growth over time.

---

##  Dataset Information
The project assumes a **PizzaHut** database with the following tables:

| Table Name | Description |
|-------------|--------------|
| `orders` | Contains order date and time details. |
| `orders_details` | Contains item quantity and order relationships. |
| `pizzas` | Contains pizza IDs, sizes, and prices. |
| `pizza_types` | Contains pizza names and category information. |

---

##  SQL Queries Included

### 1. Total Orders
```sql
SELECT COUNT(order_id) AS total_orders FROM orders;
````

### 2. Total Revenue

```sql
SELECT ROUND(SUM(orders_details.quantity * pizzas.price), 2) AS total_sales
FROM orders_details
JOIN pizzas ON pizzas.pizza_id = orders_details.pizza_id;
```

### 3. Highest-Priced Pizza

```sql
SELECT pizza_types.name, pizzas.price
FROM pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;
```

### 4. Most Common Pizza Size Ordered

```sql
SELECT pizzas.size, COUNT(orders_details.order_details_id) AS orders_count
FROM pizzas
JOIN orders_details ON pizzas.pizza_id = orders_details.pizza_id
GROUP BY pizzas.size
ORDER BY orders_count DESC;
```

### 5. Top 5 Most Ordered Pizza Types

```sql
SELECT pizza_types.name, SUM(orders_details.quantity) AS quantity
FROM pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN orders_details ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY quantity DESC
LIMIT 5;
```

### 6. Category-Wise Quantity Ordered

```sql
SELECT pizza_types.category, SUM(orders_details.quantity) AS quantity
FROM pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN orders_details ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY quantity DESC;
```

### 7. Order Distribution by Hour

```sql
SELECT HOUR(order_time) AS hour, COUNT(order_id) AS order_count
FROM orders
GROUP BY HOUR(order_time);
```

### 8. Average Pizzas Ordered per Day

```sql
SELECT ROUND(AVG(quantity), 0) AS avg_pizza_ordered_per_day
FROM (
  SELECT orders.order_date, SUM(orders_details.quantity) AS quantity
  FROM orders
  JOIN orders_details ON orders.order_id = orders_details.order_id
  GROUP BY orders.order_date
) AS orders_quantity;
```

### 9. Top 3 Pizzas by Revenue

```sql
SELECT pizza_types.name,
SUM(orders_details.quantity * pizzas.price) AS revenue
FROM pizza_types
JOIN pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
JOIN orders_details ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue DESC
LIMIT 3;
```

### 10. Revenue Contribution by Category

```sql
SELECT pizza_types.category,
ROUND(
  SUM(orders_details.quantity * pizzas.price) /
  (SELECT SUM(orders_details.quantity * pizzas.price)
   FROM orders_details
   JOIN pizzas ON pizzas.pizza_id = orders_details.pizza_id) * 100, 2
) AS revenue_percentage
FROM pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN orders_details ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue_percentage DESC;
```

### 11. Cumulative Revenue Over Time

```sql
SELECT order_date,
SUM(revenue) OVER(ORDER BY order_date) AS cum_revenue
FROM (
  SELECT orders.order_date,
  SUM(orders_details.quantity * pizzas.price) AS revenue
  FROM orders_details
  JOIN pizzas ON orders_details.pizza_id = pizzas.pizza_id
  JOIN orders ON orders.order_id = orders_details.order_id
  GROUP BY orders.order_date
) AS sales;
```

### 12. Top 3 Pizzas by Category (Revenue-Based)

```sql
SELECT name, revenue 
FROM (
  SELECT category, name, revenue,
  RANK() OVER(PARTITION BY category ORDER BY revenue DESC) AS rn
  FROM (
    SELECT pizza_types.category, pizza_types.name,
    SUM(orders_details.quantity * pizzas.price) AS revenue
    FROM pizza_types 
    JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
    JOIN orders_details ON orders_details.pizza_id = pizzas.pizza_id
    GROUP BY pizza_types.category, pizza_types.name
  ) AS a
) AS b 
WHERE rn <= 3;
```

---

##  Insights You Can Gain

* Total and average pizza sales trends.
* Most popular pizza size and type.
* Top 3 pizzas contributing the most to revenue.
* Hourly order patterns for better staffing.
* Category-based sales performance and contribution.
* Progressive revenue growth across time.

---

##  Technologies Used

* **MySQL**
* **SQL Functions**: Aggregate, Window, Join, and Date/Time functions.

---

##  How to Run the Project

1. Create a new MySQL database named `pizzahut`.
2. Import or execute the SQL file `sql_pizza_project.sql`.
3. Run each query step-by-step to analyze the pizza sales data.

---

##  Author

**Ramkishor Sevda**
SQL | Data Analytics | MySQL Projects


---
