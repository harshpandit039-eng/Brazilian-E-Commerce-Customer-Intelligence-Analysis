# SALES ANALYSIS
select * from payments;

-- find total sales
select sum(payment_value)
from payments;

-- monthly growth
select 
     month(o.order_purchase_timestamp) as months,
               sum(p.payment_value) as total_sale
from payments p 
left join orders o on p.order_id=o.order_id
group by month(o.order_purchase_timestamp)
order by months asc,total_sale asc;

-- Top product categories
select p.product_category,sum(py.payment_value) as total_sale
from payments py
#here using 3rd table for connect table because which column are required for connect them is not present in payment table tha's why!
join order_items o on o.order_id = py.order_id
join products p on p.product_id = o.product_id
group by p.product_category
order by p.product_category ,total_sale ;

-- Highest selling product
select p.product_category,sum(py.payment_value) as total_sale
from payments py
#here using 3rd table for connect table because which column are required for connect them is not present in payment table tha's why!
join order_items o on o.order_id = py.order_id
join products p on p.product_id = o.product_id
group by p.product_category
order by p.product_category ,total_sale desc
limit 1;

-- Average Order value
select avg(price) as avg_order_value
from order_items;

-- CUSTOMER ANALYSIS

-- find the repeat customers

select c.customer_id,count(o.order_id) as total_order
from customers c
left join orders o on c.customer_id = o.customer_id
group by c.customer_id
having count(o.order_id)>1;

-- which state order most
select c.customer_state,count(o.order_id) as total_orders
from customers c
join orders o on c.customer_id=o.customer_id
group by c.customer_state
having count(o.order_id)>1
order by total_orders desc;

-- DELIVERY ANALYSIS

-- Delayed Delivery

select order_id ,order_delivered_customer_date,order_estimated_delivery_date,
datediff(order_delivered_customer_date,order_delivered_customer_date) as delay_days
from orders
where order_delivered_customer_date > order_estimated_delivery_date;

-- Fastest Shipping States

select c.customer_state,
                   avg(datediff(
								o.order_purchase_timestamp,o.order_delivered_customer_date) 
                                ) as avg_shipping_days
from customers c 
join orders o on c.customer_id = o.customer_id
where o.order_delivered_customer_date is not null
group by c.customer_state
order by avg_shipping_days;

-- Average Delivery Time
select avg(datediff(order_purchase_timestamp,order_delivered_customer_date)
) as avg_delivery_date
from orders
where order_delivered_customer_date is not null;





