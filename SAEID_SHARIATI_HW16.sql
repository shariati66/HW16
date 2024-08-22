
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
WITH CustomerSaleDetails(CustomerId,SaleCount,TotalSaleCost,PayAmount,DiscountAmount) AS(
SELECT  OS.customer_id,COUNT(*),SUM(IT.list_price),ROUND(SUM(IT.list_price - (IT.list_price * IT.discount)),2),SUM(IT.list_price * IT.discount) AS DiscountAmount
FROM SALES.orders OS INNER JOIN SALES.order_items IT 
ON OS.order_id = IT.order_id  
WHERE customer_id = 114
GROUP BY OS.customer_id)
SELECT CSD.CustomerId,SC.first_name,SC.last_name,SC.city,CSD.SaleCount AS [Sale Count]
,CSD.TotalSaleCost AS [Total Sale Cost],CSD.DiscountAmount AS [Discount Amount],
CSD.PayAmount As [Customer Must Pay]
from CustomerSaleDetails CSD LEFT JOIN sales.customers SC
ON CSD.CustomerId = SC.customer_id

--نوشتن بدون استفاده از گروپ بای
/*جدولی شامل فیلدهای سوال که قیمت آنها کمتر از 1000 دلار باشد*/
WITH ProductData AS (
    SELECT PR.product_id,PR.product_name,BR.brand_id,BR.brand_name,
        ROW_NUMBER() OVER (ORDER BY PR.product_id) AS row_num
    FROM 
        production.products PR 
    INNER JOIN 
        production.brands BR
    ON 
        BR.brand_id = PR.brand_id
    WHERE 
        PR.list_price < 1000
)
SELECT 
    product_id,product_name,brand_id,brand_name
FROM 
    ProductData
ORDER BY 
    row_num;

-- مجموع کل تعداد محصول در کلیه فروشگاه ها
SELECT DISTINCT PR.product_id,PR.product_name,
    ISNULL(SUM(PS.quantity) OVER (PARTITION BY PR.product_id, PR.product_name), 0) AS [Total Numbers]
FROM 
    production.stocks PS 
INNER JOIN 
    production.products PR 
ON 
    PS.product_id = PR.product_id
ORDER BY 
    PR.product_id,
    PR.product_name;

--جمع تعداد همه محصولات 

	SELECT DISTINCT  SS.store_id,SS.store_name,SUM(PS.quantity) OVER (PARTITION BY SS.store_id, SS.store_name) AS [Total Numbers]
FROM 
    production.stocks PS 
INNER JOIN 
    sales.stores SS 
ON 
    SS.store_id = PS.store_id
ORDER BY 
    SS.store_id;

--تعداد کل آیتم ها و مبلغ کل خرید مشتری با آی دی 114
WITH CustomerSaleDetails AS (
    SELECT
        OS.customer_id,
        COUNT(*) OVER (PARTITION BY OS.customer_id) AS SaleCount,
        ROUND(SUM(IT.list_price - (it.list_price * IT.discount)) OVER (PARTITION BY OS.customer_id), 2) AS TotalSaleCost
    FROM 
        SALES.orders OS 
    INNER JOIN 
        SALES.order_items IT 
    ON 
        OS.order_id = IT.order_id  
    WHERE 
        OS.customer_id = 114
)
SELECT 
    DISTINCT
    CSD.customer_id,
    SC.first_name,
    SC.last_name,
    SC.city,
    CSD.SaleCount AS [Sale Count],
    CSD.TotalSaleCost AS [Total Sale Cost]
FROM 
    CustomerSaleDetails CSD 
LEFT JOIN 
    sales.customers SC
ON 
    CSD.customer_id = SC.customer_id;





