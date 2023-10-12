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

-- úprava dat -- 
-- FIX [#4]
-- oprava názvu tabulek, aby odpovídaly tomu, co obsahují
-- FIX [#5]
-- promazání kódu od nepotřebného/nefunčního

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
	FROM czechia_price AS cprice
	LEFT JOIN czechia_price_category cpc
	ON cp.category_code = cpc.code 
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

FIX [#4]
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
	week_period,
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

FIX [#5]
	
-- vypočítat průměr z procentuálního meziročního růstu cen --
	
	CREATE OR REPLACE VIEW v_Dominika_Jancova_project_SQL_primary_final_question3 AS
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
	week_period,
	year_period,
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

SELECT	
	*,
	ROUND ((year_2006 + next_year_2007 + next_year_2008 + next_year_2009 + next_year_2010 + next_year_2011 + next_year_2012 + next_year_2013 + next_year_2014 + next_year_2015 + next_year_2016)/11, 2) AS avg_value,
	((percentual_growth1 + percentual_growth2 + percentual_growth3 + percentual_growth4 + percentual_growth5 + percentual_growth6 + percentual_growth7 + percentual_growth8 + percentual_growth9 + percentual_growth10)/10) AS avg_percentual_growth
FROM v_Dominika_Jancova_project_SQL_primary_final_question3
GROUP BY category_code, week_period
ORDER BY avg_percentual_growth ASC
;
