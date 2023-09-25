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


SELECT 
	Vf3.*,
	Vf4.*
FROM v_Dominika_Jancova_project_SQL_primary_final_question3 AS Vf3
JOIN v_Dominika_Jancova_project_SQL_primary_final_question4 AS Vf4
	ON week_period = payroll_quarter
WHERE 
	Vf3.week_period = 2
	AND Vf4.payroll_quarter = 1
;