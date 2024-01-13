--Chuyển đổi kiểu dữ liệu phù hợp cho các trường ( sử dụng câu lệnh ALTER) --

alter table SALES_DATASET_RFM_PRJ
alter column quantityordered type numeric using (trim(quantityordered)::numeric);
alter table SALES_DATASET_RFM_PRJ
alter column priceeach type numeric using (trim(priceeach)::numeric);
alter table SALES_DATASET_RFM_PRJ
alter column sales type numeric using (trim(sales)::numeric); 
alter table SALES_DATASET_RFM_PRJ
alter column orderdate type date


--Check NULL/BLANK (‘’)  ở các trường: ORDERNUMBER, QUANTITYORDERED, PRICEEACH, ORDERLINENUMBER, SALES, ORDERDATE--
Select ORDERNUMBER from SALES_DATASET_RFM_PRJ
Where ORDERNUMBER is null;
Select QUANTITYORDERED from SALES_DATASET_RFM_PRJ
Where QUANTITYORDERED is null;
Select PRICEEACH from SALES_DATASET_RFM_PRJ
Where PRICEEACH is null;
Select ORDERLINENUMBER from SALES_DATASET_RFM_PRJ
Where ORDERLINENUMBER is null;
Select SALES from SALES_DATASET_RFM_PRJ
Where SALES is null;
Select ORDERDATE from SALES_DATASET_RFM_PRJ
Where ORDERDATE is null;

--Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME được tách ra từ CONTACTFULLNAME . 
Chuẩn hóa CONTACTLASTNAME, CONTACTFIRSTNAME theo định dạng chữ cái đầu tiên viết hoa, chữ cái tiếp theo viết thường
Gợi ý: ( ADD column sau đó INSERT)--
Alter table public.sales_dataset_rfm_prj
add column contactfirstname varchar (50);
Alter table public.sales_dataset_rfm_prj
add column contactlastname varchar (50);
update public.sales_dataset_rfm_prj
set contactfirstname = substring (contactfullname from 1 for position ( '-' in contactfullname) -1);
update public.sales_dataset_rfm_prj
set contactlastname =SUBSTRING(CONTACTFULLNAME FROM POSITION('-' IN CONTACTFULLNAME) + 1);
update public.sales_dataset_rfm_prj
set contactfirstname = initcap (contactfirstname);
update public.sales_dataset_rfm_prj
set contactlastname = initcap (contactlastname);

--Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là Qúy, tháng, năm được lấy ra từ ORDERDATE-- 
ALTER TABLE  public.sales_dataset_rfm_prj
ADD COLUMN Qtr_ID varchar (20);

ALTER TABLE  public.sales_dataset_rfm_prj
ADD COLUMN Month_id DATE DEFAULT '2023-01-01';

ALTER TABLE  public.sales_dataset_rfm_prj
ADD COLUMN year_id numeric;


--Hãy tìm outlier (nếu có) cho cột QUANTITYORDERED và hãy chọn cách xử lý cho bản ghi đó (2 cách) ( Không chạy câu lệnh trước khi bài được review)--

--Cach 1--
With twt_min_max_value as 
(select Q1-1.5*IQR as min_value, Q3+1.5*IQR as max_value
From (select percentile_cont(0.25) within group (order by QUANTITYORDERED) as Q1, 
percentile_cont(0.75) within group (order by QUANTITYORDERED) as Q3,
percentile_cont(0.75) within group (order by QUANTITYORDERED)- percentile_cont(0.25) within group (order by QUANTITYORDERED) as IQR from 
sales_dataset_rfm_prj ) as a)

select * from sales_dataset_rfm_prj
where QUANTITYORDERED < (Select min_value from twt_min_max_value) or 
QUANTITYORDERED >
 (Select min_value from twt_min_max_value);

--Cach 2--
With cte as 
(Select QUANTITYORDERED,  avg (QUANTITYORDERED) from  sales_dataset_rfm_prj)  as avg, 
(Select stddev(QUANTITYORDERED) from sales_dataset_rfm_prj ) as stddev 
From sales_dataset_rfm_prj) 
Select QUANTITYORDERED, (QUANTITYORDERED- avg) /sttdev as z_score 
From cte
Where abs (QUANTITYORDERED- avg)/ sttddev) > 3



--Sau khi làm sạch dữ liệu, hãy lưu vào bảng mới  tên là SALES_DATASET_RFM_PRJ_CLEAN--
Lưu ý: với lệnh DELETE ko nên chạy trước khi bài được review

