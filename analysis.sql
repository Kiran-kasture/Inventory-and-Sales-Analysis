--total sales for each product
SELECT P.PRODUCT_NAME,
SUM(O.QUANTITY * O.LIST_PRICE) AS TOTAL_SALES
FROM PRODUCTS AS P
JOIN ORDERITEMS AS O ON P.PRODUCT_ID = O.PRODUCT_ID
GROUP BY P.PRODUCT_NAME
ORDER BY TOTAL_SALES 

--total monthly sales
SELECT TO_CHAR(ORDERS.ORDER_DATE,'Month')AS MONTHS,
SUM(O.QUANTITY * O.LIST_PRICE) AS TOTAL_SALES
FROM ORDERS
JOIN ORDERITEMS AS O ON ORDERS.ORDER_ID = O.ORDER_ID
GROUP BY MONTHS
ORDER BY TOTAL_SALES DESC

--top 10 customers by total spending.
SELECT CUSTOMERS.FIRST_NAME,
SUM(ORDERITEMS.QUANTITY * ORDERITEMS.LIST_PRICE)AS TOTAL_SPENT
FROM CUSTOMERS
JOIN ORDERS ON CUSTOMERS.CUSTOMER_ID = ORDERS.CUSTOMER_ID
JOIN ORDERITEMS ON ORDERITEMS.ORDER_ID = ORDERS.ORDER_ID
GROUP BY CUSTOMERS.FIRST_NAME
ORDER BY TOTAL_SPENT DESC
LIMIT 10;

--number of orders each customer has placed
SELECT CUSTOMERS.FIRST_NAME,
COUNT(ORDERS.ORDER_ID) AS TOTAL_NO_ORDERS
FROM CUSTOMERS
JOIN ORDERS ON CUSTOMERS.CUSTOMER_ID = ORDERS.CUSTOMER_ID
GROUP BY CUSTOMERS.FIRST_NAME
ORDER BY TOTAL_NO_ORDERS DESC 

--List of all products that have stock levels below 10.
SELECT PRODUCTS.PRODUCT_ID,
STOCKS.QUANTITY
FROM PRODUCTS
JOIN STOCKS ON PRODUCTS.PRODUCT_ID = STOCKS.PRODUCT_ID
WHERE STOCKS.QUANTITY < 10
ORDER BY STOCKS.QUANTITY

--total quantity of stock for each store.
SELECT stores.store_name, SUM(stocks.quantity) AS total_quantity
FROM stores
LEFT JOIN stocks ON stocks.store_id = stores.store_id
GROUP BY stores.store_name

--list of staff who are active 
SELECT STAFF.STAFF_ID,STAFF.FIRST_NAME,
COUNT(ORDERS.ORDER_ID) AS TOTAL_ORDER_PROCESSED
FROM STAFF
JOIN ORDERS ON STAFF.STAFF_ID = ORDERS.STAFF_ID
GROUP BY STAFF.STAFF_ID
ORDER BY TOTAL_ORDER_PROCESSED DESC



--total sales of each store
SELECT STORES.STORE_NAME,
SUM(ORDERITEMS.LIST_PRICE * ORDERITEMS.QUANTITY) AS TOTAL_SALES
FROM STORES
JOIN ORDERS ON STORES.STORE_ID = ORDERS.STORE_ID
JOIN ORDERITEMS ON ORDERITEMS.ORDER_ID = ORDERS.ORDER_ID
GROUP BY STORES.STORE_NAME order by TOTAL_SALES desc

--most popular product category by the number of items sold.
select categories.category_id,categories.category_name,count(orderitems.order_id) as no_of_iteam_sold
from categories join products on products.category_id=categories.category_id 
join orderitems on orderitems.product_id=products.product_id
group by  categories.category_id ,categories.category_name

--average list price for products in each brand.
select products.product_name,brands.brand_name,avg(orderitems.list_price) as average_price
from brands join  products on  brands.brand_id= products.brand_id join orderitems on orderitems.product_id=products.product_id 
group by products.product_name,brands.brand_name

--customers based on their purchase frequency and total spending.
WITH CustomerMetrics AS (
 SELECT c.customer_id,c.first_name,c.last_name,
COUNT(o.order_id) AS total_orders,
SUM(oi.quantity * oi.list_price * (1 - oi.discount / 100)) AS total_spending
FROM Orders o
JOIN OrderItems oi ON o.order_id = oi.order_id
JOIN  Customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT  customer_id,first_name,last_name,total_orders,total_spending,
CASE
WHEN total_orders > 50 THEN 'High Frequency'
WHEN total_orders BETWEEN 20 AND 50 THEN 'Medium Frequency'
ELSE 'Low Frequency'
END AS frequency_segment,
CASE
WHEN total_spending > 5000 THEN 'High Spender'
WHEN total_spending BETWEEN 1000 AND 5000 THEN 'Medium Spender'
ELSE 'Low Spender'
END AS spending_segment
FROM CustomerMetrics;

