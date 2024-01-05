--ex1
with job_count_final as (
  select
    company_id, 
    title, 
    description, 
    count(job_id) as job_count
  from job_listings
  group by company_id, title, description
)
select count (distinct company_id) as duplicate_companies
from job_count_final
where job_count > 1;
--ex2
--ex3
with call_records as (
select
  policy_holder_id,
  count(case_id) as call_count
from callers
group by policy_holder_id
having count(case_id) >= 3
)
select count (policy_holder_id) as member_count
from call_records;
--ex4
select pg.page_id from pages pg 
left join page_likes pl 
on pg.page_id = pl.page_id 
where pl.page_id is NULL 
order by pg.page_id Asc
--ex5
with active_users_cte as (
  select distinct
    curr_month.user_id,
    extract(month from curr_month.event_date) as curr_month
from (
    select * from user_actions
    Where exract (month from event_date) = 
      (select extract(month from max(event_date)) from user_actions)
    ) curr_month
  join user_actions as last_month
    on curr_month.user_id = last_month.user_id
    and extract(month from curr_month.event_date) =
      extract(month from last_month.event_date + interval '1 month')
)

select
  curr_month,
  count(user_id) as num_active_users
from active_users_cte
group by curr_month
--ex6 (HELP)
with transactions as (
select EXTRACT('year' from trans_date) as year, EXTRACT('month' from trans_date) as month, country, count(*) as trans_count, sum(amount) as trans_total_amount
from Transactions
group by EXTRACT('year' from trans_date), EXTRACT('month' from trans_date), country
),

approved_transactions as (
select EXTRACT('year' from trans_date) as year, EXTRACT('month' from trans_date) as month, country, count(*) as approved_count, sum(amount) as approved_total_amount
from Transactions
where state='approved'
group by EXTRACT('year' from trans_date), EXTRACT('month' from trans_date), country
)

select to_date(CONCAT(year, '/', month), 'YYYY/MM') as month, country, t.trans_count, t.trans_total_amount, ta.approved_count, ta.approved_total_amount
from transactions t
join approved_transactions at
on t.month = at.month
and t.country = at.country
--ex7
select product_id, year as first_year, quantity,price
from Sales
where (product_id,year) in (
select product_id,min(year)
from Sales
group by product_id
)
--ex8
select customer_id from customer 
group by 
customer_id
having count(distinct product_key ) = (select count(product_key ) from product)
--ex9
select employee_id
from Employees as a
where manager_id not in (select employee_id from employees) and salary < 30000
order by employee_id ASC
--ex10
with job_count_final as (
  select
    company_id, 
    title, 
    description, 
    count(job_id) as job_count
  from job_listings
  group by company_id, title, description
)

select count (distinct company_id) as duplicate_companies
from job_count_final
where job_count > 1;
--ex11
--ex12
with CTE as(
select requester_id , accepter_id
from RequestAccepted
union all
select accepter_id , requester_id
from RequestAccepted
)
select requester_id id, count(accepter_id) num
from CTE
group by 1
order by 2 desc
limit 1
