
/*جدولی شامل فیلدهای سوال که قیمت آنها کمتر از 1000 دلار باشد*/
SELECT PR.product_id,PR.product_name,
BR.brand_id,BR.brand_name
FROM production.products PR INNER JOIN production.brands BR
ON BR.brand_id = PR.brand_id
WHERE PR.list_price < 1000
ORDER BY product_id;

-- مجموع کل تعداد محصول در کلیه فروشگاه ها
SELECT PR.product_id,PR.product_name,ISNULL(SUM(PS.quantity),0) as [Total Numbers]
FROM production.stocks PS INNER JOIN production.products PR 
ON PS.product_id = PR.product_id
GROUP BY PR.product_id,PR.product_name
ORDER BY PR.product_id,PR.product_name;
--جمع تعداد همه محصولات 

SELECT SS.store_id,SS.store_name,SUM(PS.quantity) AS [Total Numbers]
FROM production.stocks PS INNER JOIN sales.stores SS 
ON SS.store_id = PS.store_id
GROUP BY SS.store_id,SS.store_name
ORDER BY SS.store_id;

--تعداد کل آیتم ها و مبلغ کل خرید مشتری با آی دی 114
WITH CustomerSaleDetails(CustomerId,SaleCount,TotalSaleCost) AS(
SELECT  OS.customer_id,COUNT(*), SUM(IT.list_price)
FROM SALES.orders OS INNER JOIN SALES.order_items IT 
ON OS.order_id = IT.order_id  
WHERE customer_id = 114
GROUP BY OS.customer_id)
SELECT CSD.CustomerId,SC.first_name,SC.last_name,SC.city,CSD.SaleCount AS [Sale Count],CSD.TotalSaleCost AS [Total Sale Cost]
from CustomerSaleDetails CSD LEFT JOIN sales.customers SC
ON CSD.CustomerId = SC.customer_id





