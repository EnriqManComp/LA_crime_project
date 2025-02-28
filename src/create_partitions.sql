
--- Create new tables by year
CREATE TABLE la_crime_data.year_2010 AS
SELECT * 
FROM la_crime_data.crime_data_2010_2019
WHERE EXTRACT(YEAR FROM date_rptd) = 2010;

CREATE TABLE la_crime_data.year_2011 AS
SELECT * 
FROM la_crime_data.crime_data_2010_2019
WHERE EXTRACT(YEAR FROM date_rptd) = 2011;

CREATE TABLE la_crime_data.year_2012 AS
SELECT * 
FROM la_crime_data.crime_data_2010_2019
WHERE EXTRACT(YEAR FROM date_rptd) = 2012;

CREATE TABLE la_crime_data.year_2013 AS
SELECT * 
FROM la_crime_data.crime_data_2010_2019
WHERE EXTRACT(YEAR FROM date_rptd) = 2013;

CREATE TABLE la_crime_data.year_2014 AS
SELECT * 
FROM la_crime_data.crime_data_2010_2019
WHERE EXTRACT(YEAR FROM date_rptd) = 2014;

CREATE TABLE la_crime_data.year_2015 AS
SELECT * 
FROM la_crime_data.crime_data_2010_2019
WHERE EXTRACT(YEAR FROM date_rptd) = 2015;

CREATE TABLE la_crime_data.year_2016 AS
SELECT * 
FROM la_crime_data.crime_data_2010_2019
WHERE EXTRACT(YEAR FROM date_rptd) = 2016;

CREATE TABLE la_crime_data.year_2017 AS
SELECT * 
FROM la_crime_data.crime_data_2010_2019
WHERE EXTRACT(YEAR FROM date_rptd) = 2017;

CREATE TABLE la_crime_data.year_2018 AS
SELECT * 
FROM la_crime_data.crime_data_2010_2019
WHERE EXTRACT(YEAR FROM date_rptd) = 2018;

CREATE TABLE la_crime_data.year_2019 AS
SELECT * 
FROM la_crime_data.crime_data_2010_2019
WHERE EXTRACT(YEAR FROM date_rptd) = 2019;