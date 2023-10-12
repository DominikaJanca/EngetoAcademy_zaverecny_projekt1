-- SQL závěrečný projekt --
-- 2.OTÁZKA --
	-- Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

-- DATOVÉ SADY --
SELECT *
FROM czechia_payroll cp;

SELECT *
FROM czechia_payroll_calculation cpc;

SELECT *
FROM czechia_payroll_industry_branch cpib;

SELECT *
FROM czechia_payroll_unit cpu;

SELECT *
FROM czechia_payroll_value_type cpvt;

SELECT *
FROM czechia_price cp;

SELECT *
FROM czechia_price_category cpc;

-- POZNATKY Z ANALÝZY DAT --
	-- potřebujeme pouze kód 100 (fyzický)
	-- industry_branch_code pojmenuje jednotlivá pracovní odvětví
	-- nesrovnalosti v datech v tabulce payroll_unit ( code - 80403 znamená Kč a zobrazuje se u počtu zaměstnanců)
	-- potřebujeme pouze Průměrnou hrubou mzdu na zaměstnance - kód 5958
	-- zvolené srovnání po jednotlivých kvartálech díky povaze zdrojových dat
	-- potřebujeme srovnat datumy z obou tabulek (v jedné po týdnu, v druhé po kvartálech)
	-- potřebujeme pouze code 111301 (chleba), 114201 (mléko)
	-- 

-- tvorba datového podkladu v tabulce --
-- FIX [#3]
-- oprava názvu tabulek, aby odpovídaly tomu, co obsahují

SELECT
	*
FROM t_Dominika_Jancova_project_SQL_primary_final;

CREATE OR REPLACE TABLE t_Dominika_Jancova_project_SQL_primary_final2 AS
	SELECT 
		cp.id,
		cp.category_code,
		cpc.name,
		cpc.price_value,
		cpc.price_unit,
		cp.date_from,
		cp.date_to,
		cp.value,
		cp.region_code,
		year (cp.date_from) AS price_year,
		CASE
			WHEN MONTH (cp.date_from) BETWEEN 1 AND 3 THEN 1
			WHEN MONTH (cp.date_from) BETWEEN 4 AND 6 THEN 2
			WHEN MONTH (cp.date_from) BETWEEN 7 AND 9 THEN 3
			ELSE 4
		END AS price_quarter
	FROM czechia_price AS cprice
	JOIN czechia_price_category AS cpprice_c
		ON cprice.category_code = cprice_c.code;
	
FIX [#3]
	
SELECT
	*
FROM t_Dominika_Jancova_project_SQL_primary_final2;

SELECT
	*
FROM t_Dominika_Jancova_project_SQL_primary_final AS t_payroll
LEFT JOIN t_Dominika_Jancova_project_SQL_primary_final2 AS t_price
	ON t_price.price_year = t_payroll.payroll_year
WHERE t_price.price_quarter = t_payroll.payroll_quarter;

CREATE OR REPLACE TABLE t_Dominika_Jancova_project_SQL_primary_final1 AS
	SELECT 
		tDJ1.*,
		tDJ2.id AS 'food_id',
		tDJ2.category_code,
		tDJ2.name AS 'food_name',
		tDJ2.price_value,
		tDJ2.price_unit,
		tDJ2.date_from,
		tDJ2.date_to,
		tDJ2.value AS 'food_value',
		tDJ2.year_period,
		tDJ2.region_code
	FROM t_Dominika_Jancova_project_SQL_primary_final AS t_payroll
	LEFT JOIN t_Dominika_Jancova_project_SQL_primary_final2 AS t_price
		ON t_price.year_period = t_payroll.payroll_year
	WHERE 
		t_price.price_quarter = t_payroll.payroll_quarter
		AND t_payroll.payroll_year BETWEEN 2006 AND 2016			
;

SELECT
	*
FROM t_Dominika_Jancova_project_SQL_primary_final1
WHERE region_code IS NULL;

SELECT
	*
FROM t_Dominika_Jancova_project_SQL_primary_final1
WHERE 
	region_code IS NULL
	AND category_code = 111301 
	OR 
	category_code = 114201
	AND region_code IS NULL;
	
CREATE OR REPLACE VIEW v_Dominika_Jancova_project_SQL_primary_final_question2 AS
	SELECT
		food_id,
		region_code,
		food_name,
		price_value,
		price_unit,
		id,
		name,
		industry_branch_code,
		payroll_year,
		payroll_quarter,
		date_from,
		date_to,
		FLOOR (value / food_value) AS 'how_much_can_i_buy'
	FROM t_Dominika_Jancova_project_SQL_primary_final1 
	WHERE 
			region_code IS NULL
		AND category_code = 111301 
		OR 
			category_code = 114201
		AND region_code IS NULL
	ORDER BY date_from ASC;

SELECT
	*
FROM v_Dominika_Jancova_project_SQL_primary_final_question2;

-- výsledek -- 

SELECT
	*
FROM v_Dominika_Jancova_project_SQL_primary_final_question2
WHERE 
	food_name = 'Chléb konzumní kmínový' AND
	payroll_quarter = 1 AND 
	payroll_year = 2016 
ORDER BY how_much_can_i_buy DESC
;
SELECT
	*
FROM v_Dominika_Jancova_project_SQL_primary_final_question2
WHERE
	food_name = 'Chléb konzumní kmínový' AND
	payroll_quarter = 1 AND 
	payroll_year = 2006
ORDER BY how_much_can_i_buy DESC
;
SELECT
	*
FROM v_Dominika_Jancova_project_SQL_primary_final_question2
WHERE 
	food_name LIKE '%Mléko%' AND
	payroll_quarter = 1 AND 
	payroll_year = 2016 
ORDER BY how_much_can_i_buy DESC
;
SELECT
	*
FROM v_Dominika_Jancova_project_SQL_primary_final_question2
WHERE
	food_name = 'Mléko polotučné pasterované' AND
	payroll_quarter = 1 AND 
	payroll_year = 2006
ORDER BY how_much_can_i_buy DESC;
