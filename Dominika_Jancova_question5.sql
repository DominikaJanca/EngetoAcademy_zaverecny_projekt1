-- -- SQL závěrečný projekt --
-- 5.OTÁZKA --
	-- Má výška HDP vliv na změny ve mzdách a cenách potravin? 
	-- Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?
-- DATOVÉ SADY --
 
SELECT 
	*
FROM countries;
	
SELECT	
	*
FROM economies
WHERE 
	country = 'czech republic' AND
	`year` BETWEEN 2006 AND 2018;
SELECT 
	*
FROM v_Dominika_Jancova_project_SQL_primary_final_question4;

SELECT
	*
FROM v_Dominika_Jancova_project_SQL_primary_final_question3;

-- porovnat potraviny/mzdy meziročně s meziročním nárustem HDP -

WITH BASE AS (
SELECT
	country,
	GDP AS GDP_2006,
	LEAD (GDP) OVER (ORDER BY `year`) AS GDP_2007,
	LEAD (GDP,2) OVER (ORDER BY `year`) AS GDP_2008,
	LEAD (GDP,3) OVER (ORDER BY `year`) AS GDP_2009,
	LEAD (GDP,4) OVER (ORDER BY `year`) AS GDP_2010,
	LEAD (GDP,5) OVER (ORDER BY `year`) AS GDP_2011,
	LEAD (GDP,6) OVER (ORDER BY `year`) AS GDP_2012,
	LEAD (GDP,7) OVER (ORDER BY `year`) AS GDP_2013,
	LEAD (GDP,8) OVER (ORDER BY `year`) AS GDP_2014,
	LEAD (GDP,9) OVER (ORDER BY `year`) AS GDP_2015,
	LEAD (GDP,10) OVER (ORDER BY `year`) AS GDP_2016
FROM economies
WHERE 
	country = 'czech republic' AND
	`year` BETWEEN 2006 AND 2016 
ORDER BY year
)
SELECT
	country,
	ROUND ((GDP_2007 - GDP_2006)/GDP_2006 * 100, 2) AS difference_2006_2007,
	ROUND ((GDP_2008 - GDP_2007)/GDP_2007 * 100, 2) AS difference_2007_2008,
	ROUND ((GDP_2009 - GDP_2008)/GDP_2008 * 100, 2) AS difference_2008_2009,
	ROUND ((GDP_2010 - GDP_2009)/GDP_2009 * 100, 2) AS difference_2009_2010,
	ROUND ((GDP_2011 - GDP_2010)/GDP_2010 * 100, 2) AS difference_2010_2011,
	ROUND ((GDP_2012 - GDP_2011)/GDP_2011 * 100, 2) AS difference_2011_2012,
	ROUND ((GDP_2013 - GDP_2012)/GDP_2012 * 100, 2) AS difference_2012_2013,
	ROUND ((GDP_2014 - GDP_2006)/GDP_2013 * 100, 2) AS difference_2013_2014,
	ROUND ((GDP_2015 - GDP_2006)/GDP_2014 * 100, 2) AS difference_2014_2015,
	ROUND ((GDP_2016 - GDP_2015)/GDP_2015 * 100, 2) AS difference_2015_2016
FROM BASE
WHERE GDP_2016
;

CREATE OR REPLACE VIEW v_Dominika_Jancova_project_SQL_primary_final_question5 AS
WITH BASE AS (
SELECT
	country,
	year,
	GDP AS GDP_2006,
	LEAD (GDP) OVER (ORDER BY `year`) AS GDP_2007,
	LEAD (GDP,2) OVER (ORDER BY `year`) AS GDP_2008,
	LEAD (GDP,3) OVER (ORDER BY `year`) AS GDP_2009,
	LEAD (GDP,4) OVER (ORDER BY `year`) AS GDP_2010,
	LEAD (GDP,5) OVER (ORDER BY `year`) AS GDP_2011,
	LEAD (GDP,6) OVER (ORDER BY `year`) AS GDP_2012,
	LEAD (GDP,7) OVER (ORDER BY `year`) AS GDP_2013,
	LEAD (GDP,8) OVER (ORDER BY `year`) AS GDP_2014,
	LEAD (GDP,9) OVER (ORDER BY `year`) AS GDP_2015,
	LEAD (GDP,10) OVER (ORDER BY `year`) AS GDP_2016
FROM economies
WHERE 
	country = 'czech republic' AND
	`year` BETWEEN 2006 AND 2016 
ORDER BY year
)
SELECT
	country,
	year,
	ROUND ((GDP_2007 - GDP_2006)/GDP_2006 * 100, 2) AS difference_2006_2007,
	ROUND ((GDP_2008 - GDP_2007)/GDP_2007 * 100, 2) AS difference_2007_2008,
	ROUND ((GDP_2009 - GDP_2008)/GDP_2008 * 100, 2) AS difference_2008_2009,
	ROUND ((GDP_2010 - GDP_2009)/GDP_2009 * 100, 2) AS difference_2009_2010,
	ROUND ((GDP_2011 - GDP_2010)/GDP_2010 * 100, 2) AS difference_2010_2011,
	ROUND ((GDP_2012 - GDP_2011)/GDP_2011 * 100, 2) AS difference_2011_2012,
	ROUND ((GDP_2013 - GDP_2012)/GDP_2012 * 100, 2) AS difference_2012_2013,
	ROUND ((GDP_2014 - GDP_2006)/GDP_2013 * 100, 2) AS difference_2013_2014,
	ROUND ((GDP_2015 - GDP_2006)/GDP_2014 * 100, 2) AS difference_2014_2015,
	ROUND ((GDP_2016 - GDP_2015)/GDP_2015 * 100, 2) AS difference_2015_2016
FROM BASE
WHERE GDP_2016
;

SELECT
	*
FROM v_Dominika_Jancova_project_SQL_primary_final_question5
;

SELECT 
	*
FROM v_Dominika_Jancova_project_SQL_primary_final_question4
GROUP BY industry_branch_code;

SELECT
	*
FROM v_Dominika_Jancova_project_SQL_primary_final_question3
GROUP BY category_code;

WITH BASE AS (
SELECT
	dj4.name,
	dj4.difference_2006_2007 AS industry_2006_2007,
	dj5.difference_2006_2007 AS HDP_2006_2007,
	dj4.difference_2007_2008 AS industry_2007_2008,
	dj5.difference_2007_2008 AS HDP_2007_2008,
	dj4.difference_2008_2009 AS industry_2008_2009,
	dj5.difference_2008_2009 AS HDP_2008_2009,
	dj4.difference_2009_2010 AS industry_2009_2010,
	dj5.difference_2009_2010 AS HDP_2009_2010,
	dj4.difference_2010_2011 AS industry_2010_2011,
	dj5.difference_2010_2011 AS HDP_2010_2011,
	dj4.difference_2011_2012 AS industry_2011_2012,
	dj5.difference_2011_2012 AS HDP_2011_2012,
	dj4.difference_2012_2013 AS industry_2012_2013,
	dj5.difference_2012_2013 AS HDP_2012_2013,
	dj4.difference_2013_2014 AS industry_2013_2014,
	dj5.difference_2013_2014 AS HDP_2013_2014,
	dj4.difference_2014_2015 AS industry_2014_2015,
	dj5.difference_2014_2015 AS HDP_2014_2015,
	dj4.difference_2015_2016 AS industry_2015_2016,
	dj5.difference_2015_2016 AS HDP_2015_2016
FROM v_Dominika_Jancova_project_SQL_primary_final_question4 AS dj4
LEFT JOIN v_Dominika_Jancova_project_SQL_primary_final_question5 AS dj5
ON dj4.payroll_year = dj5.year
GROUP BY dj4.name
)
SELECT 
	*
FROM BASE
;

WITH BASE AS (
SELECT
	dj3.name,
	dj3.percentual_growth1 AS food_2006_2007,
	dj5.difference_2006_2007 AS HDP_2006_2007,
	dj3.percentual_growth2 AS food_2007_2008,
	dj5.difference_2007_2008 AS HDP_2007_2008,
	dj3.percentual_growth3 AS food_2008_2009,
	dj5.difference_2008_2009 AS HDP_2008_2009,
	dj3.percentual_growth4 AS food_2009_2010,
	dj5.difference_2009_2010 AS HDP_2009_2010,
	dj3.percentual_growth5 AS food_2010_2011,
	dj5.difference_2010_2011 AS HDP_2010_2011,
	dj3.percentual_growth6 AS food_2011_2012,
	dj5.difference_2011_2012 AS HDP_2011_2012,
	dj3.percentual_growth7 AS food_2012_2013,
	dj5.difference_2012_2013 AS HDP_2012_2013,
	dj3.percentual_growth8 AS food_2013_2014,
	dj5.difference_2013_2014 AS HDP_2013_2014,
	dj3.percentual_growth9 AS food_2014_2015,
	dj5.difference_2014_2015 AS HDP_2014_2015,
	dj3.percentual_growth10 AS food_2015_2016,
	dj5.difference_2015_2016 AS HDP_2015_2016
FROM v_Dominika_Jancova_project_SQL_primary_final_question3 AS dj3
LEFT JOIN v_Dominika_Jancova_project_SQL_primary_final_question5 AS dj5
ON dj3.year_period = dj5.year
GROUP BY dj3.name
)
SELECT 
	*
FROM BASE
;

