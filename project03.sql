--1) Doanh thu theo từng ProductLine, Year  và DealSize?
Output: PRODUCTLINE, YEAR_ID, DEALSIZE, REVENUE--

SELECT sum (quantityordered * priceeach) as revenue, year_id, dealsize, productline
FROM public.sales_dataset_rfm_prj
GROUP BY   year_id, dealsize, productline
--2) Đâu là tháng có bán tốt nhất mỗi năm?--

SELECT year_id, month_id, ordernumber, SUM(quantityordered*priceeach)  AS revenue
FROM public.sales_dataset_rfm_prj
GROUP BY  month_id , ordernumber , year_id
order by revenue DESC


--3) 3) Product line nào được bán nhiều ở tháng 11?
Output: MONTH_ID, REVENUE, ORDER_NUMBER--

SELECT productline, month_id, ordernumber, SUM(quantityordered*priceeach)  AS revenue
FROM public.sales_dataset_rfm_prj
where month_id = 11
GROUP BY  month_id , ordernumber , productline
order by revenue DESC

--4)4) Đâu là sản phẩm có doanh thu tốt nhất ở UK mỗi năm? 
Xếp hạng các các doanh thu đó theo từng năm.
Output: YEAR_ID, PRODUCTLINE,REVENUE, RANK--


SELECT * FROM
(
select year_id, country, productline, 
sum(quantityordered * priceeach) as revenue,
RANK() OVER(PARTITION BY year_id ORDER BY sum(quantityordered * priceeach)DESC) AS rank1
from public.sales_dataset_rfm_prj
GROUP BY year_id,country
where country is "UK"

--5) 5) Ai là khách hàng tốt nhất, phân tích dựa vào RFM 
(sử dụng lại bảng customer_segment ở buổi học 23)--
create table segment_score
(segment varchar,
scores varchar)

  
with customer_rfm  as 
	(select customername, current_date - max (orderdate) as R, 
count (distinct ordernumber) as F, 
sum (sales) as M
from public.sales_dataset_rfm_prj
group by customername)
select customername, 
  , rfm_score as 
ntile (5) over (order by R DESC) as r_score,
ntile (5) over (order by F ) as f_score,
ntile (5) over (order by M ) as m_score
from customer_rfm)
  , rfm_final as 
(select customername, 
cast (r_score as varchar) ||cast (f_score) as varchar || cast (m_score) as varchar as rfm_score
from rfm_score)
  
select segment, count (*)
from a.customername, b.segment from
rfm_final A 
join segment_score B 
on A.rfm_score = B.scores) as a
group by segment
order by count (*)

  

  



