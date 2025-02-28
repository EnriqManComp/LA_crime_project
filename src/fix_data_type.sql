-------- 4.1 Fix Field Types -------------

ALTER TABLE la_crime_data.crime_data_2010_2019
	ALTER COLUMN premis_cd SET DATA TYPE INTEGER USING premis_cd::INTEGER,
	ALTER COLUMN weapon_used_cd SET DATA TYPE INTEGER USING weapon_used_cd::INTEGER,
	ALTER COLUMN lat SET DATA TYPE TEXT USING lat::TEXT,
	ALTER COLUMN lon SET DATA TYPE TEXT USING lon::TEXT;

--- Fixing Date Fields

UPDATE la_crime_data.crime_data_2010_2019
SET date_rptd = TO_TIMESTAMP(date_rptd, 'MM/DD/YYYY HH12:MI:SS AM')::TIMESTAMP;

UPDATE la_crime_data.crime_data_2010_2019
SET date_occ = TO_TIMESTAMP(date_occ, 'MM/DD/YYYY HH12:MI:SS AM')::TIMESTAMP;

UPDATE la_crime_data.crime_data_2010_2019
SET date_rptd = TO_DATE(date_rptd, 'YYYY/MM/DD');

UPDATE la_crime_data.crime_data_2010_2019
SET date_occ = TO_DATE(date_occ, 'YYYY/MM/DD');

--- Convert "time_occ" military hour field to only military hour
ALTER TABLE la_crime_data.crime_data_2010_2019
ADD COLUMN rounded_time_occ INTEGER;

UPDATE la_crime_data.crime_data_2010_2019
SET rounded_time_occ = ROUND(LEFT(time_occ, 2)::INTEGER + RIGHT(time_occ, 2)::INTEGER / 60.0);

ALTER TABLE la_crime_data.crime_data_2010_2019
DROP COLUMN time_occ;

--- Fixing Data Type of date reported field
ALTER TABLE la_crime_data.crime_data_2010_2019
    ALTER COLUMN date_rptd SET DATA TYPE DATE USING date_rptd::DATE;