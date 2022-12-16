--How many products are being purchased more than once?
--Do the products being purchased again have better sales than others?
--What products are more likely to be purchased again for different types of pets?
SELECT *
FROM petmindsales
WHERE re_buy = '1';

SELECT ROUND(AVG(sales), 2),
	product_category
FROM petmindsales
GROUP BY product_category
ORDER BY ROUND(AVG(sales), 2) DESC;

SELECT COUNT(product_category) AS product_rebuy,
	SUM(sales) AS sales_per_category,
	ROUND(AVG(sales), 2) AS avg_sales_category,
	product_category
FROM (SELECT *
FROM petmindsales
WHERE re_buy = '1') AS repurchased
GROUP BY product_category
ORDER BY sales_per_category DESC;

COPY (SELECT COUNT(product_category) AS product_rebuy,
	product_category
FROM (SELECT *
FROM petmindsales
WHERE re_buy = '1') AS repurchased
GROUP BY product_category
ORDER BY product_rebuy DESC) TO '/Users/drakemcadow/Downloads/products_repurchased_cat.csv' DELIMITER ',' CSV HEADER;

CREATE VIEW rebuy_product_category AS 
SELECT COUNT(product_category) AS product_rebuy,
	SUM(sales) AS sales_per_category,
	ROUND(AVG(sales), 2) AS avg_sales_category,
	product_category
FROM (SELECT *
FROM petmindsales
WHERE re_buy = '1') AS repurchased
GROUP BY product_category
ORDER BY sales_per_category DESC;

SELECT * 
FROM rebuy_product_category;

SELECT COUNT(product_category) AS product_not_rebuy,
	SUM(sales) AS sales_per_category,
	ROUND(AVG(sales), 2) AS avg_sales_category,
	product_category
FROM (SELECT *
FROM petmindsales
WHERE re_buy = '0') AS not_repurchased
GROUP BY product_category
ORDER BY sales_per_category DESC;

CREATE VIEW not_rebuy_product_category AS 
SELECT COUNT(product_category) AS product_not_rebuy,
	SUM(sales) AS sales_per_category,
	ROUND(AVG(sales), 2) AS avg_sales_category,
	product_category
FROM (SELECT *
FROM petmindsales
WHERE re_buy = '0') AS not_repurchased
GROUP BY product_category
ORDER BY sales_per_category DESC;

SELECT SUM(pm.sales) AS total_sales,
	rpc.sales_per_category AS rpc_sales,
	nrpc.sales_per_category AS nrpc_sales,
	rpc.avg_sales_category AS rpc_avg,
	nrpc.avg_sales_category AS nrpc_avg,
	rpc.product_rebuy,
	nrpc.product_not_rebuy,
	pm.product_category
FROM petmindsales AS pm
INNER JOIN rebuy_product_category AS rpc
ON pm.product_category = rpc.product_category
INNER JOIN not_rebuy_product_category AS nrpc
ON rpc.product_category = nrpc.product_category
GROUP BY pm.product_category, 
	rpc.sales_per_category,
	nrpc.sales_per_category,
	rpc.avg_sales_category,
	nrpc.avg_sales_category,
	rpc.product_rebuy,
	nrpc.product_not_rebuy
ORDER BY total_sales DESC;

COPY (SELECT SUM(pm.sales) AS total_sales,
	rpc.sales_per_category AS rpc_sales,
	nrpc.sales_per_category AS nrpc_sales,
	rpc.avg_sales_category AS rpc_avg,
	nrpc.avg_sales_category AS nrpc_avg,
	rpc.product_rebuy,
	nrpc.product_not_rebuy,
	pm.product_category
FROM petmindsales AS pm
INNER JOIN rebuy_product_category AS rpc
ON pm.product_category = rpc.product_category
INNER JOIN not_rebuy_product_category AS nrpc
ON rpc.product_category = nrpc.product_category
GROUP BY pm.product_category, 
	rpc.sales_per_category,
	nrpc.sales_per_category,
	rpc.avg_sales_category,
	nrpc.avg_sales_category,
	rpc.product_rebuy,
	nrpc.product_not_rebuy
ORDER BY total_sales DESC) TO '/Users/drakemcadow/Downloads/products_repurchased_VS_not_cat.csv' DELIMITER ',' CSV HEADER;

COPY (WITH rebuy_pet_type AS
(SELECT product_category,
	pet_size,
	pet_type,
	re_buy,
	sales,
	product_volume
FROM petmindsales
WHERE re_buy = '1'
ORDER BY sales DESC)
SELECT COUNT(*) AS products,
	product_category,
	pet_size,
	pet_type,
	SUM(product_volume) AS product_volume,
	SUM(sales) AS sales_product
FROM rebuy_pet_type
GROUP BY (2,3,4)
ORDER BY sales_product DESC) TO '/Users/drakemcadow/Downloads/most_likely_repurchase_type.csv' DELIMITER ',' CSV HEADER;
