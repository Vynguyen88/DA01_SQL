--ex1
SELECT sum (case when device_type = 'laptop' then 1 else 0 end) as laptop_views, 
sum (case when device_type in ('tablet','phone' ) then 1 else 0 end) as mobile_views
FROM viewership;
--ex2
select x,y,z, case when x+y>z and y+z>x and z+x>y then 'Yes' else 'No' end as triangle
from Triangle
--ex3 ( ko chia duoc cho 0)
SELECT 
ROUND(SUM(CASE WHEN call_category IS NULL or call_category='n/a' THEN 1.0 ELSE 0 END)/COUNT(case_id)*100.0,1)
As call_percentage
FROM callers
--ex4
select name from customer where referee_id <>2 or referee_id is null 
--ex5
select survived, sum (Case when pclass = 1 then 1 else 0 end) as first_class, 
sum (Case when pclass = 2 then 1 else 0 end) as second_class,
sum (Case when pclass = 3 then 1 else 0 end) as third_class
from titanic group by survived
