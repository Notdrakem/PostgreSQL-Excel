/*What is the correlation between monthly bitcoin price data and price data for commodoties/the S&P 500*/

--Creating new table for monthly bitcoin price data

CREATE TABLE IF NOT EXISTS bitcoin_data (
date DATE NOT NULL,
open FLOAT NOT NULL,
high FLOAT NOT NULL,
low FLOAT NOT NULL,
close FLOAT NOT NULL,
adj_close FLOAT NOT NULL,
volume FLOAT NOT NULL);

SELECT *
FROM bitcoin_data;

--updating the volume column so the data is easier to read, rename to volume_millions

UPDATE bitcoin_data
SET volume = volume/1000000
RETURNING volume AS volume_millions;

ALTER TABLE bitcoin_data
RENAME volume TO volume_millions;

--looking at max and min values, difference between MAX and MIN values

SELECT 
	MIN(date),
	MAX(date),
	MIN(open),
	MAX(open),
	MIN(high),
	MAX(high),
	MIN(low),
	MAX(low),
	MIN(close),
	MAX(close),
	MIN(adj_close),
	MAX(adj_close),
	MIN(volume_millions),
	MAX(volume_millions)
FROM bitcoin_data;

SELECT 
	TO_CHAR(MAX(open)-MIN(open), 'L99999D99') AS open_diff,
	TO_CHAR(MAX(high)-MIN(high), 'L99999D99') AS high_diff,
	TO_CHAR(MAX(low)-MIN(low), 'L99999D99') AS low_diff,
	TO_CHAR(MAX(adj_close)-MIN(adj_close), 'L99999D99') AS close_diff,
	MAX(volume_millions)-MIN(volume_millions) AS volume_millions_diff
FROM bitcoin_data;
	
--finding the difference between the 1st month of data and last

SELECT 
	date,
	open,
	high,
	low,
	close,
	volume_millions
FROM bitcoin_data
WHERE date IN (
SELECT MAX(date)
FROM bitcoin_data)
UNION
SELECT 
	date,
	open,
	high,
	low,
	close,
	volume_millions
FROM bitcoin_data
WHERE date IN (
SELECT MIN(date)
FROM bitcoin_data);

WITH recent AS (
SELECT 
	date,
	open,
	high,
	low,
	close,
	volume_millions
FROM bitcoin_data
WHERE date IN (
SELECT MAX(date)
FROM bitcoin_data)),

	first AS (
SELECT 
	date,
	open,
	high,
	low,
	close,
	volume_millions
FROM bitcoin_data
WHERE date IN (
SELECT MIN(date)
FROM bitcoin_data))

SELECT 
	(SELECT COUNT(date)
	FROM bitcoin_data) AS total_months,
	TO_CHAR(r.open-f.open, 'L99999D99') AS open_diff_firstmonth_recent_month,
	TO_CHAR(r.high-f.high, 'L99999D99') AS high_diff_firstmonth_recent_month,
	TO_CHAR(r.low-f.low, 'L99999D99') AS low_diff_firstmonth_recent_month,
	TO_CHAR(r.close-f.close, 'L99999D99') AS close_diff_firstmonth_recent_month,
	TO_CHAR(r.volume_millions-f.volume_millions, '999999D99 "Million"') AS volume_millions_diff_firstmonth_recent_month
FROM first AS f
CROSS JOIN recent AS r;
			
--Data grouped by Month, Year averages

SELECT
	DATE_PART('month', date) AS month,
	AVG(open),
	AVG(high),
	AVG(low),
	AVG(close),
	AVG(volume_millions)
FROM bitcoin_data
GROUP BY month
ORDER BY month ASC;

SELECT
	DATE_PART('year', date) AS year,
	AVG(open),
	AVG(high),
	AVG(low),
	AVG(close),
	AVG(volume_millions)
FROM bitcoin_data
GROUP BY year
ORDER BY year ASC;

--average grouped by year/month descending high's and opens/ volume

SELECT
	DATE_PART('month', date) AS month,
	AVG(open),
	AVG(high),
	AVG(low),
	AVG(close),
	AVG(volume_millions)
FROM bitcoin_data
GROUP BY month
ORDER BY AVG(high) DESC, AVG(volume_millions) DESC;
--Interesting over 7 years winter-March has the highest average

SELECT
	DATE_PART('year', date) AS year,
	AVG(open),
	AVG(high),
	AVG(low),
	AVG(close),
	AVG(volume_millions)
FROM bitcoin_data
GROUP BY year
ORDER BY AVG(high) DESC, AVG(volume_millions) DESC;
--2021 with the highest AVG High but 2nd highest volume, 2018 with most volume,
--points to more instutional investors in 2021 likely

--difference in opening and close and volume each month

SELECT 
	date,
	ROUND(CAST(open AS NUMERIC), 2),
	ROUND(CAST(COALESCE(open - LAG(open, 1) OVER (ORDER BY date), 0) AS NUMERIC), 2) AS month_to_month_open,
	ROUND(CAST(close AS NUMERIC), 2),
	ROUND(CAST(COALESCE(close - LAG(close, 1) OVER (ORDER BY date), 0) AS NUMERIC), 2) AS month_to_month_close,
	ROUND(CAST(volume_millions AS NUMERIC), 2),
	ROUND(CAST(COALESCE(volume_millions - LAG(volume_millions, 1) OVER (ORDER BY date), 0) AS NUMERIC), 2) AS month_to_month_volume
FROM bitcoin_data;

--difference year over year
SELECT 
	year,
	ROUND(CAST(avg_o AS NUMERIC), 2) AS open,
	ROUND(CAST(COALESCE(avg_o - LAG(avg_o, 1) OVER (ORDER BY year), 0) AS NUMERIC), 2) AS year_to_year_open,
	ROUND(CAST(avg_c AS NUMERIC), 2) AS close,
	ROUND(CAST(COALESCE(avg_c - LAG(avg_c, 1) OVER (ORDER BY year), 0) AS NUMERIC), 2) AS year_to_year_close,
	ROUND(CAST(avg_v AS NUMERIC), 2) AS volume,
	ROUND(CAST(COALESCE(avg_v - LAG(avg_v, 1) OVER (ORDER BY year), 0) AS NUMERIC), 2) AS year_to_year_volume
FROM (SELECT
	DATE_PART('year', date) AS year,
	AVG(open) AS avg_o,
	AVG(high) AS avg_h,
	AVG(low) AS avg_l,
	AVG(close) AS avg_c,
	AVG(volume_millions) AS avg_v
FROM bitcoin_data
GROUP BY year
ORDER BY AVG(high) DESC, AVG(volume_millions) DESC) AS subq_year;
--year to year difference in 2021 to 2021 is drastic!

-- difference between open and close and vol as a percentage month to month 

SELECT 
	date,
	ROUND(CAST(open AS NUMERIC), 2) AS open,
	ROUND(CAST(COALESCE(open - LAG(open, 1) OVER (ORDER BY date), 0) AS NUMERIC), 2) AS month_to_month_open_diff,
	TO_CHAR(ROUND(CAST(ROUND(CAST(COALESCE(open - LAG(open, 1) OVER (ORDER BY date), 0) AS NUMERIC), 2)/open * 100 AS NUMERIC), 2), '%99D99') AS percentage_diff_open_m2m,
	ROUND(CAST(close AS NUMERIC), 2) AS close,
	TO_CHAR(ROUND(CAST(ROUND(CAST(COALESCE(close - LAG(close, 1) OVER (ORDER BY date), 0) AS NUMERIC), 2)/close * 100 AS NUMERIC), 2), '%99D99') AS percentage_diff_close_m2m,
	ROUND(CAST(volume_millions AS NUMERIC), 2) AS volume,
	TO_CHAR(ROUND(CAST(ROUND(CAST(COALESCE(volume_millions - LAG(volume_millions, 1) OVER (ORDER BY date), 0) AS NUMERIC), 2)/volume_millions * 100 AS NUMERIC), 2), '%99D99') AS percentage_diff_vol_m2m
FROM bitcoin_data;

--overall ranking of months/year

SELECT
	date,
	open,
	RANK() OVER (ORDER BY open DESC) AS best_open_ranked,
	close,
	RANK() OVER (ORDER BY close DESC) AS best_close_ranked,
	volume_millions,
	RANK() OVER (ORDER BY volume_millions DESC) AS best_vol_ranked
FROM bitcoin_data
ORDER BY best_open_ranked, best_close_ranked, best_vol_ranked;

--by year

SELECT
	year,
	avg_o,
	RANK() OVER (ORDER BY avg_o DESC) AS best_open_ranked,
	avg_c,
	RANK() OVER (ORDER BY avg_c DESC) AS best_close_ranked,
	avg_v,
	RANK() OVER (ORDER BY avg_v DESC) AS best_vol_ranked
FROM (SELECT
	DATE_PART('year', date) AS year,
	AVG(open) AS avg_o,
	AVG(high) AS avg_h,
	AVG(low) AS avg_l,
	AVG(close) AS avg_c,
	AVG(volume_millions) AS avg_v
FROM bitcoin_data
GROUP BY year
ORDER BY AVG(high) DESC, AVG(volume_millions) DESC) AS subq_year
ORDER BY best_open_ranked, best_close_ranked, best_vol_ranked;

--bring in S&P 500 data for comparison

CREATE TABLE IF NOT EXISTS sp500_commodities (
date DATE NOT NULL,
corn_usd_per_bu NUMERIC NOT NULL,
soybean_usd_per_bu NUMERIC NOT NULL,
wheat_usd_per_bu NUMERIC NOT NULL,
crude_oil_usd_per_barrel NUMERIC NOT NULL,
sp_500_usd NUMERIC NOT NULL);

SELECT *
FROM sp500_commodities;

--Grouping the sp/commodity data into months to match the bitcoin data, 2014 and on

SELECT
CAST(DATE_TRUNC('month', date) AS DATE) AS month,
ROUND(AVG(sp_500_usd),3) AS avg_sp500_month,
ROUND(AVG(corn_usd_per_bu),3) AS avg_corn_month,
ROUND(AVG(soybean_usd_per_bu),3) AS avg_soybean_month,
ROUND(AVG(wheat_usd_per_bu),3) AS avg_wheat_month,
ROUND(AVG(crude_oil_usd_per_barrel),3) AS avg_oil_month
FROM sp500_commodities
WHERE DATE_TRUNC('month', date) >= '2014-10-01'
GROUP BY month
ORDER BY month;

CREATE  monthly_sp500_comms_data AS 
SELECT
	CAST(DATE_TRUNC('month', date) AS DATE) AS month,
	ROUND(AVG(sp_500_usd),3) AS avg_sp500_month,
	ROUND(AVG(corn_usd_per_bu),3) AS avg_corn_month,
	ROUND(AVG(soybean_usd_per_bu),3) AS avg_soybean_month,
	ROUND(AVG(wheat_usd_per_bu),3) AS avg_wheat_month,
	ROUND(AVG(crude_oil_usd_per_barrel),3) AS avg_oil_month
FROM sp500_commodities
WHERE DATE_TRUNC('month', date) >= '2014-10-01'
GROUP BY month
ORDER BY month;

SELECT *
INTO TABLE sp500_comms
FROM monthly_sp500_comms_data;

SELECT *
FROM sp500_comms;

--grouped by year

SELECT
TO_CHAR(CAST(DATE_TRUNC('year', date) AS DATE), 'yyyy') AS year,
ROUND(AVG(corn_usd_per_bu),3) AS avg_corn_year,
ROUND(AVG(soybean_usd_per_bu),3) AS avg_soybean_year,
ROUND(AVG(wheat_usd_per_bu),3) AS avg_wheat_year,
ROUND(AVG(crude_oil_usd_per_barrel),3) AS avg_oil_year
FROM sp500_commodities
WHERE DATE_TRUNC('year', date) >= '2014-10-01'
GROUP BY year
ORDER BY year;

--Averaging bitcoin data so there is only one value to compare to sp/comms

SELECT
	date,
	(((open+close)/2) + ((high+low)/2))/2 AS avg_bitcoin_month
FROM bitcoin_data;

--year

SELECT
	DATE_PART('year', date) AS year,
	AVG((((open+close)/2) + ((high+low)/2))/2) AS avg_bitcoin_year
FROM bitcoin_data
GROUP BY year
ORDER BY year;

CREATE VIEW bitcoin_avg_monthly AS
SELECT
	date,
	(((open+close)/2) + ((high+low)/2))/2 AS avg_bitcoin_month
FROM bitcoin_data;

SELECT *
FROM bitcoin_avg_monthly;

--Add in last 8 months of data for 2022 to sp500/comms then join tables

INSERT INTO sp500_comms (
	month, 
	avg_sp500_month, 
	avg_corn_month,
	avg_soybean_month,
	avg_wheat_month, 
	avg_oil_month)
VALUES (
	'2022-05-01', 3937.385, 7.540, 16.830, 10.880, 109.550),
	('2022-06-01', 3943.250, 7.700, 16.700, 9.760, 114.840),
	('2022-07-01', 4086.798, 6.190, 16.420, 9.380, 101.620),
	('2022-08-01', 3806.440, 6.740, 15.110, 8.990, 93.670),
	('2022-09-01', 3716.690, 6.780, 13.660, 9.570, 84.260),
	('2022-10-01', 3940.040, 6.920, 14.060, 9.570, 87.550),
	('2022-11-01', 3948.023, 6.620, 14.700, 9.270, 84.370),
	('2022-12-01', 3907.376, 6.790, 15.090, 8.960, 76.440);
	
SELECT *
FROM sp500_comms;

CREATE VIEW updated_sp500_comms_monthly AS
SELECT *
FROM sp500_comms;

SELECT *
FROM updated_sp500_comms_monthly;

--used a temp table to insert the data into the grouped query, then created a view so that it would be easier to work with in the future.

--join views and analyze data, visualize

SELECT
	b.date,
	ROUND(CAST(b.avg_bitcoin_month AS NUMERIC), 3) AS bitcoin_avg,
	sp.avg_sp500_month,
	sp.avg_corn_month,
	sp.avg_soybean_month,
	sp.avg_wheat_month,
	sp.avg_oil_month
FROM bitcoin_avg_monthly AS b
JOIN updated_sp500_comms_monthly AS sp
	ON b.date = sp.month
ORDER BY b.date;

CREATE VIEW combined_data_vis AS
SELECT
	b.date,
	ROUND(CAST(b.avg_bitcoin_month AS NUMERIC), 3) AS bitcoin_avg,
	sp.avg_sp500_month,
	sp.avg_corn_month,
	sp.avg_soybean_month,
	sp.avg_wheat_month,
	sp.avg_oil_month
FROM bitcoin_avg_monthly AS b
JOIN updated_sp500_comms_monthly AS sp
	ON b.date = sp.month
ORDER BY b.date;

SELECT *
FROM combined_data_vis;

--further analyzing the combined data looking for insights

/*each row against the overall average of each column, 
top 5 ranked months of each field and the other fields to compare, 
percentage difference for each field, 
top 5 ranking based on the 5 months with the greatest 
percentage increases month to month*/

SELECT
	date,
	bitcoin_avg,
	ROUND(AVG(SUM(bitcoin_avg)) OVER (ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING), 3) AS bitcoin_total_avg,
	avg_sp500_month,
	ROUND(AVG(SUM(avg_sp500_month)) OVER (ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING), 3) AS sp500_total_avg,
	avg_corn_month,
	ROUND(AVG(SUM(avg_corn_month)) OVER (ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING), 3) AS corn_total_avg,
	avg_soybean_month,
	ROUND(AVG(SUM(avg_soybean_month)) OVER (ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING), 3) AS soybean_total_avg,
	avg_wheat_month,
	ROUND(AVG(SUM(avg_wheat_month)) OVER (ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING), 3) AS wheat_total_avg,
	avg_oil_month,
	ROUND(AVG(SUM(avg_oil_month)) OVER (ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING), 3) AS oil_total_avg
FROM combined_data_vis
GROUP BY date, bitcoin_avg, avg_sp500_month, avg_corn_month, avg_soybean_month, avg_wheat_month, avg_oil_month;

CREATE TEMP TABLE total_avgs AS 
SELECT
	date,
	bitcoin_avg,
	ROUND(AVG(SUM(bitcoin_avg)) OVER (ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING), 3) AS bitcoin_total_avg,
	avg_sp500_month,
	ROUND(AVG(SUM(avg_sp500_month)) OVER (ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING), 3) AS sp500_total_avg,
	avg_corn_month,
	ROUND(AVG(SUM(avg_corn_month)) OVER (ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING), 3) AS corn_total_avg,
	avg_soybean_month,
	ROUND(AVG(SUM(avg_soybean_month)) OVER (ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING), 3) AS soybean_total_avg,
	avg_wheat_month,
	ROUND(AVG(SUM(avg_wheat_month)) OVER (ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING), 3) AS wheat_total_avg,
	avg_oil_month,
	ROUND(AVG(SUM(avg_oil_month)) OVER (ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING), 3) AS oil_total_avg
FROM combined_data_vis
GROUP BY date, bitcoin_avg, avg_sp500_month, avg_corn_month, avg_soybean_month, avg_wheat_month, avg_oil_month;

--months where the monthly averages are greater than the total average to see where prices start to really spike.
SELECT
	date,
	bitcoin_avg
FROM total_avgs
WHERE bitcoin_avg>bitcoin_total_avg
ORDER BY bitcoin_avg DESC;

SELECT
	date,
	avg_sp500_month
FROM total_avgs
WHERE avg_sp500_month>sp500_total_avg
ORDER BY avg_sp500_month DESC;

SELECT
	date,
	avg_corn_month
FROM total_avgs
WHERE avg_corn_month>corn_total_avg
ORDER BY avg_corn_month DESC;

SELECT
	date,
	avg_soybean_month
FROM total_avgs
WHERE avg_soybean_month>soybean_total_avg
ORDER BY avg_soybean_month DESC;

SELECT
	date,
	avg_wheat_month
FROM total_avgs
WHERE avg_wheat_month>wheat_total_avg
ORDER BY avg_wheat_month DESC;

SELECT
	date,
	avg_oil_month
FROM total_avgs
WHERE avg_oil_month>oil_total_avg
ORDER BY avg_oil_month DESC;