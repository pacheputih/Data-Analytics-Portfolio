--Question 1
--Create a query to get the total users who completed the order and total orders per months

SELECT DATE_TRUNC(date(delivered_at), MONTH) as month,
COUNT(distinct user_id) as total_user_completed,
COUNT(order_id) as total_order_completed
FROM `bigquery-public-data.thelook_ecommerce.orders`
WHERE status='Complete' AND delivered_at BETWEEN '2019-01-01' AND '2022-05-01'
GROUP BY 1
ORDER BY 1

--Question 2
--Create a query to get average order value and total number of unique users, grouped by month
--sales per month divided by total order

SELECT DATE_TRUNC(date(OI.created_at), MONTH) as month,
(SUM(sale_price - cost) / COUNT(distinct order_id)) as AOV,
COUNT(distinct user_id) as total_user
FROM `bigquery-public-data.thelook_ecommerce.order_items` as OI
LEFT JOIN `bigquery-public-data.thelook_ecommerce.products` as P
ON OI.product_id = P.id
WHERE 1 IS NOT NULL AND OI.created_at BETWEEN '2019-01-01' AND '2022-05-01'
AND OI.status='Complete'
GROUP BY 1
ORDER BY 1

--Question 3
--Find the first and last name of users from the youngest and oldest age of each gender

WITH oldest AS
(
  SELECT first_name, last_name, gender, age
  FROM `bigquery-public-data.thelook_ecommerce.users`
  WHERE age = (SELECT MAX(age)FROM `bigquery-public-data.thelook_ecommerce.users`)
),
youngest AS
(
  SELECT first_name, last_name, gender, age
  FROM `bigquery-public-data.thelook_ecommerce.users`
  WHERE age = (SELECT MIN(age)FROM `bigquery-public-data.thelook_ecommerce.users`)
)
SELECT gender, age, first_name, last_name
FROM oldest
UNION ALL
SELECT gender, age, first_name, last_name
FROM youngest
ORDER BY age ASC

--Question 4
--Get the top 5 most profitable product and its profit detail breakdown by month

WITH product_per_order AS
(
  SELECT OI.delivered_at,
  O.order_id,
  product_id,
  FROM `bigquery-public-data.thelook_ecommerce.orders` as O
  LEFT JOIN `bigquery-public-data.thelook_ecommerce.order_items` as OI
  ON O.order_id = OI.order_id
  WHERE OI.status='Complete'
  ORDER BY O.order_id
), profit_per_order AS
(
  SELECT DATE_TRUNC(date(P3.delivered_at), MONTH) as month,
  P3.order_id,
  product_id,
  name,
  cost,
  retail_price,
  (retail_price - cost) as profit
  FROM product_per_order as P3
  LEFT JOIN `bigquery-public-data.thelook_ecommerce.products` as P
  ON P3.product_id = P.id
  ORDER BY 1, P3.order_id
), ranked AS
(
  SELECT month,
  DENSE_RANK() OVER(PARTITION BY month ORDER BY profit DESC) AS rank,
  product_id,
  name,
  cost,
  retail_price,
  profit
  FROM profit_per_order
  ORDER BY month
)
SELECT *
FROM ranked
WHERE rank <= 5
ORDER BY month, rank

--Question 5
--Create a query to get Month to Date of total revenue in each product categories of past 3 months (current date 15 April 2022)

WITH raw1 AS
(
  SELECT EXTRACT(DATE FROM OI.delivered_at) AS date,
  product_id,
  name,
  category,
  cost,
  retail_price,
  (retail_price - cost) as revenue
  FROM `bigquery-public-data.thelook_ecommerce.order_items` as OI
  LEFT JOIN `bigquery-public-data.thelook_ecommerce.products` as P
  ON OI.product_id = P.id
  WHERE date(OI.delivered_at) BETWEEN DATE_SUB(date'2022-04-15', Interval 3 MONTH) AND '2022-04-15' AND status = 'Complete'
  ORDER BY revenue
), raw2 AS
(
  SELECT date,
  category,
  SUM(cost) OVER(PARTITION BY category ORDER BY date) AS cost,
  SUM(retail_price) OVER(PARTITION BY category ORDER BY date) AS retail_price,
  SUM(revenue) OVER(PARTITION BY category ORDER BY date) AS revenue,
  FROM raw1
), February AS
(
  SELECT DISTINCT category,
  date,
  revenue
  FROM raw2
  WHERE date BETWEEN '2022-02-01' AND '2022-02-15'
), March AS
(
  SELECT DISTINCT category,
  date,
  revenue
  FROM raw2
  WHERE date BETWEEN '2022-03-01' AND '2022-03-15'
), April AS
(
  SELECT DISTINCT category,
  date,
  revenue
  FROM raw2
  WHERE date BETWEEN '2022-04-01' AND '2022-04-15'
)
SELECT *
FROM February
UNION ALL
SELECT *
FROM March
UNION ALL
SELECT *
FROM April
ORDER BY category, date