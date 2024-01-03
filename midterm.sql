--Q1
select distinct replacement_cost from film order by replacement_cost
--Q2
select
case when replacement_cost between 9.99 and 19.99 then 'low'
when replacement_cost between 20 and 24.99 then 'medium'
else 'high'
end as category,count (*) as so_luong
from film group by category
--q3: 
select c.title, c.length, a.name from category as a 
join public.film_category as b on a.category_id = b.category_id
join public.film as c on b.film_id = c.film_id
where a.name = 'Drama' or a.name = 'Sports'
order by c.length desc 
--q4
select a.name, count (a.name) as category_count from category as a 
join public.film_category as b on a.category_id = b.category_id
join public.film as c on b.film_id = c.film_id
group by a.name
order by category_count DESC
--q5
select  first_name ||' ' || last_name as full_name, count(film_id) as total_film
from public.actor as a 
full join public.film_actor as b
on a.actor_id = b.actor_id
group by full_name 
order by total_film DESC
--q6
select a.address, b.customer_id
from address as a 
left join customer as b
on a.address_id = b.address_id
where b.customer_id is null
--q7
select city, sum (amount) as city_income
from city as a 
join public.address as b on a.city_id = b.city_id
join public.customer as c on b.address_id = c.address_id
join public.payment as d on c.customer_id = d.customer_id
group by city order by city_income DESC
--q8
select city ||','|| country, sum (amount)as city_income
from city as a 
join public.address as b on a.city_id = b.city_id
join public.customer as c on b.address_id = c.address_id
join public.payment as d on c.customer_id = d.customer_id
join public.country as e on a.country_id = e.country_id
group by city, country order by city_income DESC
