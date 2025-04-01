--- EXPLORATORY DATA ANALYSIS

--- Number of crimes by year

SELECT 
	EXTRACT(YEAR FROM date_rptd) AS year_committed,
	COUNT (*) AS total_cases
FROM la_crime_data.crime_data_2010_2019
GROUP BY year_committed
ORDER BY year_committed;

--- Top 5 years with the most crimes 

SELECT 
	EXTRACT(YEAR FROM TO_DATE(date_rptd, 'YYYY/MM/DD')) AS year_committed,
	COUNT (*) AS total_cases
FROM la_crime_data.crime_data_2010_2019
GROUP BY year_committed
ORDER BY total_cases DESC
LIMIT 5;

--- Rate of change in crime cases compared to the previous year

WITH yearly_crime_data AS (
	SELECT 
		EXTRACT(YEAR FROM TO_DATE(date_rptd, 'YYYY/MM/DD')) AS year_committed,
		COUNT (*) AS total_cases
	FROM la_crime_data.crime_data_2010_2019
	GROUP BY year_committed
)

SELECT
	year_committed,
	total_cases,
	LAG(total_cases) OVER (ORDER BY year_committed) AS previous_year_cases,
	ROUND(
        (total_cases - LAG(total_cases) OVER (ORDER BY year_committed))::NUMERIC 
        / NULLIF(LAG(total_cases) OVER (ORDER BY year_committed), 0) * 100, 
        2
    ) AS crime_rate_change_percentage
FROM yearly_crime_data
ORDER BY crime_rate_change_percentage DESC;

--- Total Cases by Area

SELECT
	area_name,
	COUNT (*) AS total_cases
FROM la_crime_data.crime_data_2010_2019
GROUP BY area_name
ORDER BY total_cases DESC;

--- Total Cases by District

SELECT
	rpt_dist_no,
	COUNT (*) AS total_cases
FROM la_crime_data.crime_data_2010_2019
GROUP BY rpt_dist_no;

--- Most frequent type of crime by area

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

SELECT
	MIN(vict_age) AS min_age,
	MAX(vict_age) AS max_age,
	PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY vict_age) AS perc_25_age,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY vict_age) AS median_age,
	PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY vict_age) AS perc_75_age,
	STDDEV(vict_age) AS std_age
FROM la_crime_data.crime_data_2010_2019;

--- Count of victims by their sex

SELECT 
	vict_sex,
	COUNT (*) AS total_cases
FROM la_crime_data.crime_data_2010_2019
GROUP BY vict_sex;

--- Number of Crimes Related to the Race of the Victim

SELECT 
	vict_descent,
	COUNT (*) AS total_cases
FROM la_crime_data.crime_data_2010_2019
GROUP BY vict_descent
ORDER BY total_cases DESC;

--- The top 3 most frequent crimes based in the Race of the Victim

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
	

