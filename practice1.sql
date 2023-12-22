--ex1
select NAME from CITY where countrycode = "USA" and population > 120000;
--ex2
select * from CITY where countrycode = "JPN";
--ex3
select city, state from station;
--ex4
select distinct CITY from STATION where CITY like "A%" or  city like "E%" or  city like "I%" or city like "O%" or city like "U%"
--ex5
SELECT DISTINCT CITY FROM STATION WHERE CITY LIKE "%A" OR CITY LIKE "%E" OR CITY LIKE "%I" OR CITY LIKE "%O" OR CITY LIKE "%U"
--ex6
select distinct CITY from STATION where CITY not like "A%" and city not like "E%" and city not like "I%" and city not like "O%" and city not like "U%"
--ex7
select name from employee order by name asc
--ex8
select name from employee where salary >2000 and months < 10 order by employee_id asc 
--ex9
select product_id from products where low_fats = "y" and recyclable = "y" 
--ex10
select name from customer where referee_id <>2 or referee_id is null 
--ex11
select name ,population, area from world where area >= 3000000 or population >= 25000000
--ex12
select distinct author_id as "id" from views where author_id = viewer_id order by author_id
--ex13
SELECT part, assembly_step FROM parts_assembly where finish_date is null
--ex14
select * from lyft_drivers where yearly_salary <= 30000 or yearly_salary >=70000
--ex15
select advertising_channel from uber_advertising where money_spent > 100000 and year =2019
