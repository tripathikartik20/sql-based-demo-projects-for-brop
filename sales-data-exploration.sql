SELECT r.name as Region, sr.name as Rep_name, ac.name as account_name
FROM region r JOIN sales_reps sr ON r.id=sr.region_id JOIN accounts ac ON sr.id=ac.sales_rep_id
WHERE r.name='Midwest'
ORDER BY ac.name ASC

SELECT r.name as Region, sr.name as Rep_name, ac.name as account_name
FROM region r JOIN sales_reps sr ON r.id=sr.region_id JOIN accounts ac ON sr.id=ac.sales_rep_id
WHERE r.name='Midwest' AND sr.name LIKE 'S%'
ORDER BY ac.name ASC

SELECT r.name as Region, sr.name as Rep_name, ac.name as account_name
FROM region r JOIN sales_reps sr ON r.id=sr.region_id JOIN accounts ac ON sr.id=ac.sales_rep_id
WHERE r.name='Midwest' AND sr.name LIKE '% K%'
ORDER BY ac.name ASC

SELECT r.name AS region, ac.name AS account_name, o.total_amt_usd/(o.total + 0.01) AS unit_price
FROM region r JOIN sales_reps sr ON r.id=sr.region_id JOIN accounts ac ON sr.id=ac.sales_rep_id JOIN orders o ON ac.id = o.account_id
WHERE o.standard_qty > 100

SELECT r.name as region, ac.name as account_name, o.total_amt_usd/(o.total + 0.01) as unit_price
FROM region r JOIN sales_reps sr ON r.id=sr.region_id JOIN accounts ac ON sr.id=ac.sales_rep_id JOIN orders o ON ac.id = o.account_id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price ASC

SELECT r.name as region, ac.name as account_name, o.total_amt_usd/(o.total + 0.01) as unit_price
FROM region r JOIN sales_reps sr ON r.id=sr.region_id JOIN accounts ac ON sr.id=ac.sales_rep_id JOIN orders o ON ac.id = o.account_id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price DESC

SELECT ac.name AS account_name, AVG(o.standard_qty) AS average_standard_qty, AVG(o.gloss_qty) AS average_gloss_qty, 
AVG(o.poster_qty) AS average_poster_qty, AVG(total) as average_total
FROM accounts ac JOIN orders o ON ac.id=o.account_id 
GROUP BY ac.name
ORDER BY average_standard_qty DESC

SELECT ac.name AS account_name, AVG(o.standard_amt_usd) AS avg_standard_amt_usd, AVG(o.gloss_amt_usd) AS avg_gloss_amt_usd,
AVG(o.poster_amt_usd) AS avg_poster_amt_usd
FROM accounts ac JOIN orders o ON ac.id=o.account_id 
GROUP BY ac.name

SELECT ac.name AS account_name, AVG(o.standard_amt_usd) AS avg_standard_amt_usd, AVG(o.gloss_amt_usd) AS avg_gloss_amt_usd,
AVG(o.poster_amt_usd) AS avg_poster_amt_usd, AVG(o.standard_amt_usd)+AVG(o.gloss_amt_usd)+AVG(o.poster_amt_usd) as total
FROM accounts ac JOIN orders o ON ac.id=o.account_id 
GROUP BY ac.name
ORDER BY total DESC

SELECT sr.name AS sales_rep_name, we.channel AS channel, count(channel) AS number_of_occurrences
FROM web_events we JOIN accounts ac ON we.account_id=ac.id JOIN sales_reps sr ON ac.sales_rep_id=sr.id
GROUP BY sr.name, we.channel
ORDER BY number_of_occurrences DESC

SELECT EXTRACT(YEAR FROM occurred_at) AS year,  SUM(total_amt_usd) AS total_usd
FROM orders
GROUP BY year
ORDER BY total_usd ASC

SELECT EXTRACT(YEAR FROM occurred_at) AS year, EXTRACT(MONTH FROM occurred_at) AS month, SUM(total_amt_usd) AS total_usd
FROM orders
WHERE EXTRACT(YEAR FROM occurred_at) = 2013 OR EXTRACT(YEAR FROM occurred_at)= 2017
GROUP BY year, month
ORDER BY year

SELECT EXTRACT(YEAR FROM occurred_at) AS year, EXTRACT(MONTH FROM occurred_at) AS month,  EXTRACT(DAY FROM occurred_at) AS day,
SUM(total_amt_usd) AS total_usd
FROM orders
WHERE EXTRACT(YEAR FROM occurred_at)=2017
GROUP BY year, month, day
ORDER BY total_usd ASC

SELECT EXTRACT(YEAR FROM occurred_at) AS year, EXTRACT(MONTH FROM occurred_at) AS month,  EXTRACT(DAY FROM occurred_at) AS day,
SUM(total_amt_usd) AS total_usd
FROM orders
WHERE EXTRACT(MONTH FROM occurred_at)=1 AND EXTRACT(DAY FROM occurred_at)=1
GROUP BY year, month, day
ORDER BY total_usd ASC

WITH CTE_GROWTH AS 
(SELECT EXTRACT(YEAR FROM occurred_at) AS year, EXTRACT(MONTH FROM occurred_at) AS month,  EXTRACT(DAY FROM occurred_at) AS day,
SUM(total_amt_usd) AS total_usd
FROM orders
WHERE EXTRACT(MONTH FROM occurred_at)=1 AND EXTRACT(DAY FROM occurred_at)=1
GROUP BY year, month, day
ORDER BY total_usd ASC) 

SELECT year, month, day,total_usd, total_usd - LAG(total_usd) OVER (ORDER BY year ASC) AS growth, 
(total_usd - LAG (total_usd) OVER (ORDER BY year ASC))/LAG (total_usd) OVER (ORDER BY year ASC)*100 AS percentage_growth
FROM CTE_GROWTH

SELECT ac.name AS account_name,  EXTRACT(YEAR FROM o.occurred_at) AS year, EXTRACT(MONTH FROM o.occurred_at) AS month, SUM(o.gloss_amt_usd) AS gloss_total_usd
FROM accounts ac JOIN orders o ON ac.id=o.account_id
WHERE ac.name = 'Walmart'
GROUP BY account_name, year, month
ORDER BY gloss_total_usd DESC
limit 1

