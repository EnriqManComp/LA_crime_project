
--- Number of crimes by year & Rate of change in crime cases compared to the previous year
CREATE VIEW la_crime_data.crime_by_year AS
	WITH n_crimes_by_year AS (
		SELECT EXTRACT(YEAR FROM date_rptd) AS year, COUNT(*) AS total_cases
		FROM la_crime_data.crime_data_2010_2019
		GROUP BY EXTRACT(YEAR FROM date_rptd)
		ORDER BY year
		)
	
	SELECT
		year,
		total_cases,
		ROUND(
			(total_cases - LAG(total_cases) OVER (ORDER BY year)::NUMERIC)
			/ (NULLIF(LAG(total_cases) OVER (ORDER BY year),0)) * 100,
			2
		) AS crime_rate_change_percentage
	FROM n_crimes_by_year;

--- Total Cases by Area & Percentage of the total
CREATE VIEW la_crime_data.total_cases_by_area AS
	SELECT
		area_name,
		COUNT(*) AS total_cases,
		(COUNT(*) * 100.0) / (SELECT COUNT(*) FROM la_crime_data.crime_data_2010_2019) AS percentage_of_total
	FROM la_crime_data.crime_data_2010_2019
	GROUP BY area_name;


--- Total Cases by District
CREATE VIEW la_crime_data.crimes_by_district AS
	SELECT
	rpt_dist_no,
	COUNT (*) AS total_cases
	FROM la_crime_data.crime_data_2010_2019
	GROUP BY rpt_dist_no;

--- Most frequent type of crime by area
CREATE VIEW la_crime_data.most_freq_crimes_by_area AS
	WITH ranked_cases AS (
		SELECT 
			area_name,
			crm_cd,
			COUNT(*) AS total_cases,
			ROW_NUMBER() OVER (PARTITION BY area_name ORDER BY COUNT(*) DESC) AS rank
		FROM la_crime_data.crime_data_2010_2019
		GROUP BY area_name, crm_cd
	)
	SELECT 
		area_name,
		crm_cd,
		total_cases
	FROM ranked_cases
	WHERE rank <= 5
	ORDER BY area_name, total_cases DESC;
	
--- Statistics of the victims
CREATE VIEW la_crime_data.vict_stats AS
	SELECT
		MIN(vict_age) AS min_age,
		MAX(vict_age) AS max_age,
		PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY vict_age) AS perc_25_age,
		PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY vict_age) AS median_age,
		PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY vict_age) AS perc_75_age,
		STDDEV(vict_age) AS std_age
	FROM la_crime_data.crime_data_2010_2019;

--- Count of victims by their sex
CREATE OR REPLACE VIEW la_crime_data.vict_sex AS
	SELECT 
		vict_sex,
		COUNT (*) AS total_cases,
		COUNT (*) * 100 / (SELECT COUNT(*) FROM la_crime_data.crime_data_2010_2019) AS perc_total_cases
	FROM la_crime_data.crime_data_2010_2019
	GROUP BY vict_sex;

--- Number of Crimes Related to the Race of the Victim
CREATE OR REPLACE VIEW crimes_by_race AS
	SELECT 
		vict_descent,
		COUNT(*) AS total_cases,
		(COUNT(*) * 100.0) / (SELECT COUNT(*) FROM la_crime_data.crime_data_2010_2019) AS perc_vict_descent
	FROM la_crime_data.crime_data_2010_2019
	GROUP BY vict_descent
	ORDER BY total_cases DESC;

--- The top 3 most frequent crimes based in the Race of the Victim
CREATE OR REPLACE VIEW la_crime_data.top_3_crimes_by_race AS
	WITH rank_crime_descent AS (
		SELECT 
			vict_descent,
			crm_cd,
			COUNT (*) AS total_cases,
			ROW_NUMBER() OVER (PARTITION BY vict_descent ORDER BY COUNT (*) DESC) AS rank_crime
		FROM la_crime_data.crime_data_2010_2019
		GROUP BY vict_descent,crm_cd
	)
	SELECT
		vict_descent,
		crm_cd,
		total_cases
	FROM rank_crime_descent
	WHERE rank_crime <= 3;

--- Number of Crimes Related to the Race of the Victim & the Sex
CREATE OR REPLACE VIEW la_crime_data.crimes_by_race_sex AS
	WITH base_data AS (
		-- Base data table contains information about vict_descent, vict_sex, and the total cases
		SELECT 
			vict_descent,
			vict_sex,
			COUNT(*) AS total_cases
		FROM la_crime_data.crime_data_2010_2019
		GROUP BY vict_descent, vict_sex
	),
	missing_sex AS (
		-- Missing Sex Table: Generate missing vict_sex = 'X' rows for each vict_descent
		SELECT
			-- Generate these information if the where clause return 1
			bd.vict_descent,
			'X' AS vict_sex,
			0 AS total_cases
		-- from base data table
		FROM base_data AS bd
		WHERE NOT EXISTS (
			--- return 1 (efficiency method) if there is a value in the base data table
			--- where the data in vict_sex is equal to 'X', otherwise return no rows
			SELECT 1 FROM base_data AS b2
			WHERE b2.vict_descent = bd.vict_descent AND b2.vict_sex = 'X'
		)		
	),
	combined_data AS (
		-- Combine base data table with the missing sex table
		SELECT * FROM base_data
		UNION ALL
		SELECT * FROM missing_sex
	)
	
	-- Compute percentage calculations
	SELECT 
		vict_descent,
		vict_sex,
		SUM(total_cases) AS total_cases,
		(SUM(total_cases) * 100.0) / (SELECT COUNT(*) FROM la_crime_data.crime_data_2010_2019) AS perc_vict_descent_total,
		(SUM(total_cases) * 100.0) / SUM(SUM(total_cases)) OVER (PARTITION BY vict_descent) AS perc_vict_sex_into_descent
	FROM combined_data
	GROUP BY vict_descent, vict_sex
	ORDER BY vict_descent, vict_sex;

--- Crime code in the most dangerous area over the time (using database year partitions)
--- We create 10 views from 2010 to 2019

CREATE OR REPLACE VIEW la_crime_data.most_dang_crm_cd_area_2010 AS
	WITH most_dang_area AS (
		SELECT 
			area_name,
			crm_cd,
			crm_cd_desc,
			COUNT(*) AS total_cases
		FROM la_crime_data.year_2010
		GROUP BY area_name, crm_cd, crm_cd_desc
		ORDER BY total_cases DESC
		LIMIT 1
	),
	crimes_by_month AS (
		SELECT
			EXTRACT(YEAR FROM (date_rptd)) AS year,
			area_name,
			crm_cd,
			crm_cd_desc,
			EXTRACT(MONTH FROM date_rptd) AS months,
			COUNT(*) AS total_cases
		FROM la_crime_data.year_2010
		GROUP BY EXTRACT(YEAR FROM (date_rptd)), area_name, crm_cd, crm_cd_desc, months
		ORDER BY area_name, crm_cd, crm_cd_desc, months
	),
	combined_data AS (
		SELECT cbm.year, cbm.area_name, cbm.crm_cd, cbm.crm_cd_desc, cbm.months, cbm.total_cases
		FROM crimes_by_month AS cbm
		JOIN most_dang_area AS mda ON cbm.area_name = mda.area_name AND cbm.crm_cd = mda.crm_cd
	)

-- Final ordered result
SELECT * FROM combined_data
ORDER BY months;

