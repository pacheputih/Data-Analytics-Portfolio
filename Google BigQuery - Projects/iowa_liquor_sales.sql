--1 Create a query to get total sales, total number of stores, total number of zip code, total number of days grouped by city.
SELECT
    city,
    ROUND(SUM(sale_dollars)) AS total_sales,
    COUNT(DISTINCT store_name) AS total_stores,
    COUNT(DISTINCT zip_code) AS total_zip_code,
    COUNT(DISTINCT date) AS total_days,
  FROM
    `bigquery-public-data.iowa_liquor_sales_forecasting.2020_sales_train`
  WHERE city IS NOT NULL AND zip_code IS NOT NULL
  GROUP BY 1
  ORDER BY 1

--2 Create a query to get average weekly sales per store (unique), ordered from the lowest to highest. Only take the ones which have sales >900
SELECT
    DATE_TRUNC(date, ISOWEEK) AS weekly_date,
    store_name,
    ROUND(AVG(sale_dollars)) AS avg_sales_weekly
  FROM
    `bigquery-public-data.iowa_liquor_sales_forecasting.2020_sales_train` 
  GROUP BY 1,2
  HAVING avg_sales_weekly > 900
  ORDER BY 3 asc

--3 Who are the top 10 performer stores that have the highest sales in the time period of Quarter 1-2 2020. Combine also city and zipcode, show it as 'city-zipcode'. And only for counties which have <6 letters length
SELECT
    DISTINCT(store_name), 
    CONCAT(city,'-',CAST(zip_code AS FLOAT64)) AS city_zipcode,
    ROUND(SUM(sale_dollars)) AS total_sales,
  FROM
    `bigquery-public-data.iowa_liquor_sales_forecasting.2020_sales_train`
  WHERE date >= '2020-01-01' AND
        date <= '2020-06-30' AND
        length(county)<6
  GROUP BY 1,2
  ORDER BY total_sales desc
  LIMIT 10

--4 Calculate monthly total sales in 2020 and total sales prediction 2021 by city. (use table 2020_sales_train & 2021_sales_predict)
-- What is the growth rate of sales in 2020 to 2021?

WITH raw1 as
(
  SELECT DATE_TRUNC(date, MONTH) as month, city,
  sale_dollars
  FROM `bigquery-public-data.iowa_liquor_sales_forecasting.2020_sales_train`
  WHERE city is not null AND sale_dollars is not null
  UNION ALL
  SELECT DATE_TRUNC(date, MONTH) as month, city,
  sale_dollars
  FROM `bigquery-public-data.iowa_liquor_sales_forecasting.2021_sales_predict`
  WHERE city is not null AND sale_dollars is not null
), raw2 as
(
  SELECT DISTINCT city, month, SUM(sale_dollars) as sales
  FROM raw1
  GROUP BY month, city
  ORDER BY city, month
), data2020 as
(
  SELECT city, sales
  FROM raw2
  WHERE month < '2020-03-31'
), data2021 as
(
  SELECT city, sales
  FROM raw2
  WHERE month > '2020-12-31'
)
SELECT DISTINCT a.city, SUM(a.sales) as year0, SUM(b.sales) as year1,
(SUM(b.sales) - SUM(a.sales))/SUM(a.sales) as growth
FROM data2020 as a
LEFT JOIN data2021 as b
ON a.city = b.city
GROUP BY city

--5 Combine also city and zipcode, show it as 'city-zipcode'
-- Which ‘city-zipcode’ is ranked 188 from the top sales in H1 2020?

with top_sales as
(
  select
  concat(city,"-", zip_code) as city_zipcode,
  sum(sale_dollars) as total_sales,
  RANK() OVER(ORDER BY sum(sale_dollars) DESC) as rank_sales,
  from `bigquery-public-data.iowa_liquor_sales_forecasting.2020_sales_train`
  group by 1
  order by 3 desc
)
select *
from top_sales
where rank_sales = 188

--6 Now, get a comparison of sales in 2020 and 2021 for each store name
-- Imagine you need to create a graph that shows trends of sales 2020-2021

WITH raw1 as
(
  SELECT DATE_TRUNC(date, MONTH) as month, store_name,
  sale_dollars
  FROM `bigquery-public-data.iowa_liquor_sales_forecasting.2020_sales_train`
  WHERE store_name is not null AND date is not null AND sale_dollars is not null
  UNION ALL
  SELECT DATE_TRUNC(date, MONTH) as month, store_name,
  sale_dollars
  FROM `bigquery-public-data.iowa_liquor_sales_forecasting.2021_sales_predict`
  WHERE store_name is not null AND date is not null AND sale_dollars is not null
)
SELECT DISTINCT store_name, month, ROUND(SUM(sale_dollars)) as sales
FROM raw1
GROUP BY month, store_name
ORDER BY store_name, month