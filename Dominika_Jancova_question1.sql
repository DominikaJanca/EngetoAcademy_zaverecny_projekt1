-- SQL závěrečný projekt --
-- 1.OTÁZKA --
	-- Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
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

-- POZNATKY Z ANALÝZY DAT --
-- potřebujeme pouze kód 100 (fyzický)
-- industry_branch_code pojmenuje jednotlivá pracovní odvětví
-- nesrovnalosti v datech v tabulce payroll_unit ( code - 80403 znamená Kč a zobrazuje se u počtu zaměstnanců)
-- potřebujeme pouze Průměrnou hrubou mzdu na zaměstnance - kód 5958
-- zvolené srovnání po jednotlivých kvartálech díky povaze zdrojových dat

-- tvorba datového podkladu v tabulce --

SELECT
	*
FROM czechia_payroll cp
WHERE 
	value_type_code = 5958
	AND calculation_code = 100;
	
SELECT
	cp.payroll_year,
	cp.payroll_quarter,
	cp.industry_branch_code,
	cpib.name,
	cp.value
FROM czechia_payroll cp
JOIN czechia_payroll_industry_branch cpib
	ON cp.industry_branch_code = cpib.code
WHERE 
	value_type_code = 5958
	AND calculation_code = 100;
	
CREATE OR REPLACE TABLE t_Dominika_Jancova_project_SQL_primary_final
	SELECT
		cp.id,
		cp.payroll_year,
		cp.payroll_quarter,
		cp.industry_branch_code,
		cpib.name,
		cp.value
	FROM czechia_payroll cp
	JOIN czechia_payroll_industry_branch cpib
		ON cp.industry_branch_code = cpib.code
	WHERE 
		value_type_code = 5958
		AND calculation_code = 100;
		
SELECT	
	*
FROM t_Dominika_Jancova_project_SQL_primary_final;

-- ODPOVĚĎ NA OTÁZKU -- 

CREATE OR REPLACE VIEW v_Dominika_Jancova_project_SQL_primary_final_question_1 AS
	SELECT
		tDJ1.id,
		tDJ1.industry_branch_code,
		tDJ1.name,
		tDJ1.payroll_quarter,
		tDJ1.payroll_year AS 'payroll_previous_year',
		tDJ2.payroll_year AS 'payroll_next_year',
		tDJ1.value AS 'value_previous_year',
		tDJ2.value AS 'value_next_year',
		(tDJ2.value - tDJ1.value) AS 'difference_in_value'
	FROM t_Dominika_Jancova_project_SQL_primary_final AS tDJ1
	JOIN t_Dominika_Jancova_project_SQL_primary_final AS tDJ2
		ON tDJ2.payroll_year = tDJ1.payroll_year + 1
	WHERE 
		tDJ1.payroll_quarter = tDJ2.payroll_quarter AND
		tDJ1.industry_branch_code = tDJ2.industry_branch_code;
	
SELECT 
	*
FROM v_Dominika_Jancova_project_SQL_primary_final_question_1;

SELECT 
	*,
	CASE 
		WHEN difference_in_value < 0 THEN 1
		ELSE 0
	END AS 'decrease_of_payroll'
FROM v_Dominika_Jancova_project_SQL_primary_final_question_1;

CREATE OR REPLACE VIEW v_Dominika_Jancova_project_SQL_primary_final_question_1 AS
	SELECT
		tDJ1.id,
		tDJ1.industry_branch_code,
		tDJ1.name,
		tDJ1.payroll_quarter,
		tDJ1.payroll_year AS 'payroll_previous_year',
		tDJ2.payroll_year AS 'payroll_next_year',
		tDJ1.value AS 'value_previous_year',
		tDJ2.value AS 'value_next_year',
		(tDJ2.value - tDJ1.value) AS 'difference_in_value',
		CASE 
			WHEN (tDJ2.value - tDJ1.value) < 0 THEN 1
			ELSE 0
		END AS 'decrease_of_payroll'
	FROM t_Dominika_Jancova_project_SQL_primary_final AS tDJ1
	JOIN t_Dominika_Jancova_project_SQL_primary_final AS tDJ2
		ON tDJ2.payroll_year = tDJ1.payroll_year + 1
	WHERE 
		tDJ1.payroll_quarter = tDJ2.payroll_quarter AND
		tDJ1.industry_branch_code = tDJ2.industry_branch_code;
	
SELECT 
	*
FROM v_Dominika_Jancova_project_SQL_primary_final_question_1;

SELECT 
	*
FROM v_Dominika_Jancova_project_SQL_primary_final_question_1
WHERE decrease_of_payroll = 1
AND payroll_previous_year BETWEEN 2006 AND 2016
;

SELECT *
FROM czechia_payroll_industry_branch cpib
;
WHERE code NOT IN ('A','B','C', 'D','E','F','G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S' );

SELECT 
	*
FROM v_Dominika_Jancova_project_SQL_primary_final_question_1
WHERE 
	decrease_of_payroll = 1
AND payroll_previous_year BETWEEN 2006 AND 2016
ORDER BY payroll_previous_year
;

SELECT 
	*
FROM v_Dominika_Jancova_project_SQL_primary_final_question_1
WHERE 
	decrease_of_payroll = 1
AND payroll_previous_year BETWEEN 2006 AND 2016
AND industry_branch_code = 'B'
ORDER BY payroll_previous_year
;


-- další možnosti jak odpověď rozšířit je přidávat další roky -- 
SELECT 
	vDJ1.*,
	vDJ2.payroll_next_year AS 'payroll_next_year_2',
	vDJ2.value_next_year AS 'value_next_year_2',
	(vDJ2.value_next_year - vDJ1.value_next_year) AS 'difference_in_value_2',
	vDJ3.payroll_next_year AS 'payroll_next_year_3',
	vDJ3.value_next_year AS 'value_next_year_3',
	vDJ4.payroll_next_year AS 'payroll_next_year_4',
	vDJ4.value_next_year AS 'value_next_year_4'
FROM v_Dominika_Jancova_project_SQL_primary_final_question_1 AS vDJ1
JOIN v_Dominika_Jancova_project_SQL_primary_final_question_1 AS vDJ2
	ON vDJ2.payroll_next_year = vDJ1.payroll_next_year + 1
JOIN v_Dominika_Jancova_project_SQL_primary_final_question_1 AS vDJ3
	ON vDJ3.payroll_next_year = vDJ1.payroll_next_year + 2
JOIN v_Dominika_Jancova_project_SQL_primary_final_question_1 AS vDJ4
	ON vDJ4.payroll_next_year = vDJ1.payroll_next_year + 3
WHERE 
	vDJ1.payroll_quarter = vDJ2.payroll_quarter AND
	vDJ1.industry_branch_code = vDJ2.industry_branch_code AND
	vDJ1.industry_branch_code = vDJ3.industry_branch_code AND
	vDJ1.payroll_quarter = vDJ3.payroll_quarter AND
	vDJ1.payroll_quarter = vDJ4.payroll_quarter AND
	vDJ1.industry_branch_code = vDJ4.industry_branch_code;
		
