-- SQL závěrečný projekt --
-- 4.OTÁZKA --
	-- Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)
-- DATOVÉ SADY --

SELECT 
	*
FROM v_Dominika_Jancova_project_SQL_primary_final_question3;

SELECT	
	*
FROM t_Dominika_Jancova_project_SQL_primary_final;

-- OPRAVA: JINÁ VARIANTA řešení otázky tak, aby bylo možno přidat další roky do porovnání bez nutnosti úpravy SQL
FIX [#1]
-- použijeme pomocí týdnů join nárustů a porovnáme pak hodnoty -> pomocí case expresion --

SELECT	
	*,
	ROUND ((year_2006 + next_year_2007 + next_year_2008 + next_year_2009 + next_year_2010 + next_year_2011 + next_year_2012 + next_year_2013 + next_year_2014 + next_year_2015 + next_year_2016)/11, 2) AS avg_value,
	((percentual_growth1 + percentual_growth2 + percentual_growth3 + percentual_growth4 + percentual_growth5 + percentual_growth6 + percentual_growth7 + percentual_growth8 + percentual_growth9 + percentual_growth10)/10) AS avg_percentual_growth
FROM v_Dominika_Jancova_project_SQL_primary_final_question3
GROUP BY category_code, week_period
;

SELECT	
	*
FROM t_Dominika_Jancova_project_SQL_primary_final


CREATE OR REPLACE VIEW v_Dominika_Jancova_project_SQL_primary_final_question4 AS
	WITH BASE AS (
		SELECT 
		*,
		LEAD (value) OVER (PARTITION BY industry_branch_code, payroll_quarter ORDER BY payroll_year) AS value_2007,
		LEAD (value, 2) OVER (PARTITION BY industry_branch_code, payroll_quarter ORDER BY payroll_year) AS value_2008,
		LEAD (value, 3) OVER (PARTITION BY industry_branch_code, payroll_quarter ORDER BY payroll_year) AS value_2009,
		LEAD (value, 4) OVER (PARTITION BY industry_branch_code, payroll_quarter ORDER BY payroll_year) AS value_2010,
		LEAD (value, 5) OVER (PARTITION BY industry_branch_code, payroll_quarter ORDER BY payroll_year) AS value_2011,
		LEAD (value, 6) OVER (PARTITION BY industry_branch_code, payroll_quarter ORDER BY payroll_year) AS value_2012,
		LEAD (value, 7) OVER (PARTITION BY industry_branch_code, payroll_quarter ORDER BY payroll_year) AS value_2013,
		LEAD (value, 8) OVER (PARTITION BY industry_branch_code, payroll_quarter ORDER BY payroll_year) AS value_2014,
		LEAD (value, 9) OVER (PARTITION BY industry_branch_code, payroll_quarter ORDER BY payroll_year) AS value_2015,
		LEAD (value, 10) OVER (PARTITION BY industry_branch_code, payroll_quarter ORDER BY payroll_year) AS value_2016
	FROM t_Dominika_Jancova_project_SQL_primary_final
	WHERE 
		payroll_year BETWEEN 2006 AND 2016
)
SELECT 
	id,
	payroll_quarter,
	industry_branch_code,
	name,
	payroll_year,
	value AS value_2006,
	value_2007,
	value_2008,
	value_2009,
	value_2010,
	value_2011,
	value_2012,
	value_2013,
	value_2014,
	value_2015,
	value_2016,
	ROUND ((value_2007 - value) / value * 100, 2) AS difference_2006_2007,
	ROUND ((value_2008 - value_2007) / value_2007 * 100, 2) AS difference_2007_2008,
	ROUND ((value_2009 - value_2008) / value_2008 * 100, 2) AS difference_2008_2009,
	ROUND ((value_2010 - value_2009) / value_2009 * 100, 2) AS difference_2009_2010,
	ROUND ((value_2011 - value_2010) / value_2010 * 100, 2) AS difference_2010_2011,
	ROUND ((value_2012 - value_2011) / value_2011 * 100, 2) AS difference_2011_2012,
	ROUND ((value_2013 - value_2012) / value_2012 * 100, 2) AS difference_2012_2013,
	ROUND ((value_2014 - value_2013) / value_2013 * 100, 2) AS difference_2013_2014,
	ROUND ((value_2015 - value_2014) / value_2014 * 100, 2) AS difference_2014_2015,
	ROUND ((value_2016 - value_2015) / value_2015 * 100, 2) AS difference_2015_2016
FROM BASE
WHERE value_2016 IS NOT NULL
;

SELECT
	*
FROM v_Dominika_Jancova_project_SQL_primary_final_question4
;

WITH BASE AS ( 
	SELECT 
		*,
		CASE 
			WHEN week_period = 2 THEN 1
			ELSE 4
		END AS quarter_period
	FROM v_Dominika_Jancova_project_SQL_primary_final_question3
	)
SELECT
	base_1.name,
	v_price_q4.name,
	base_1.percentual_growth1 AS price_2006_2007,
	v_price_q4.difference_2006_2007,
	base_1.percentual_growth2 AS price_2007_2008,
	v_price_q4.difference_2007_2008,
	base_1.percentual_growth3 AS price_2008_2009,
	v_price_q4.difference_2008_2009,
	base_1.percentual_growth4 AS price_2009_2010,
	v_price_q4.difference_2009_2010,
	base_1.percentual_growth5 AS price_2010_2011,
	v_price_q4.difference_2010_2011,
	base_1.percentual_growth6 AS price_2011_2012,
	v_price_q4.difference_2011_2012,
	base_1.percentual_growth7 AS price_2012_2013,
	v_price_q4.difference_2012_2013,
	base_1.percentual_growth8 AS price_2013_2014,
	v_price_q4.difference_2013_2014,
	base_1.percentual_growth9 AS price_2014_2015,
	v_price_q4.difference_2014_2015,
	base_1.percentual_growth8 AS price_2015_2016,
	v_price_q4.difference_2015_2016
FROM BASE AS base_1
LEFT JOIN v_Dominika_Jancova_project_SQL_primary_final_question4 AS v_price_q4
	ON base_1.quarter_period = v_price_q4.payroll_quarter
WHERE 
	base_1.quarter_period = 1
	AND v_price_q4.payroll_quarter = 1

WITH BASE AS ( 
	SELECT 
		*,
		CASE 
			WHEN week_period = 2 THEN 1
			ELSE 4
		END AS quarter_period
	FROM v_Dominika_Jancova_project_SQL_primary_final_question3
	)
SELECT
	base_2.name,
	v_price_q4.name,
	(base_2.percentual_growth1 - v_price_q4.difference_2006_2007) AS value_2006_2007,
	(base_2.percentual_growth2 - v_price_q4.difference_2007_2008) AS value_2007_2008,
	(base_2.percentual_growth3 - v_price_q4.difference_2008_2009) AS value_2008_2009,
	(base_2.percentual_growth4 - v_price_q4.difference_2009_2010) AS value_2009_2010,
	(base_2.percentual_growth5 - v_price_q4.difference_2010_2011) AS value_2010_2011,
	(base_2.percentual_growth6 - v_price_q4.difference_2011_2012) AS value_2011_2012,
	(base_2.percentual_growth7 - v_price_q4.difference_2012_2013) AS value_2012_2013,
	(base_2.percentual_growth8 - v_price_q4.difference_2013_2014) AS value_2013_2014,
	(base_2.percentual_growth9 - v_price_q4.difference_2014_2015) AS value_2014_2015,
	(base_2.percentual_growth10 - v_price_q4.difference_2015_2016) AS value_2015_20106,
	CASE
		WHEN (base_2.percentual_growth1 - v_price_q4.difference_2006_2007) > 10 THEN 1
		ELSE 0
	END AS more_1
FROM BASE AS base_2
LEFT JOIN v_Dominika_Jancova_project_SQL_primary_final_question4 AS v_price_q4
	ON base_2.quarter_period = v_price_q4.payroll_quarter
WHERE 
	base_2.quarter_period = 1
	AND v_price_q4.payroll_quarter = 1
;

WITH BASE AS ( 
	SELECT 
		*,
		CASE 
			WHEN week_period = 2 THEN 1
			ELSE 4
		END AS quarter_period
	FROM v_Dominika_Jancova_project_SQL_primary_final_question3
	),
BASE2 AS (
	SELECT
	base_3.name AS food_name,
	dj4.name AS industry_name,
	CASE
		WHEN (base_3.percentual_growth1 - v_price_q4.difference_2006_2007) > 10 THEN 1
		ELSE 0
	END AS value_2006_2007_more_than_10,
	CASE
		WHEN (base_3.percentual_growth2 - v_price_q4.difference_2007_2008) > 10 THEN 1
		ELSE 0
	END AS value_2007_2008_more_than_10,
	CASE
		WHEN (base_3.percentual_growth3 - v_price_q4.difference_2008_2009) > 10 THEN 1
		ELSE 0
	END AS value_2008_2009_more_than_10,
	CASE
		WHEN (base_3.percentual_growth4 - v_price_q4.difference_2009_2010) > 10 THEN 1
		ELSE 0
	END AS value_2009_2010_more_than_10,
	CASE
		WHEN (base_3.percentual_growth5 - v_price_q4.difference_2010_2011) > 10 THEN 1
		ELSE 0
	END AS value_2010_2011_more_than_10,
	CASE
		WHEN (base_3.percentual_growth6 - v_price_q4.difference_2011_2012) > 10 THEN 1
		ELSE 0
	END AS value_2011_2012_more_than_10,
		CASE
		WHEN (base_3.percentual_growth7 - v_price_q4.difference_2012_2013) > 10 THEN 1
		ELSE 0
	END AS value_2012_2013_more_than_10,
		CASE
		WHEN (base_3.percentual_growth8 - v_price_q4.difference_2013_2014) > 10 THEN 1
		ELSE 0
	END AS value_2013_2014_more_than_10,
		CASE
		WHEN (base_3.percentual_growth9 - v_price_q4.difference_2014_2015) > 10 THEN 1
		ELSE 0
	END AS value_2014_2015_more_than_10,
		CASE
		WHEN (base_3.percentual_growth10 - v_price_q4.difference_2015_2016) > 10 THEN 1
		ELSE 0
	END AS value_2015_2016_more_than_10
FROM BASE AS base_3
LEFT JOIN v_Dominika_Jancova_project_SQL_primary_final_question4 AS v_price_q4
	ON base_3.quarter_period = v_price_q4.payroll_quarter
WHERE 
	base_3.quarter_period = 1
	AND v_price_q4.payroll_quarter = 1
	)
SELECT
	*
FROM BASE2
WHERE
	value_2006_2007_more_than_10 = 1
	OR value_2007_2008_more_than_10 = 1
	OR value_2008_2009_more_than_10 = 1
	OR value_2009_2010_more_than_10 = 1
	OR value_2010_2011_more_than_10 = 1
	OR value_2011_2012_more_than_10 = 1
	OR value_2012_2013_more_than_10 = 1
	OR value_2013_2014_more_than_10 = 1
	OR value_2014_2015_more_than_10 = 1
	OR value_2015_2016_more_than_10 = 1
;

WITH BASE AS ( 
	SELECT 
		*,
		CASE 
			WHEN week_period = 2 THEN 1
			ELSE 4
		END AS quarter_period
	FROM v_Dominika_Jancova_project_SQL_primary_final_question3
	),
BASE2 AS (
	SELECT
	base_4.name AS food_name,
	v_price_4.name AS industry_name,
	CASE
		WHEN (base_4.percentual_growth1 - v_price_4.difference_2006_2007) > 10 THEN 1
		WHEN (base_4.percentual_growth1 - v_price_4.difference_2006_2007) < -10 THEN 2
		ELSE 0
	END AS value_2006_2007_more_than_10,
	CASE
		WHEN (base_4.percentual_growth2 - v_price_4.difference_2007_2008) > 10 THEN 1
		WHEN (base_4.percentual_growth2 - v_price_4.difference_2007_2008) < -10 THEN 2
		ELSE 0
	END AS value_2007_2008_more_than_10,
	CASE
		WHEN (base_4.percentual_growth3 - v_price_4.difference_2008_2009) > 10 THEN 1
		WHEN (base_4.percentual_growth3 - v_price_4.difference_2008_2009) < -10 THEN 2
		ELSE 0
	END AS value_2008_2009_more_than_10,
	CASE
		WHEN (base_4.percentual_growth4 - v_price_4.difference_2009_2010) > 10 THEN 1
		WHEN (base_4.percentual_growth4 - v_price_4.difference_2009_2010) < -10 THEN 2
		ELSE 0
	END AS value_2009_2010_more_than_10,
	CASE
		WHEN (base_4.percentual_growth5 - v_price_4.difference_2010_2011) > 10 THEN 1
		WHEN (base_4.percentual_growth4 - v_price_4.difference_2009_2010) < -10 THEN 2
		ELSE 0
	END AS value_2010_2011_more_than_10,
	CASE
		WHEN (base_4.percentual_growth6 - v_price_4.difference_2011_2012) > 10 THEN 1
		WHEN (base_4.percentual_growth6 - v_price_4.difference_2011_2012) < -10 THEN 2
		ELSE 0
	END AS value_2011_2012_more_than_10,
		CASE
		WHEN (base_4.percentual_growth7 - v_price_4.difference_2012_2013) > 10 THEN 1
		WHEN (base_4.percentual_growth7 - v_price_4.difference_2012_2013) < -10 THEN 2
		ELSE 0
	END AS value_2012_2013_more_than_10,
		CASE
		WHEN (base_4.percentual_growth8 - v_price_4.difference_2013_2014) > 10 THEN 1
		WHEN (base_4.percentual_growth8 - v_price_4.difference_2013_2014) < -10 THEN 2
		ELSE 0
	END AS value_2013_2014_more_than_10,
		CASE
		WHEN (base_4.percentual_growth9 - v_price_4.difference_2014_2015) > 10 THEN 1
		WHEN (base_4.percentual_growth9 - v_price_4.difference_2014_2015) < -10 THEN 2
		ELSE 0
	END AS value_2014_2015_more_than_10,
		CASE
		WHEN (base_4.percentual_growth10 - v_price_4.difference_2015_2016) > 10 THEN 1
		WHEN (base_4.percentual_growth10 - v_price_4.difference_2015_2016) < -10 THEN 2
		ELSE 0
	END AS value_2015_2016_more_than_10
FROM BASE AS base_4
LEFT JOIN v_Dominika_Jancova_project_SQL_primary_final_question4 AS v_price_4
	ON base_4.quarter_period = v_price_4.payroll_quarter
WHERE 
	base_4.quarter_period = 1
	AND v_price_4.payroll_quarter = 1
	)
SELECT
	*
FROM BASE2
WHERE 
	value_2006_2007_more_than_10 = 1
	OR value_2007_2008_more_than_10 = 1
	OR value_2008_2009_more_than_10 = 1
	OR value_2009_2010_more_than_10 = 1
	OR value_2010_2011_more_than_10 = 1
	OR value_2011_2012_more_than_10 = 1
	OR value_2012_2013_more_than_10 = 1
	OR value_2013_2014_more_than_10 = 1
	OR value_2014_2015_more_than_10 = 1
	OR value_2015_2016_more_than_10 = 1
;
WHERE 
	value_2007_2008_more_than_10 = 0
	AND value_2006_2007_more_than_10 = 0
	AND value_2008_2009_more_than_10 = 0
	AND value_2009_2010_more_than_10 = 0
	AND value_2010_2011_more_than_10 = 0
	AND value_2011_2012_more_than_10 = 0
	AND value_2012_2013_more_than_10 = 0
	AND value_2013_2014_more_than_10 = 0
	AND value_2015_2016_more_than_10 = 0
;
-- pro zodpovězení otázky dostatečné --

-- druhé řešení 
-- tvorba dynamického výpočtu v jednom sloupci, pouze pro momentální otázku omezené skrze roky na 2006-2016, ale lze přidat jednoduše další roky. 
FIX #1

CREATE OR REPLACE VIEW v_Dominika_Jancova_project_SQL_primary_final_question4_V2 AS
WITH BASE_5 AS (
	SELECT 
		*,
		LEAD (value) OVER (PARTITION BY industry_branch_code, payroll_quarter ORDER BY payroll_year) AS next_year_value
	FROM t_Dominika_Jancova_project_SQL_primary_final AS t_pay_price
	WHERE payroll_year BETWEEN 2006 AND 2016
	)
SELECT 
	id, 
	payroll_quarter,
	industry_branch_code,
	name,
	payroll_year,
	value,
	next_year_value,
	ROUND (((next_year_value - value) / value) * 100, 2) AS percentual_growth
FROM BASE_5
WHERE 
	next_year_value IS NOT NULL
	AND payroll_quarter = 1
ORDER BY payroll_year
;

SELECT 
	*
FROM v_Dominika_Jancova_project_SQL_primary_final_question4_V2
;

SELECT	
	*
FROM t_Dominika_Jancova_project_SQL_primary_final2;

CREATE OR REPLACE VIEW v_Dominika_Jancova_project_SQL_primary_final_question4_V2_2 AS
WITH BASE_6 AS ( 
	SELECT 
		*,
		LEAD (value) OVER (PARTITION BY category_code, region_code, week_period, price_quarter ORDER BY year_period) AS next_year_value
	FROM t_Dominika_Jancova_project_SQL_primary_final2
	WHERE 
		region_code IS NULL
		AND week_period = 2
		AND price_quarter = 1
		AND payroll_year BETWEEN 2006 AND 2016
	)
SELECT 
	name AS food_name, 
	price_value,
	price_unit,
	year_period,
	price_quarter,
	value,
	next_year_value,
	ROUND (((next_year_value - value ) / value) * 100, 2) AS percentual_growth_food
FROM BASE_6
WHERE 
	price_quarter = 1
ORDER BY year_period;


SELECT 
	*
FROM v_Dominika_Jancova_project_SQL_primary_final_question4_V2
;

SELECT 
	*
FROM v_Dominika_Jancova_project_SQL_primary_final_question4_V2_2
;


WITH BASE_7 AS (
SELECT
	q4_pay.industry_branch_code,
	q4_pay.name,
	q4_price.food_name,
	q4_price.value AS price_value,
	q4_pay.value AS payroll_value,
	q4_price.next_year_value AS price_next_year_value,
	q4_pay.next_year_value AS payroll_next_year_value,
	q4_price.price_value AS amount,
	q4_price.price_unit,
	q4_pay.payroll_year AS year,
	q4_pay.payroll_quarter AS quarter,
	q4_price.percentual_growth_food,
	q4_pay.percentual_growth,
	CASE 
		WHEN (q4_price.percentual_growth_food - q4_pay.percentual_growth) > 10 THEN 1
		ELSE 0
	END AS more_than_10_percent_increase,
	CASE 
		WHEN (q4_price.percentual_growth_food - q4_pay.percentual_growth) < -10 THEN 2
		ELSE 0
	END AS less_than_anti10_percent_increase
FROM v_Dominika_Jancova_project_SQL_primary_final_question4_V2_2 AS q4_price
JOIN v_Dominika_Jancova_project_SQL_primary_final_question4_V2 AS q4_pay
ON q4_pay.payroll_year = q4_price.year_period
WHERE
	q4_price.price_quarter = payroll_quarter
)
SELECT
	*
FROM BASE_7
WHERE 
	more_than_10_percent_increase = 1
	OR less_than_anti10_percent_increase = 2
;
	

