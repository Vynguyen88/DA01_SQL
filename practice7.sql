--ex1
SELECT extract (year from transaction_date) as year, product_id, 
spend as curr_year_spend, 
lag (spend) over (PARTITION BY product_id order by product_id, extract (year from transaction_date)) as prev_year_spend,
round(100 * (spend - LAG(spend) OVER (PARTITION BY product_id ORDER BY transaction_date)) / LAG(spend) OVER (PARTITION BY product_id ORDER BY transaction_date),2) AS yoy_rate
FROM user_transactions;
--ex2
SELECT DISTINCT card_name, 
first_value(issued_amount) OVER(PARTITION BY card_name ORDER BY concat (issue_year,issue_month,'01')) as amount
FROM monthly_cards_issued
ORDER BY amount DESC
--ex3
select user_id, spend, transaction_date
from(
SELECT *, dense_rank() OVER(PARTITION BY user_id ORDER BY transaction_date) as ranking
from transactions )  as t
where ranking=3
--ex4
SELECT transaction_date,user_id,COUNT(transaction_date) purchase_count
FROM(SELECT *,
    RANK() OVER(PARTITION BY user_id ORDER BY transaction_date DESC)
    FROM user_transactions
    ORDER BY user_id,transaction_date DESC) a
WHERE rank = 1
GROUP BY user_id,transaction_date
ORDER BY transaction_date
--ex5
SELECT    
  user_id,    
  tweet_date,   
  ROUND(AVG(tweet_count) OVER (
    PARTITION BY user_id     
    ORDER BY tweet_date     
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
  ,2) AS rolling_avg_3d
FROM tweets
--ex6
with cte as (SELECT merchant_id, credit_card_id, amount, transaction_timestamp,
lag(transaction_timestamp) 
OVER(PARTITION BY merchant_id, credit_card_id, amount order by transaction_timestamp) 
as prev_transaction
FROM transactions
where EXTRACT(MINUTE from transaction_timestamp) <= 10
)

select COUNT(merchant_id) as payment_count from cte where 
EXTRACT(MINUTE FROM transaction_timestamp)-EXTRACT(MINUTE FROM prev_transaction)
<= 10
--ex7
SELECT category, product, total_spend
FROM (
  SELECT 
    category, 
    product, 
    SUM(spend) total_spend, 
    ROW_NUMBER() OVER (
            PARTITION BY category 
            ORDER BY SUM(spend) DESC
        ) grossing_rank
  FROM product_spend
  WHERE EXTRACT(year FROM transaction_date) = '2022'
  GROUP BY category, product
) product_spend_aggregated
WHERE grossing_rank <= 2;
--ex8
SELECT 
  category, 
  product, 
  total_spend 
FROM (
  SELECT 
    category, 
    product, 
    SUM(spend) AS total_spend,
    RANK() OVER (
      PARTITION BY category 
      ORDER BY SUM(spend) DESC) AS ranking 
  FROM product_spend
  WHERE EXTRACT(YEAR FROM transaction_date) = 2022
  GROUP BY category, product
) AS ranked_spending
WHERE ranking <= 2 
ORDER BY category, ranking;
