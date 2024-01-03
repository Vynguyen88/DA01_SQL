--Q1
select distinct replacement_cost from film order by replacement_cost
--Q2
select
case when replacement_cost between 9.99 and 19.99 then 'low'
when replacement_cost between 20 and 24.99 then 'medium'
else 'high'
end as category,count (*) as so_luong
from film group by category
--q3
