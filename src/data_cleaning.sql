--- Data Cleaning ---

--- Steps:

--- 1. Remove duplicates
--- 2. Null values
--- 3. Remove Unnecessary columns
--- 4. Standardize the Data
---   4.1 Fix Field Types
---   4.2 Handling missing values
---   4.3 Create a new table with the different modus operandis code by crime record

---

-------- Remove duplicates ---------

--- A sample of the data
SELECT * FROM la_crime_data.crime_data_2010_2019
LIMIT 10;

--- Create a field named row_num with the count of duplicated records
--- and filter the records that are duplicated

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
	PARTITION BY dr_no
) AS row_num
FROM la_crime_data.crime_data_2010_2019
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

--- Close looking to a duplicate record ---

SELECT *
FROM la_crime_data.crime_data_2010_2019
WHERE dr_no = 110706367;

--- Count of duplicated records

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
	PARTITION BY dr_no
) AS row_num
FROM la_crime_data.crime_data_2010_2019
)
SELECT COUNT(*) AS total_duplicate_values
FROM duplicate_cte
WHERE row_num > 1;

--- Remove duplicated records

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
	PARTITION BY dr_no
) AS row_num
FROM la_crime_data.crime_data_2010_2019
)
DELETE FROM la_crime_data.crime_data_2010_2019
WHERE dr_no IN (
	SELECT dr_no FROM duplicate_cte WHERE row_num > 1
);


-------------- Null values -------------

--- Count the number of null values in each field
SELECT
	COUNT (*) FILTER (WHERE dr_no IS NULL) AS dr_no_nulls,
	COUNT (*) FILTER (WHERE date_rptd IS NULL) AS date_rptd_nulls,
	COUNT(*) FILTER (WHERE date_occ IS NULL) AS date_occ_nulls,
    COUNT(*) FILTER (WHERE time_occ IS NULL) AS time_occ_nulls,
    COUNT(*) FILTER (WHERE area IS NULL) AS area_nulls,
    COUNT(*) FILTER (WHERE area_name IS NULL) AS area_name_nulls,
    COUNT(*) FILTER (WHERE rpt_dist_No IS NULL) AS rpt_dist_No_nulls,
    COUNT(*) FILTER (WHERE part_1_2 IS NULL) AS part_1_2_nulls,
    COUNT(*) FILTER (WHERE crm_cd IS NULL) AS crm_cd_nulls,
    COUNT(*) FILTER (WHERE crm_cd_desc IS NULL) AS crm_cd_desc_nulls,
    COUNT(*) FILTER (WHERE mocodes IS NULL) AS mocodes_nulls,
    COUNT(*) FILTER (WHERE vict_age IS NULL) AS vict_age_nulls,
    COUNT(*) FILTER (WHERE vict_sex IS NULL) AS vict_sex_nulls,
    COUNT(*) FILTER (WHERE vict_descent IS NULL) AS vict_descent_nulls,
    COUNT(*) FILTER (WHERE premis_cd IS NULL) AS premis_cd_nulls,
    COUNT(*) FILTER (WHERE premis_desc IS NULL) AS premis_desc_nulls,
    COUNT(*) FILTER (WHERE weapon_used_cd IS NULL) AS weapon_used_cd_nulls,
    COUNT(*) FILTER (WHERE weapon_desc IS NULL) AS weapon_desc_nulls,
    COUNT(*) FILTER (WHERE status IS NULL) AS status_nulls,
    COUNT(*) FILTER (WHERE status_desc IS NULL) AS status_desc_nulls,
    COUNT(*) FILTER (WHERE crm_cd_1 IS NULL) AS crm_cd_1_nulls,
    COUNT(*) FILTER (WHERE crm_cd_2 IS NULL) AS crm_cd_2_nulls,
    COUNT(*) FILTER (WHERE crm_cd_3 IS NULL) AS crm_cd_3_nulls,
    COUNT(*) FILTER (WHERE crm_cd_4 IS NULL) AS crm_cd_4_nulls,
    COUNT(*) FILTER (WHERE location IS NULL) AS location_nulls,
    COUNT(*) FILTER (WHERE cross_street IS NULL) AS cross_street_nulls,
    COUNT(*) FILTER (WHERE lat IS NULL) AS lat_nulls,
    COUNT(*) FILTER (WHERE lon IS NULL) AS lon_nulls
FROM la_crime_data.crime_data_2010_2019;

--- Compute the percentage of null values in the dataset by field

SELECT
	COUNT (*) FILTER (WHERE dr_no IS NULL) * 100 / COUNT(*) AS dr_no_null_perc,
	COUNT (*) FILTER (WHERE date_rptd IS NULL) * 100 / COUNT(*) AS date_rptd_null_perc,
	COUNT(*) FILTER (WHERE date_occ IS NULL) * 100 / COUNT(*) AS date_occ_null_perc,
    COUNT(*) FILTER (WHERE time_occ IS NULL)* 100 / COUNT(*) AS time_occ_null_perc,
    COUNT(*) FILTER (WHERE area IS NULL)* 100 / COUNT(*) AS area_null_perc,
    COUNT(*) FILTER (WHERE area_name IS NULL)* 100 / COUNT(*) AS area_name_null_perc,
    COUNT(*) FILTER (WHERE rpt_dist_No IS NULL)* 100 / COUNT(*) AS rpt_dist_No_null_perc,
    COUNT(*) FILTER (WHERE part_1_2 IS NULL)* 100 / COUNT(*) AS part_1_2_null_perc,
    COUNT(*) FILTER (WHERE crm_cd IS NULL)* 100 / COUNT(*) AS crm_cd_null_perc,
    COUNT(*) FILTER (WHERE crm_cd_desc IS NULL)* 100 / COUNT(*) AS crm_cd_desc_null_perc,
    COUNT(*) FILTER (WHERE mocodes IS NULL)* 100 / COUNT(*) AS mocodes_null_perc,
    COUNT(*) FILTER (WHERE vict_age IS NULL)* 100 / COUNT(*) AS vict_age_null_perc,
    COUNT(*) FILTER (WHERE vict_sex IS NULL)* 100 / COUNT(*) AS vict_sex_null_perc,
    COUNT(*) FILTER (WHERE vict_descent IS NULL)* 100 / COUNT(*) AS vict_descent_null_perc,
    COUNT(*) FILTER (WHERE premis_cd IS NULL)* 100 / COUNT(*) AS premis_cd_null_perc,
    COUNT(*) FILTER (WHERE premis_desc IS NULL)* 100 / COUNT(*) AS premis_desc_null_perc,
    COUNT(*) FILTER (WHERE weapon_used_cd IS NULL)* 100 / COUNT(*) AS weapon_used_cd_null_perc,
    COUNT(*) FILTER (WHERE weapon_desc IS NULL)* 100 / COUNT(*) AS weapon_desc_null_perc,
    COUNT(*) FILTER (WHERE status IS NULL)* 100 / COUNT(*) AS status_null_perc,
    COUNT(*) FILTER (WHERE status_desc IS NULL)* 100 / COUNT(*) AS status_desc_null_perc,
    COUNT(*) FILTER (WHERE crm_cd_1 IS NULL)* 100 / COUNT(*) AS crm_cd_1_null_perc,
    COUNT(*) FILTER (WHERE crm_cd_2 IS NULL)* 100 / COUNT(*) AS crm_cd_2_null_perc,
    COUNT(*) FILTER (WHERE crm_cd_3 IS NULL)* 100 / COUNT(*) AS crm_cd_3_null_perc,
    COUNT(*) FILTER (WHERE crm_cd_4 IS NULL)* 100 / COUNT(*) AS crm_cd_4_null_perc,
    COUNT(*) FILTER (WHERE location IS NULL)* 100 / COUNT(*) AS location_null_perc,
    COUNT(*) FILTER (WHERE cross_street IS NULL)* 100 / COUNT(*) AS cross_street_null_perc,
    COUNT(*) FILTER (WHERE lat IS NULL)* 100 / COUNT(*) AS lat_null_perc,
    COUNT(*) FILTER (WHERE lon IS NULL)* 100 / COUNT(*) AS lon_null_perc
FROM la_crime_data.crime_data_2010_2019;

-------------- Remove Unnecessary Fields -------------

--- Drop the fields with the highest percentage of null values
ALTER TABLE la_crime_data.crime_data_2010_2019
DROP COLUMN weapon_desc,
DROP COLUMN crm_cd_2,
DROP COLUMN crm_cd_3,
DROP COLUMN crm_cd_4,
DROP COLUMN cross_street;
--- Remove Part 1_2 Field
ALTER TABLE la_crime_data.crime_data_2010_2019
DROP COLUMN part_1_2;


-------------- 4. Standardize the Data -------------
-------- 4.1 Fix Field Types -------------

ALTER TABLE la_crime_data.crime_data_2010_2019
	ALTER COLUMN premis_cd SET DATA TYPE INTEGER USING premis_cd::INTEGER,
	ALTER COLUMN weapon_used_cd SET DATA TYPE INTEGER USING weapon_used_cd::INTEGER,
	ALTER COLUMN lat SET DATA TYPE FLOAT USING lat::FLOAT,
	ALTER COLUMN lon SET DATA TYPE FLOAT USING lon::FLOAT;

-------- 4.2 Handling missing values -------------
--- Different values in each field
SELECT DISTINCT crm_cd
FROM la_crime_data.crime_data_2010_2019

--- Set to code 0 the null values
UPDATE la_crime_data.crime_data_2010_2019
SET weapon_used_cd = 0
WHERE weapon_used_cd IS NULL;

--- Count of different victim sex
SELECT vict_sex, COUNT(*)
FROM la_crime_data.crime_data_2010_2019
GROUP BY vict_sex;

--- Set to Unknown (X) the null values and the values different to M or F
UPDATE la_crime_data.crime_data_2010_2019
SET vict_sex = 'X'
WHERE vict_sex IS NULL;

UPDATE la_crime_data.crime_data_2010_2019
SET vict_sex = 'X'
WHERE vict_sex = 'H';

UPDATE la_crime_data.crime_data_2010_2019
SET vict_sex = 'X'
WHERE vict_sex = 'N';

--- Count of different victim descent 
SELECT vict_descent, COUNT(*)
FROM la_crime_data.crime_data_2010_2019
GROUP BY vict_descent;

--- Set to Unknown (X) to the values null or out of the possible category values
UPDATE la_crime_data.crime_data_2010_2019
SET vict_descent = 'X'
WHERE vict_descent = '-';

UPDATE la_crime_data.crime_data_2010_2019
SET vict_descent = 'X'
WHERE vict_descent IS NULL;

--- Count of different modus operandi codes
SELECT mocodes, COUNT(*)
FROM la_crime_data.crime_data_2010_2019
GROUP BY mocodes;

UPDATE la_crime_data.crime_data_2010_2019
SET mocodes = '0000'
WHERE mocodes IS NULL;

--- Divide the modus operandis codes (mocodes) in different fields
--- Get the maximum number of mocodes of all the records
SELECT *
FROM la_crime_data.crime_data_2010_2019
ORDER BY LENGTH(mocodes) DESC
LIMIT 1;

--- Create the fields
ALTER TABLE la_crime_data.crime_data_2010_2019
ADD COLUMN mocode_1 TEXT,
ADD COLUMN mocode_2 TEXT,
ADD COLUMN mocode_3 TEXT,
ADD COLUMN mocode_4 TEXT,
ADD COLUMN mocode_5 TEXT,
ADD COLUMN mocode_6 TEXT,
ADD COLUMN mocode_7 TEXT,
ADD COLUMN mocode_8 TEXT,
ADD COLUMN mocode_9 TEXT,
ADD COLUMN mocode_10 TEXT;

--- Populate the new fields with the mocodes
UPDATE la_crime_data.crime_data_2010_2019
SET 
    mocode_1 = NULLIF(split_part(mocodes, ' ', 1), ''),
    mocode_2 = NULLIF(split_part(mocodes, ' ', 2), ''),
    mocode_3 = NULLIF(split_part(mocodes, ' ', 3), ''),
    mocode_4 = NULLIF(split_part(mocodes, ' ', 4), ''),
    mocode_5 = NULLIF(split_part(mocodes, ' ', 5), ''),
    mocode_6 = NULLIF(split_part(mocodes, ' ', 6), ''),
    mocode_7 = NULLIF(split_part(mocodes, ' ', 7), ''),
    mocode_8 = NULLIF(split_part(mocodes, ' ', 8), ''),
    mocode_9 = NULLIF(split_part(mocodes, ' ', 9), ''),
    mocode_10 = NULLIF(split_part(mocodes, ' ', 10), '');

--- Fill the null fields with the code 0000
UPDATE la_crime_data.crime_data_2010_2019
SET 
    mocode_1 = COALESCE(mocode_1, '0000'),
    mocode_2 = COALESCE(mocode_2, '0000'),
    mocode_3 = COALESCE(mocode_3, '0000'),
    mocode_4 = COALESCE(mocode_4, '0000'),
    mocode_5 = COALESCE(mocode_5, '0000'),
    mocode_6 = COALESCE(mocode_6, '0000'),
    mocode_7 = COALESCE(mocode_7, '0000'),
    mocode_8 = COALESCE(mocode_8, '0000'),
    mocode_9 = COALESCE(mocode_9, '0000'),
    mocode_10 = COALESCE(mocode_10, '0000');

--- Create a new table to store the mocodes
CREATE TABLE la_crime_data.mocodes_data (
	dr_no BIGINT,
	mocode_1 TEXT,
	mocode_2 TEXT,
	mocode_3 TEXT,
	mocode_4 TEXT,
	mocode_5 TEXT,
	mocode_6 TEXT,
	mocode_7 TEXT,
	mocode_8 TEXT,
	mocode_9 TEXT,
	mocode_10 TEXT
);

--- Insert the mocodes into the new table
INSERT INTO la_crime_data.mocodes_data (
	dr_no, mocode_1, mocode_2, mocode_3, mocode_4, mocode_5,
	mocode_6, mocode_7,	mocode_8, mocode_9,	mocode_10
)
SELECT dr_no, mocode_1, mocode_2, mocode_3, mocode_4, mocode_5,
	mocode_6, mocode_7, mocode_8, mocode_9, mocode_10
FROM la_crime_data.crime_data_2010_2019;

--- Drop mocodes from crime_data_2010_2019
ALTER TABLE la_crime_data.crime_data_2010_2019
DROP COLUMN mocodes,
DROP COLUMN mocode_1,
DROP COLUMN mocode_2,
DROP COLUMN mocode_3,
DROP COLUMN mocode_4,
DROP COLUMN mocode_5,
DROP COLUMN mocode_6,
DROP COLUMN mocode_7,
DROP COLUMN mocode_8,
DROP COLUMN mocode_9,
DROP COLUMN mocode_10;

--- Change "-" typing value to 0000 code
UPDATE la_crime_data.mocodes_data
SET mocode_2 = '0000'
WHERE mocode_2 = '-';

--- Fix the Data Type of the mocodes
ALTER TABLE la_crime_data.mocodes_data 
ALTER COLUMN mocode_1 SET DATA TYPE INTEGER USING mocode_1::INTEGER,
ALTER COLUMN mocode_2 SET DATA TYPE INTEGER USING mocode_2::INTEGER, 
ALTER COLUMN mocode_3 SET DATA TYPE INTEGER USING mocode_3::INTEGER, 
ALTER COLUMN mocode_4 SET DATA TYPE INTEGER USING mocode_4::INTEGER, 
ALTER COLUMN mocode_5 SET DATA TYPE INTEGER USING mocode_5::INTEGER,
ALTER COLUMN mocode_6 SET DATA TYPE INTEGER USING mocode_6::INTEGER, 
ALTER COLUMN mocode_7 SET DATA TYPE INTEGER USING mocode_7::INTEGER, 
ALTER COLUMN mocode_8 SET DATA TYPE INTEGER USING mocode_8::INTEGER,
ALTER COLUMN mocode_9 SET DATA TYPE INTEGER USING mocode_9::INTEGER,
ALTER COLUMN mocode_10 SET DATA TYPE INTEGER USING mocode_10::INTEGER;

 





