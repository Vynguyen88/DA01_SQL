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
