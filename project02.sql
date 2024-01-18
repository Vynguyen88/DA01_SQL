--1. Số lượng đơn hàng và số lượng khách hàng mỗi tháng
Thống kê tổng số lượng người mua và số lượng đơn hàng đã hoàn thành mỗi tháng ( Từ 1/2019-4/2022)
Output: month_year ( yyyy-mm) , total_user, total_orde
Insight là gì? ( nhận xét về sự tăng giảm theo thời gian)--
SELECT
  EXTRACT(MONTH FROM oi.Created_at) AS month_year,
  ROUND(SUM(oi.sale_price * o.num_of_item), 2) AS revenue,
  COUNT(DISTINCT oi.order_id) AS total_order,
  COUNT(DISTINCT oi.user_id) AS total_user
FROM bigquery-public-data.thelook_ecommerce.order_items oi
INNER JOIN `bigquery-public-data.thelook_ecommerce.orders` AS o 
ON oi.order_id = o.order_id
WHERE oi.status NOT IN ('Cancelled', 'Returned')
GROUP BY month_year
ORDER BY revenue DESC;
--insight: Tổng số đơn đặt hàng và tổng số lượng khách hàng  tăng lên.
Tổng số lượng khách hàng mỗi tháng lớn hơn tổng số đơn hàng được đặt. Điều này có nghĩa là khách hàng đặt nhiều đơn hàng cùng một lúc--
--2. Giá trị đơn hàng trung bình (AOV) và số lượng khách hàng mỗi tháng. Thống kê giá trị đơn hàng trung bình và tổng số người dùng khác nhau mỗi tháng 
( Từ 1/2019-4/2022)--
SELECT 
  FORMAT_DATE("%Y-%m", created_at) AS month_year,
  ROUND((SUM(sale_price)/COUNT(DISTINCT order_id)),2) AS Average_order_value,
  COUNT(DISTINCT user_id) AS total_unique_users
FROM `bigquery-public-data.thelook_ecommerce.order_items`
WHERE status = 'Complete'
GROUP BY month_year
ORDER BY month_year DESC;
--insight: số lượng khách hàng tăng theo thời gian, nhưng AOV không biến động nhiều--
--3. Nhóm khách hàng theo độ tuổi. Tìm các khách hàng có trẻ tuổi nhất và lớn tuổi nhất theo từng giới tính ( Từ 1/2019-4/2022)--??
--4. 4.Top 5 sản phẩm mỗi tháng. Thống kê top 5 sản phẩm có lợi nhuận cao nhất từng tháng (xếp hạng cho từng sản phẩm).--
WITH
main AS (
  SELECT  
    name AS product_name
    , products.id AS products_id
    , ROUND(retail_price) AS retail_price
    , ROUND(cost) AS cost
    , SUM(sale_price-cost) AS profit
  FROM `bigquery-public-data.thelook_ecommerce.products` products
  JOIN `bigquery-public-data.thelook_ecommerce.order_items` orders 
    ON products.id = orders.product_id
  WHERE 
    status = 'Complete'
  GROUP BY 1,2,3,4
)
, top_most AS (
    SELECT  *
   , RANK() OVER (ORDER BY profit DESC) AS top_rank
    FROM main
)
SELECT * , 'most profit' AS rank_per_month
FROM top_most
ORDER BY top_rank, rank_per_month DESC
LIMIT 5,
--5.Doanh thu tính đến thời điểm hiện tại trên mỗi danh mục. 
  Thống kê tổng doanh thu theo ngày của từng danh mục sản phẩm (category) trong 3 tháng qua ( giả sử ngày hiện tại là 15/4/2022)--

SELECT
  category AS product_category,
  ROUND(SUM(sale_price * num_of_item), 2) AS revenue,
  EXTRACT(Days FROM oi.Created_at) AS dates,

FROM bigquery-public-data.thelook_ecommerce.order_items oi
INNER JOIN bigquery-public-data.thelook_ecommerce.orders o
ON oi.order_id = o.order_id
INNER JOIN bigquery-public-data.thelook_ecommerce.products p
ON oi.product_id = p.id
WHERE oi.status NOT IN ('cancelled', 'Returned')
GROUP BY category

--6-.Hãy sử dụng câu lệnh SQL để tạo ra 1 dataset như mong muốn và lưu dataset đó vào VIEW đặt tên là vw_ecommerce_analyst--
CREATE TABLE vw_ecommerce_analyst as
(select 
extract (year from a.Created_at) AS year,
EXTRACT(MONTH FROM a.Created_at) AS month,
c.category as Product_category,
sum(b.sale_price* a.num_of_item)  as TPV,
SUM(b.sale_price-c.cost) AS TPO,
sum (round(c.cost,2) as total_cost,
SUM(b.sale_price-c.cost) AS total_profit,
sum (TPV / Total_cost) as profit_to_cost_rastio

FROM bigquery-public-data.thelook_ecommerce.order as a
INNER JOIN `bigquery-public-data.thelook_ecommerce.order_items` AS b
ON a.order_ID = b.order_ID
inner join `bigquery-public-data.thelook_ecommerce.order_items` as c
on b.id = c.id
group by month)
  
--revenue growh--
WITH revenue AS (SELECT category, EXTRACT(MONTH FROM shipped_at) as month_num, FORMAT_DATE('%B', date(shipped_at)) as month_name, ROUND(SUM(sale_price),2) as revenue_per_month
FROM `bigquery-public-data.thelook_ecommerce.order_items` as order_items
INNER JOIN `bigquery-public-data.thelook_ecommerce.products` as products
ON order_items.product_id = products.id
WHERE status = 'Complete'
AND date(shipped_at) >= DATE_SUB(DATE '2023-01-01', interval 1 year) AND date(shipped_at) < '2023-01-01'
GROUP BY 1, 2, 3
ORDER BY 1, 2 DESC),

revenue_lag AS (
SELECT category, month_num, month_name, revenue_per_month,
LAG(revenue_per_month, 1) OVER(PARTITION BY category ORDER BY month_num) as LAG_revenue, ((revenue_per_month - (LAG(revenue_per_month, 1) OVER(PARTITION BY category ORDER BY month_num))) / LAG(revenue_per_month, 1) OVER(PARTITION BY category ORDER BY month_num)) * 100 as growth
FROM revenue
ORDER BY 1, 2 DESC)

SELECT revenue.category, ROUND(AVG(revenue_lag.growth),2) as average_growth_category
FROM revenue
JOIN revenue_lag
ON revenue.category = revenue_lag.category
AND revenue.month_num = revenue_lag.month_num
AND revenue.month_name = revenue_lag.month_name
GROUP BY 1
ORDER BY 2

--oder growth--


