--ex1
select distinct city from station where ID%2=0
--ex2
select count(city) - count(distinct city) from station
--ex4
SELECT 
round(cast(sum(item_count * order_occurrences) / sum (order_occurrences)) as decimal),1) as mean
FROM items_per_order;
--ex5
SELECT candidate_id FROM candidates where skill in ('Python','Tableau', 'PostgreSQL')
GROUP BY candidate_id having count (skill) = 3
--ex6
SELECT user_id, date (max (post_date))- date(min (post_date)) as day_between
FROM posts where post_date >= '2021-01-01' and post_date <= '2022-01-01'
group by user_id having count (post_id)>=2
--ex7
SELECT card_name, max(issued_amount) - min (issued_amount) as difference
FROM monthly_cards_issued group by card_name order by difference DESC
--ex8 ( syntax error at or near "ABS") ??
SELECT manufacturer, count (drug) as drug_count
  abs (sum(cogs-total_sales)) as total_loss
FROM pharmacy_sales
where total_sales < cogs 
group by manufacturer 
order by total_loss DESC 
--ex9
select * from cinema where id%2 = 1 and description <> "boring" order by rating DESC
--ex10
Select teacher_id, COUNT(Distinct subject_id) as cnt from Teacher group by teacher_id
--ex11
select user_id, COUNT(follower_id) as followers_count from Followers group by user_id order by user_id
--ex12
select class from Courses 
group by class having COUNT(student)>= 5 
