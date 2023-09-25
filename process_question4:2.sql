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
	dj3.name,
	dj4.name,
	dj3.percentual_growth1 AS price_2006_2007,
	dj4.difference_2006_2007,
	dj3.percentual_growth2 AS price_2007_2008,
	dj4.difference_2007_2008,
	dj3.percentual_growth3 AS price_2008_2009,
	dj4.difference_2008_2009,
	dj3.percentual_growth4 AS price_2009_2010,
	dj4.difference_2009_2010,
	dj3.percentual_growth5 AS price_2010_2011,
	dj4.difference_2010_2011,
	dj3.percentual_growth6 AS price_2011_2012,
	dj4.difference_2011_2012,
	dj3.percentual_growth7 AS price_2012_2013,
	dj4.difference_2012_2013,
	dj3.percentual_growth8 AS price_2013_2014,
	dj4.difference_2013_2014,
	dj3.percentual_growth9 AS price_2014_2015,
	dj4.difference_2014_2015,
	dj3.percentual_growth8 AS price_2015_2016,
	dj4.difference_2015_2016
FROM BASE AS dj3
LEFT JOIN v_Dominika_Jancova_project_SQL_primary_final_question4 AS dj4
	ON dj3.quarter_period = dj4.payroll_quarter
WHERE 
	dj3.quarter_period = 1
	AND dj4.payroll_quarter = 1

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
	dj3.name,
	dj4.name,
	(dj3.percentual_growth1 - dj4.difference_2006_2007) AS value_2006_2007,
	(dj3.percentual_growth2 - dj4.difference_2007_2008) AS value_2007_2008,
	(dj3.percentual_growth3 - dj4.difference_2008_2009) AS value_2008_2009,
	(dj3.percentual_growth4 - dj4.difference_2009_2010) AS value_2009_2010,
	(dj3.percentual_growth5 - dj4.difference_2010_2011) AS value_2010_2011,
	(dj3.percentual_growth6 - dj4.difference_2011_2012) AS value_2011_2012,
	(dj3.percentual_growth7 - dj4.difference_2012_2013) AS value_2012_2013,
	(dj3.percentual_growth8 - dj4.difference_2013_2014) AS value_2013_2014,
	(dj3.percentual_growth9 - dj4.difference_2014_2015) AS value_2014_2015,
	(dj3.percentual_growth10 - dj4.difference_2015_2016) AS value_2015_20106,
	CASE
		WHEN (dj3.percentual_growth1 - dj4.difference_2006_2007) > 10 THEN 1
		ELSE 0
	END AS more_1
FROM BASE AS dj3
LEFT JOIN v_Dominika_Jancova_project_SQL_primary_final_question4 AS dj4
	ON dj3.quarter_period = dj4.payroll_quarter
WHERE 
	dj3.quarter_period = 1
	AND dj4.payroll_quarter = 1
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
	dj3.name AS food_name,
	dj4.name AS industry_name,
	CASE
		WHEN (dj3.percentual_growth1 - dj4.difference_2006_2007) > 10 THEN 1
		ELSE 0
	END AS value_2006_2007_more_than_10,
	CASE
		WHEN (dj3.percentual_growth2 - dj4.difference_2007_2008) > 10 THEN 1
		ELSE 0
	END AS value_2007_2008_more_than_10,
	CASE
		WHEN (dj3.percentual_growth3 - dj4.difference_2008_2009) > 10 THEN 1
		ELSE 0
	END AS value_2008_2009_more_than_10,
	CASE
		WHEN (dj3.percentual_growth4 - dj4.difference_2009_2010) > 10 THEN 1
		ELSE 0
	END AS value_2009_2010_more_than_10,
	CASE
		WHEN (dj3.percentual_growth5 - dj4.difference_2010_2011) > 10 THEN 1
		ELSE 0
	END AS value_2010_2011_more_than_10,
	CASE
		WHEN (dj3.percentual_growth6 - dj4.difference_2011_2012) > 10 THEN 1
		ELSE 0
	END AS value_2011_2012_more_than_10,
		CASE
		WHEN (dj3.percentual_growth7 - dj4.difference_2012_2013) > 10 THEN 1
		ELSE 0
	END AS value_2012_2013_more_than_10,
		CASE
		WHEN (dj3.percentual_growth8 - dj4.difference_2013_2014) > 10 THEN 1
		ELSE 0
	END AS value_2013_2014_more_than_10,
		CASE
		WHEN (dj3.percentual_growth9 - dj4.difference_2014_2015) > 10 THEN 1
		ELSE 0
	END AS value_2014_2015_more_than_10,
		CASE
		WHEN (dj3.percentual_growth10 - dj4.difference_2015_2016) > 10 THEN 1
		ELSE 0
	END AS value_2015_2016_more_than_10
FROM BASE AS dj3
LEFT JOIN v_Dominika_Jancova_project_SQL_primary_final_question4 AS dj4
	ON dj3.quarter_period = dj4.payroll_quarter
WHERE 
	dj3.quarter_period = 1
	AND dj4.payroll_quarter = 1
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
	dj3.name AS food_name,
	dj4.name AS industry_name,
	CASE
		WHEN (dj3.percentual_growth1 - dj4.difference_2006_2007) > 10 THEN 1
		ELSE 0
	END AS value_2006_2007_more_than_10,
	CASE
		WHEN (dj3.percentual_growth2 - dj4.difference_2007_2008) > 10 THEN 1
		ELSE 0
	END AS value_2007_2008_more_than_10,
	CASE
		WHEN (dj3.percentual_growth3 - dj4.difference_2008_2009) > 10 THEN 1
		ELSE 0
	END AS value_2008_2009_more_than_10,
	CASE
		WHEN (dj3.percentual_growth4 - dj4.difference_2009_2010) > 10 THEN 1
		ELSE 0
	END AS value_2009_2010_more_than_10,
	CASE
		WHEN (dj3.percentual_growth5 - dj4.difference_2010_2011) > 10 THEN 1
		ELSE 0
	END AS value_2010_2011_more_than_10,
	CASE
		WHEN (dj3.percentual_growth6 - dj4.difference_2011_2012) > 10 THEN 1
		ELSE 0
	END AS value_2011_2012_more_than_10,
		CASE
		WHEN (dj3.percentual_growth7 - dj4.difference_2012_2013) > 10 THEN 1
		ELSE 0
	END AS value_2012_2013_more_than_10,
		CASE
		WHEN (dj3.percentual_growth8 - dj4.difference_2013_2014) > 10 THEN 1
		ELSE 0
	END AS value_2013_2014_more_than_10,
		CASE
		WHEN (dj3.percentual_growth9 - dj4.difference_2014_2015) > 10 THEN 1
		ELSE 0
	END AS value_2014_2015_more_than_10,
		CASE
		WHEN (dj3.percentual_growth10 - dj4.difference_2015_2016) > 10 THEN 1
		ELSE 0
	END AS value_2015_2016_more_than_10
FROM BASE AS dj3
LEFT JOIN v_Dominika_Jancova_project_SQL_primary_final_question4 AS dj4
	ON dj3.quarter_period = dj4.payroll_quarter
WHERE 
	dj3.quarter_period = 1
	AND dj4.payroll_quarter = 1
	)
SELECT
	*
FROM BASE2
WHERE value_2007_2008_more_than_10 = 1
;

-- filtrace dalších roků --
	value_2006_2007_more_than_10 = 1
	;
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




