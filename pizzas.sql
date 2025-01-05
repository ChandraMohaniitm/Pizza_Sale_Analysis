--Q1 Retrieve the total number of orders placed.

SELECT COUNT(order_id) FROM orders

--Q2 Calculate the total revenue generated from pizza sales.

SELECT sum(price*quantity) 
FROM pizzas p JOIN order_details od
ON p.pizza_id=od.pizza_id

--Q3 Identify the highest-priced pizza.

SELECT name,price
FROM pizzas join pizza_types
on pizza_types.pizza_type_id=pizzas.pizza_type_id
where price = (SELECT MAX(price) FROM pizzas)
limit 1

--Q4 Identify the most common pizza size ordered.

select size,count(*)as count
from order_details os join pizzas p
on os.pizza_id=p.pizza_id
group by size
order by count desc

--Q5 List the top 5 most ordered pizza types along with their quantities.

select pt.name,sum(od.quantity) as sc
from pizza_types pt join pizzas p
on pt.pizza_type_id=p.pizza_type_id
join order_details od on p.pizza_id=od.pizza_id
group by pt.name 
order by sc desc

--Q6 Join the necessary tables to find the total quantity of each pizza category ordered.

select category,sum(quantity) as sum_quantity
from pizza_types pt join pizzas p
on pt.pizza_type_id=p.pizza_type_id
join order_details od on p.pizza_id=od.pizza_id
group by category
order by  sum_quantity desc

--Q7 Determine the distribution of orders by hour of the day.
select extract(hour from time)as hour,count(*)
from orders 
group by hour 
order by count desc

--Q8 Join relevant tables to find the category-wise distribution of pizzas.

select category,count(p.pizza_id)
from pizza_types pt join pizzas p
on pt.pizza_type_id=p.pizza_type_id
join order_details od on p.pizza_id=od.pizza_id
group by category
order by  count desc

--Q9 Determine the top 3 most ordered pizza types based on revenue.

select name,sum(total) as total
from (select pt.name,price*quantity as total
from pizza_types pt join pizzas p
on pt.pizza_type_id=p.pizza_type_id
join order_details od on p.pizza_id=od.pizza_id)
group by name 
order by total desc

--Q10 find the percentage wise sales over category

select category,(sum(quantity*price)/(select sum(quantity*price)
                                     from order_details od join pizzas p
                                     on od.pizza_id=p.pizza_id 
									  join pizza_types pt
                                     on p.pizza_type_id=pt.pizza_type_id)*100)
from order_details od join pizzas p
on od.pizza_id=p.pizza_id
join pizza_types pt
on p.pizza_type_id=pt.pizza_type_id
group by category

--Q10 Calculate the percentage contribution of each pizza type to total revenue.

select date, sum(c) over(order by date) as cum_sum
from
     (select date,sum(quantity*price) as c
      from order_details od join pizzas p
      on od.pizza_id=p.pizza_id
	  join pizza_types pt
      on p.pizza_type_id=pt.pizza_type_id
	  join orders o 
      on o.order_id=od.order_id
      group by date)