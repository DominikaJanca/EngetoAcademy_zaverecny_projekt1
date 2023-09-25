-- SQL závěrečný projekt --
-- 3.OTÁZKA --
	-- Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
-- DATOVÉ SADY --

SELECT *
FROM czechia_price cp;

SELECT *
FROM czechia_price_category cpc;

SELECT
	*
FROM t_Dominika_Jancova_project_SQL_primary_final2;

-- POZNATKY Z ANALÝZY DAT --
	-- zvolené srovnání díky povaze zdrojových dat?
	-- potřebujeme srovnat datumy - po týdnech? kvartálech? rocích?
	-- potřebujeme připojit tabulky podle category_code pro název jednotlivých kategorií jídla

-- tvorba datového podkladu v tabulce --

SELECT
	*
FROM t_Dominika_Jancova_project_SQL_primary_final2;

SELECT
	*,
	WEEK (date_from) AS 'price_week'
FROM t_Dominika_Jancova_project_SQL_primary_final2;

-- zkouška --
SELECT
	*,
	WEEK (date_from) AS 'price_week'
FROM t_Dominika_Jancova_project_SQL_primary_final2
WHERE WEEK (date_from) = 41;
-- zkouška --

ALTER TABLE t_Dominika_Jancova_project_SQL_primary_final2
ADD COLUMN price_week INT;

UPDATE t_Dominika_Jancova_project_SQL_primary_final2
SET price_week = WEEK (date_from);
	
SELECT
	*
FROM t_Dominika_Jancova_project_SQL_primary_final2;

CREATE OR REPLACE VIEW v_Dominika_Jancova_project_SQL_primary_question3 AS
SELECT
	DJ1.id,
	DJ1.category_code,
	DJ1.name,
	DJ1.price_value,
	DJ1.price_unit,
	DJ1.date_from,
	DJ1.date_to,
	DJ1.price_quarter,
	DJ1.price_week,
	DJ1.price_year AS 'price_previous_year',
	DJ2.price_year AS 'price_next_year',
	DJ1.value AS 'value_previous_year',
	DJ2.value AS 'value_next_year',
	( DJ2.value - DJ1.value ) AS 'difference_in_value',
	ROUND (((DJ2.value - DJ1.value) / DJ1.value) * 100) AS 'percentual growth'
FROM t_Dominika_Jancova_project_SQL_primary_final2 AS DJ1
JOIN t_Dominika_Jancova_project_SQL_primary_final2 AS DJ2
	ON DJ2.price_year = DJ1.price_year + 1
WHERE 
	DJ2.price_week = DJ1.price_week AND
	DJ2.price_quarter = DJ1.price_quarter AND
	DJ2.category_code = DJ1.category_code
;

-- zkouška jiné alternativy --
CREATE OR REPLACE VIEW v_Dominika_Jancova_project_SQL_primary_question3 AS
	SELECT
		*
	FROM t_Dominika_Jancova_project_SQL_primary_final2
	WHERE
		category_code = 111201
	GROUP BY date_from
;
-- nelze
SELECT
		*
	FROM t_Dominika_Jancova_project_SQL_primary_final2;
	GROUP BY 
		date_from
		AND price_year;
-- nelze

	SELECT
	*
FROM v_Dominika_Jancova_project_SQL_primary_question3
GROUP BY price_year;


SELECT
	DJ1.id,
	DJ1.category_code,
	DJ1.name,
	DJ1.price_value,
	DJ1.price_unit,
	DJ1.value AS 'value_2006',
	DJ2.value AS 'value_2007',
	DJ3.value AS 'value_2008',
	DJ4.value AS 'value_2009',
	DJ5.value AS 'value_2010',
	DJ6.value AS 'value_2011'
FROM v_Dominika_Jancova_project_SQL_primary_question3 AS DJ1
JOIN v_Dominika_Jancova_project_SQL_primary_question3 AS DJ2
	ON DJ2.price_year = DJ1.price_year + 1
JOIN v_Dominika_Jancova_project_SQL_primary_question3 AS DJ3
	ON DJ3.price_year = DJ1.price_year + 2
JOIN v_Dominika_Jancova_project_SQL_primary_question3 AS DJ4
	ON DJ4.price_year = DJ1.price_year + 3
JOIN v_Dominika_Jancova_project_SQL_primary_question3 AS DJ5
	ON DJ5.price_year = DJ1.price_year + 4
JOIN v_Dominika_Jancova_project_SQL_primary_question3 AS DJ6
	ON DJ6.price_year = DJ1.price_year + 5
WHERE 
	DJ1.category_code = DJ2.category_code AND
	DJ1.price_quarter = DJ2.price_quarter AND
	DJ2.price_quarter = DJ3.price_quarter AND
	DJ1.price_quarter = DJ3.price_quarter AND
	DJ1.price_quarter = DJ4.price_quarter AND
	DJ1.price_quarter = DJ5.price_quarter AND
	DJ1.price_quarter = DJ6.price_quarter;


	DJ7.value AS 'value_2012',
	DJ8.value AS 'value_2013',
	DJ9.value AS 'value_2014',
	DJ10.value AS 'value_2015',
	DJ11.value AS 'value_2016',
	DJ12.value AS 'value_2017'
	ROUND (((DJ2.value - DJ1.value) / DJ1.value) * 100) AS 'percentual growth_2006/2007',
	ROUND (((DJ3.value - DJ2.value) / DJ2.value) * 100) AS 'percentual growth_2007/2008',
	ROUND (((DJ4.value - DJ3.value) / DJ3.value) * 100) AS 'percentual growth_2008/2009',
	ROUND (((DJ5.value - DJ4.value) / DJ4.value) * 100) AS 'percentual growth_2009/2010',
	ROUND (((DJ6.value - DJ5.value) / DJ5.value) * 100) AS 'percentual growth_2011/2012',
	ROUND (((DJ7.value - DJ6.value) / DJ6.value) * 100) AS 'percentual growth_2012/2013',
	ROUND (((DJ8.value - DJ7.value) / DJ7.value) * 100) AS 'percentual growth_2013/2014',
	ROUND (((DJ9.value - DJ8.value) / DJ8.value) * 100) AS 'percentual growth_2014/2015',
	ROUND (((DJ10.value - DJ9.value) / DJ9.value) * 100) AS 'percentual growth_2015/2016',
	ROUND (((DJ11.value - DJ10.value) / DJ10.value) * 100) AS 'percentual growth_2016/2017',
	ROUND (((DJ12.value - DJ11.value) / DJ11.value) * 100) AS 'percentual growth_2017/2018'
	JOIN v_Dominika_Jancova_project_SQL_primary_question3 AS DJ7
	ON DJ7.price_year = DJ1.price_year + 6
JOIN v_Dominika_Jancova_project_SQL_primary_question3 AS DJ8
	ON DJ8.price_year = DJ1.price_year + 7
JOIN v_Dominika_Jancova_project_SQL_primary_question3 AS DJ9
	ON DJ9.price_year = DJ1.price_year + 8
JOIN v_Dominika_Jancova_project_SQL_primary_question3 AS DJ10
	ON DJ10.price_year = DJ1.price_year + 10
JOIN v_Dominika_Jancova_project_SQL_primary_question3 AS DJ11
	ON DJ11.price_year = DJ1.price_year + 11
JOIN v_Dominika_Jancova_project_SQL_primary_question3 AS DJ12
	ON DJ12.price_year = DJ1.price_year + 12
	DJ1.price_week = DJ7.price_week AND
	DJ1.price_week = DJ8.price_week AND
	DJ1.price_week = DJ9.price_week AND
	DJ1.price_week = DJ10.price_week AND
	DJ1.price_week = DJ11.price_week AND
	DJ1.price_week = DJ12.price_week
;

-- ZPŮSOB 3 -- Každou kategorii zvlášť pomocí dvou group by --
SELECT
	*
FROM v_Dominika_Jancova_project_SQL_primary_question3;

CREATE OR REPLACE VIEW v_Dominika_Jancova_project_SQL_primary_question_3 AS
SELECT
	*
FROM v_Dominika_Jancova_project_SQL_primary_question3
GROUP BY price_year;

SELECT
	DJ1.*,
	DJ2.value AS 'value_next_year',
	ROUND (((DJ2.value - DJ1.value) / DJ1.value) * 100) AS 'percentual growth'
FROM v_Dominika_Jancova_project_SQL_primary_question_3 AS DJ1
LEFT JOIN v_Dominika_Jancova_project_SQL_primary_question_3 AS DJ2
	ON DJ2.price_year = DJ1.price_year + 1;

-- 

CREATE OR REPLACE VIEW v_Dominika_Jancova_project_SQL_primary_question3 AS
	SELECT
		*
	FROM t_Dominika_Jancova_project_SQL_primary_final2
	WHERE
		category_code = 111201
	GROUP BY date_from

-- 
SELECT
	*
FROM t_Dominika_Jancova_project_SQL_primary_final2;
	
	
SELECT
	*,
	DENSE_RANK(date_from) OVER (PARTITION BY category_code ORDER BY date_from) AS dense_rank,
	lead (value) OVER (PARTITION BY category_code, price_week ORDER BY price_year) AS lead_date
FROM t_Dominika_Jancova_project_SQL_primary_final2
;


GROUP BY category_code;
WHERE 1+1
	-- AND category_code = '111101'
	-- AND year(date_from) = 2006
;

SELECT
	*,
	EXTRACT (year FROM date_from) AS 'date_period'
FROM t_Dominika_Jancova_project_SQL_primary_final2
ORDER BY 
	price_year
	AND category_code;


GROUP BY price_week
;

WITH base AS
( SELECT
	*,
	RANK () OVER (PARTITION BY category_code ORDER BY date_from) AS rnk
FROM t_Dominika_Jancova_project_SQL_primary_final2 )
;

SELECT
		*,
		RANK () OVER (PARTITION BY category_code ORDER BY date_from) AS rnk
	FROM t_Dominika_Jancova_project_SQL_primary_final2



lead (value) OVER (PARTITION BY category_code, rnk ORDER BY price_year) AS lead_date


-- došla jsem k poznání  -- 

SELECT
	*
FROM t_Dominika_Jancova_project_SQL_primary_final2;

CREATE OR REPLACE TABLE t_Dominika_Jancova_project_SQL_primary_final2
	SELECT 
		cp.id, 
		cp.region_code,
		cp.category_code,
		cpc.name,
		cpc.price_value,
		cpc.price_unit,
		cp.date_from,
		cp.date_to,
		cp.value
	FROM czechia_price AS cp
	LEFT JOIN czechia_price_category cpc
	ON cp.category_code = cpc.code 
	;
	
WITH BASE AS (
	SELECT 
		*,
		EXTRACT (year FROM date_from) AS 'year_period',
		EXTRACT (week FROM date_from) AS 'week_period'
	FROM t_Dominika_Jancova_project_SQL_primary_final2 AS DJF
	)
SELECT 
	*,
	LEAD (value) OVER (PARTITION BY category_code, region_code, week_period ORDER BY year_period) AS next_year
FROM BASE 
;

	
WITH BASE AS (
	SELECT 
		*,
		EXTRACT (year FROM date_from) AS 'year_period',
		EXTRACT (week FROM date_from) AS 'week_period'
	FROM t_Dominika_Jancova_project_SQL_primary_final2 AS DJF
),
BASE2 AS (
	SELECT 
		*,
		LEAD (value) OVER (PARTITION BY category_code, region_code, week_period ORDER BY year_period) AS 'next_year'
	FROM BASE 
)
	SELECT 
		*,
		(next_year - value) AS 'difference',
		ROUND ((next_year - value) / value, 2) AS 'percentual_difference',
		LEAD (next_year) OVER (PARTITION BY category_code, region_code, week_period ORDER BY year_period) AS 'next_year2'
	FROM BASE2
	;
UNION ALL
	SELECT
		*,
		LEAD (next_year2) OVER (PARTITION BY category_code, region_code, week_period ORDER BY year_period) AS 'next_year3'
	FROM BASE2
	;
UNION ALL
	SELECT 
		*,
		LEAD (next_year3) OVER (PARTITION BY category_code, region_code, week_period ORDER BY year_period) AS 'next_year4'
	FROM BASE2
;

-- 
ALTER TABLE t_Dominika_Jancova_project_SQL_primary_final2
	ADD COLUMN yeart_period INT,
	ADD COLUMN week_period INT
;

UPDATE t_Dominika_Jancova_project_SQL_primary_final2
	SET yeart_period = EXTRACT (year FROM date_from)
;

UPDATE t_Dominika_Jancova_project_SQL_primary_final2
	SET week_period = EXTRACT (week FROM date_from)
;

ALTER TABLE t_Dominika_Jancova_project_SQL_primary_final2
	RENAME COLUMN yeart_period TO year_period
;

SELECT	
	*
FROM t_Dominika_Jancova_project_SQL_primary_final2;

WITH BASE AS ( 
	SELECT 
		*,
		LEAD (value) OVER (PARTITION BY category_code, region_code, week_period ORDER BY year_period) AS next_year_2007,
		LEAD (value, 2) OVER (PARTITION BY category_code, region_code, week_period ORDER BY year_period) AS next_year_2008,
		LEAD (value, 3) OVER (PARTITION BY category_code, region_code, week_period ORDER BY year_period) AS next_year_2009,
		LEAD (value, 4) OVER (PARTITION BY category_code, region_code, week_period ORDER BY year_period) AS next_year_2010,
		LEAD (value, 5) OVER (PARTITION BY category_code, region_code, week_period ORDER BY year_period) AS next_year_2011,
		LEAD (value, 6) OVER (PARTITION BY category_code, region_code, week_period ORDER BY year_period) AS next_year_2012,
		LEAD (value, 7) OVER (PARTITION BY category_code, region_code, week_period ORDER BY year_period) AS next_year_2013,
		LEAD (value, 8) OVER (PARTITION BY category_code, region_code, week_period ORDER BY year_period) AS next_year_2014,
		LEAD (value, 9) OVER (PARTITION BY category_code, region_code, week_period ORDER BY year_period) AS next_year_2015,
		LEAD (value, 10) OVER (PARTITION BY category_code, region_code, week_period ORDER BY year_period) AS next_year_2016
	FROM t_Dominika_Jancova_project_SQL_primary_final2
	)		
SELECT 
	id,
	region_code,
	category_code,
	name,
	price_value,
	price_unit,
	value AS year_2006,
	next_year_2007,
	next_year_2008,
	next_year_2009,
	next_year_2010,
	next_year_2011,
	next_year_2012,
	next_year_2013,
	next_year_2014,
	next_year_2015,
	next_year_2016,
	ROUND ((next_year_2007 - value) / value * 100, 2) AS percentual_growth1,
	ROUND ((next_year_2008 - next_year_2007) / next_year_2007 * 100, 2) AS percentual_growth2,
	ROUND ((next_year_2009 - next_year_2008) / next_year_2008 * 100, 2) AS percentual_growth3,
	ROUND ((next_year_2010 - next_year_2009) / next_year_2009 * 100, 2) AS percentual_growth4,
	ROUND ((next_year_2011 - next_year_2010) / next_year_2010 * 100, 2) AS percentual_growth5,
	ROUND ((next_year_2012 - next_year_2011) / next_year_2011 * 100, 2) AS percentual_growth6,
	ROUND ((next_year_2013 - next_year_2012) / next_year_2012 * 100, 2) AS percentual_growth7,
	ROUND ((next_year_2014 - next_year_2013) / next_year_2013 * 100, 2) AS percentual_growth8,
	ROUND ((next_year_2015 - next_year_2014) / next_year_2014 * 100, 2) AS percentual_growth9,
	ROUND ((next_year_2016 - next_year_2015) / next_year_2015 * 100, 2) AS percentual_growth10
FROM BASE
WHERE 
	next_year_2016 IS NOT NULL
	AND region_code IS NULL
;

ORDER BY percentual_growth1 ASC
		;
	
