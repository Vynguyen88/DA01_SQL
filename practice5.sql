--ex1--
select country.continent, floor (avg (city.population)
  from country inner join city on country.code = city.countrycode
  group by country.continent
--ex2--
SELECT
      round(1.0*
      sum(case when signup_action = 'Confirmed' THEN 1 ELSE 0 END)/
      count(signup_action),2) as confirm_rate
from emails as e
inner join texts as t ON e.email_id = t.email_id
--ex3-- HELP!
SELECT age_bucket, 
sum (case when activities.activity_type = 'send' THEN
activites.time_spent ELSE 0 end) as send_timespent,
SUM(CASE WHEN activities.activity_type = 'open' THEN activities.time_spent ELSE 0 END) AS open_timespent,
SUM(activities.time_spent) AS total_timespent 
FROM activities 
full join age_breakdown 
on activities.user_id = age_breakdown.user_id
group by age_bucket
--ex4
SELECT customer_id
from customer_contracts as a
left join products as b 
on a.product_id = b.product_id
GROUP BY customer_id
having count (DISTINCT b.product_category) = 3
--ex 5
select mng.employee_id, mng.name, count (emp.employee_id) as reports_count, round (avg(emp.age), 0) as average_age
from employees as emp
join employees as mng 
on emp.reports_to = mng.employee_id
group by employee_id
--ex6
select p.product_name, sum(o.unit) as unit
from products as p
left join orders as o
on p.product_id = o.product_id
where o.order_date between '2020-02-01' and '2020-02-29'
group by o.product_id
having unit >= 100
order by o.product_id
--ex7
SELECT pg.page_id from pages pg 
LEFT JOIN page_likes pl 
ON pg.page_id = pl.page_id 
where pl.page_id is NULL 
ORDER BY pg.page_id Asc
