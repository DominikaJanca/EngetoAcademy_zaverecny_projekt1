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
		year (cp.date_from) AS price_year,
		CASE
			WHEN MONTH (cp.date_from) BETWEEN 1 AND 3 THEN 1
			WHEN MONTH (cp.date_from) BETWEEN 4 AND 6 THEN 2
			WHEN MONTH (cp.date_from) BETWEEN 7 AND 9 THEN 3
			ELSE 4
		END AS price_quarter
	FROM czechia_price cp
	JOIN czechia_price_category cpc
		ON cp.category_code = cpc.code;

SELECT
	*
FROM t_Dominika_Jancova_project_SQL_primary_final2;

SELECT
	*
FROM t_Dominika_Jancova_project_SQL_primary_final AS tDJ1
LEFT JOIN t_Dominika_Jancova_project_SQL_primary_final2 AS tDJ2
	ON tDJ2.price_year = tDJ1.payroll_year
WHERE tDJ2.price_quarter = tDJ1.payroll_quarter;

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
		tDJ2.price_year,
		tDJ2.price_quarter
	FROM t_Dominika_Jancova_project_SQL_primary_final AS tDJ1
	LEFT JOIN t_Dominika_Jancova_project_SQL_primary_final2 AS tDJ2
		ON tDJ2.price_year = tDJ1.payroll_year
	WHERE tDJ2.price_quarter = tDJ1.payroll_quarter;

SELECT
	*
FROM t_Dominika_Jancova_project_SQL_primary_final1;

SELECT
	*
FROM t_Dominika_Jancova_project_SQL_primary_final1
WHERE category_code = 111301 OR 
	category_code = 114201;
	
CREATE OR REPLACE VIEW v_Dominika_Jancova_project_SQL_primary_final_question2 AS
	SELECT
		food_id,
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
		category_code = 111301 OR 
		category_code = 114201
	ORDER BY date_from ASC;

SELECT
	*
FROM v_Dominika_Jancova_project_SQL_primary_final_question2;

-- zkouška -- 

SELECT
	*
FROM v_Dominika_Jancova_project_SQL_primary_final_question2
WHERE 
	industry_branch_code = 'B'AND
	food_name = 'Chléb konzumní kmínový' AND
	payroll_quarter = 1
ORDER BY date_from DESC;
