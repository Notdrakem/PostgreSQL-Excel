-- Top 100 selling video games globally 
SELECT *
FROM videogames
ORDER BY global_sales DESC
LIMIT 100;

--Inserting missing data into the top 100 selling games when available.

UPDATE videogames
SET developer = 'Nintendo'
WHERE name IN ('Super Mario Bros.', 'Pokemon Red/Pokemon Blue', 'Tetris', 'Duck Hunt', 'Nintendogs', 
			   'Pokemon Gold/Pokemon Silver', 'Super Mario World', 'Pokemon Diamond/Pokemon Pearl', 'Super Mario Land'
			  , 'Super Mario Bros. 3', 'Pokemon Ruby/Pokemon Sapphire',
			   'Brain Age 2: More Training in Minutes a Day','Pokemon Black/Pokemon White', 'Pokémon Yellow: Special Pikachu Edition',
			   'Pokemon X/Pokemon Y', 'Super Mario 64', 'Pokemon HeartGold/Pokemon SoulSilver', 'Pokemon Omega Ruby/Pokemon Alpha Sapphire',
			   'Super Mario Land 2: 6 Golden Coins', 'Super Mario All-Stars', 'Pokemon FireRed/Pokemon LeafGreen', 'Super Mario 64',
			   'Mario Kart 64', 'Donkey Kong Country', 'Super Mario Kart', 'Pokemon Black 2/Pokemon White 2', 'Mario & Sonic at the Olympic Games',
			   'The Legend of Zelda: Ocarina of Time', 'Super Smash Bros. for Wii U and 3DS', 'Super Mario Bros. 2');
			   
UPDATE videogames
SET developer = 'Game Freak'
WHERE name LIKE 'Pok%';

UPDATE videogames
SET developer = 'Treyarch',
 	critic_score = '73',
 	critic_count = '10',
 	user_score= '3.5',
	user_count = '1368',
	rating = 'M'
WHERE name = 'Call of Duty: Black Ops 3';

UPDATE videogames
SET developer = 'Mojang AB',
 	critic_score = '93',
 	critic_count = '33',
 	user_score= '8.1',
	user_count = '7530',
	rating = 'E10+'
WHERE name = 'Minecraft';

UPDATE videogames
SET developer = 'Rare Ltd',
 	critic_score = '96',
 	critic_count = '21',
 	user_score= '9.0',
	user_count = '799',
	rating = 'T'
WHERE name = 'GoldenEye 007';

UPDATE videogames
SET developer = 'EA Dice',
 	critic_score = '73',
 	critic_count = '59',
 	user_score= '5.1',
	user_count = '2636',
	rating = 'T'
WHERE name = 'Star Wars Battlefront (2015)';

UPDATE videogames
SET developer = 'Atari Inc'
WHERE name = 'Pac-Man';

UPDATE videogames
SET developer = 'Naughty Dog'
WHERE name = 'Crash Bandicoot 2: Cortex Strikes Back';

UPDATE videogames
SET critic_score = '83',
 	critic_count = '54',
 	user_score= '7.6',
	user_count = '123',
	rating = 'E'
WHERE name = 'Nintendogs';

UPDATE videogames
SET critic_score = '95',
 	critic_count = '80',
 	user_score= '9.1',
	user_count = '3272',
	rating = 'M'
WHERE name = 'Grand Theft Auto: San Andreas';

UPDATE videogames
SET critic_score = '85',
 	critic_count = '81',
 	user_score= '8.2',
	user_count = '1046',
	rating = 'E'
WHERE name = 'Pokemon Diamond/Pokemon Pearl';

UPDATE videogames
SET critic_score = '82',
 	critic_count = '30',
 	user_score= '8.5',
	user_count = '362',
	rating = 'E'
WHERE name = 'Pokemon Ruby/Pokemon Sapphire';

UPDATE videogames
SET critic_score = '87',
 	critic_count = '118',
 	user_score= '7.8',
	user_count = '1527',
	rating = 'E'
WHERE name = 'Pokemon Black/Pokemon White';

UPDATE videogames
SET critic_score = '87',
 	critic_count = '140',
 	user_score= '7.5',
	user_count = '2860',
	rating = 'E'
WHERE name = 'Pokemon X/Pokemon Y';

UPDATE videogames
SET critic_score = '94',
 	critic_count = '13',
 	user_score= '9.1',
	user_count = '1651',
	rating = 'E'
WHERE name = 'Super Mario 64';

UPDATE videogames
SET critic_score = '87',
 	critic_count = '108',
 	user_score= '9.1',
	user_count = '2018',
	rating = 'E'
WHERE name = 'Pokemon HeartGold/Pokemon SoulSilver';

UPDATE videogames
SET critic_score = '83',
 	critic_count = '113',
 	user_score= '7.5',
	user_count = '1811',
	rating = 'E'
WHERE name = 'Pokemon Omega Ruby/Pokemon Alpha Sapphire';

UPDATE videogames
SET critic_score = '81',
 	critic_count = '44',
 	user_score= '8.6',
	user_count = '781',
	rating = 'E'
WHERE name = 'Pokemon FireRed/Pokemon LeafGreen';

UPDATE videogames
SET critic_score = '83',
 	critic_count = '15',
 	user_score= '8.6',
	user_count = '474',
	rating = 'E'
WHERE name = 'Mario Kart 64';

UPDATE videogames
SET critic_score = '80',
 	critic_count = '113',
 	user_score= '8.0',
	user_count = '1033',
	rating = 'E'
WHERE name = 'Pokemon Black 2/Pokemon White 2';

UPDATE videogames
SET critic_score = '67',
 	critic_count = '36',
 	user_score= '7.6',
	user_count = '129',
	rating = 'E'
WHERE name = 'Mario & Sonic at the Olympic Games';

UPDATE videogames
SET critic_score = '99',
 	critic_count = '22',
 	user_score= '9.1',
	user_count = '7410',
	rating = 'E'
WHERE name = 'The Legend of Zelda: Ocarina of Time';

UPDATE videogames
SET critic_score = '89',
 	critic_count = '153',
 	user_score= '8.9',
	user_count = '2997',
	rating = 'E10+'
WHERE name = 'Super Smash Bros. for Wii U and 3DS';

CREATE VIEW top100gamesglobal AS 
SELECT *
FROM videogames
ORDER BY global_sales DESC
LIMIT 100;

-- Top 100 selling games in North America

SELECT name, 
	platform,
	na_sales
FROM videogames
ORDER BY na_sales DESC
LIMIT 100;

-- Top 100 selling games in Europe

SELECT name, 
	platform,
	eu_sales
FROM videogames
ORDER BY eu_sales DESC
LIMIT 100;

-- Top 100 selling games in Japan

SELECT name, 
	platform,
	jp_sales
FROM videogames
ORDER BY jp_sales DESC
LIMIT 100;

-- Top 100 selling games in other countries

SELECT name, 
	platform,
	other_sales
FROM videogames
ORDER BY other_sales DESC
LIMIT 100;

--Are the top 100 selling games the same in each country?
/*CTE's containing the top 100 selling games for each region, 
then intersected to find the games which were in the top 100 for each region*/

WITH na_cte AS 
(SELECT name, 
	platform,
	na_sales
FROM videogames
ORDER BY na_sales DESC
LIMIT 100),
	eu_cte AS (
	SELECT name, 
	platform,
	eu_sales
FROM videogames
ORDER BY eu_sales DESC
LIMIT 100),
	jp_cte AS (
	SELECT name, 
	platform,
	jp_sales
FROM videogames
ORDER BY jp_sales DESC
LIMIT 100),
	other_cte AS (
	SELECT name, 
	platform,
	other_sales
FROM videogames
ORDER BY other_sales DESC
LIMIT 100)

SELECT name, 
	platform
FROM na_cte 
INTERSECT 
SELECT name, 
	platform
FROM eu_cte 
INTERSECT
SELECT name, 
	platform
FROM jp_cte
INTERSECT
SELECT name, 
	platform
FROM other_cte;

--View for visualization with the top 100 selling games in each region
/*Union instead of intersect to get the top 100 selling video games of each region, 
and their sales opposed to the games that are in the top 100 of each category*/

CREATE VIEW top_100_each_region AS 
WITH na_cte AS 
(SELECT name, 
	platform,
 	publisher,
 	developer,
 	genre,
 	critic_score,
 	user_score,
	na_sales
FROM videogames
ORDER BY na_sales DESC
LIMIT 100),
	eu_cte AS (
	SELECT name, 
	platform,
	publisher,
 	developer,
 	genre,
 	critic_score,
 	user_score,
	eu_sales
FROM videogames
ORDER BY eu_sales DESC
LIMIT 100),
	jp_cte AS (
	SELECT name, 
	platform,
	publisher,
 	developer,
 	genre,
 	critic_score,
 	user_score,
	jp_sales
FROM videogames
ORDER BY jp_sales DESC
LIMIT 100),
	other_cte AS (
	SELECT name, 
	platform,
	publisher,
 	developer,
 	genre,
 	critic_score,
 	user_score,
	other_sales
FROM videogames
ORDER BY other_sales DESC
LIMIT 100)

SELECT *
FROM na_cte 
UNION
SELECT *
FROM eu_cte
UNION
SELECT *
FROM jp_cte
UNION
SELECT *
FROM other_cte;

--confirming view was successful
SELECT *
FROM top_100_each_region;

/*Top 100 selling games globally ranked 1-100, 
with a running total, and the difference in sales between each game from 1-100*/
SELECT SUM(global_sales)
FROM videogames;

SELECT name,
	SUM(global_sales),
	SUM(global_sales) OVER(ORDER BY global_sales) AS total_global_sales	
FROM videogames
GROUP BY global_sales, name
ORDER BY global_sales DESC
LIMIT 100;

CREATE VIEW top100_diffinsales_totalglobal AS
SELECT name,
	platform,
	publisher,
	genre,
	developer,
	global_sales,
	SUM(global_sales) OVER(ORDER BY global_sales DESC ROWS BETWEEN 0 PRECEDING AND 100 FOLLOWING) AS total_global_sales,
	RANK() OVER(ORDER BY global_sales DESC) AS global_sales_rank,
	LAG(global_sales,1) OVER(ORDER BY global_sales DESC)- global_sales AS difference_in_sales
FROM 
(SELECT name,
	platform,
	publisher,
	genre,
	developer,
	global_sales
FROM videogames
ORDER BY global_sales DESC
LIMIT 100) AS top100subq
GROUP BY (1,2,3,4,5,6)
ORDER BY global_sales DESC;

/*Selecting the top 100 games, their genre, platform, developer 
and CASE statments to segment critic and user ratings.*/

CREATE VIEW top100withscoregroupings AS 
SELECT name,
	platform,
	genre,
	developer,
	global_sales,
	critic_score,
	user_score,
CASE WHEN critic_score >= 95 THEN 'Critically almost perfect'
	 WHEN critic_score < 95 AND critic_score >= 85 THEN 'Critically amazing'
	 WHEN critic_score < 85 AND critic_score >= 75 THEN 'Critically good'
	 WHEN critic_score < 75 AND critic_score >= 60 THEN 'Critically ok'
	 ELSE 'Critically bad' END AS critic_scores,
CASE WHEN user_score >= 9.5 THEN 'User Favorite'
	 WHEN user_score < 9.5 AND user_score >= 8.5 THEN 'User amazing'
	 WHEN user_score < 8.5 AND user_score >= 7.5 THEN 'User good'
	 WHEN user_score < 7.5 AND user_score >= 6.0 THEN 'User ok'
	 ELSE 'User bad' END AS user_scores
FROM top100gamesglobal;

--Queries copied to CSV so I can visualize in Tableau Public

COPY 
(SELECT *
FROM top100withscoregroupings) TO '/Users/drakemcadow/Downloads/top_100_global_with_scores.csv' DELIMITER ',' CSV HEADER;

COPY 
(SELECT *
FROM top_100_each_region) TO '/Users/drakemcadow/Downloads/top_100_each_region.csv' DELIMITER ',' CSV HEADER;

COPY 
(SELECT *
FROM top100_diffinsales_totalglobal) TO '/Users/drakemcadow/Downloads/top_100_with_diffandtotal.csv' DELIMITER ',' CSV HEADER;