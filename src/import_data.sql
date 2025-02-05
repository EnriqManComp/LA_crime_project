--- Convert csv data format to a sql format ---

--- Create a schema for the crime data ---

create schema la_crime_data;

--- First table to store the crime data (Crime_Data_from_2010_to_2019_20250110 csv data)---
create table la_crime_data.crime_data_2010_2019(
    dr_no BIGINT,
    date_rptd TEXT,
    date_occ TEXT,
    time_occ TEXT,
    area INT,
    area_name TEXT,
    rpt_dist_No INT,
    part_1_2 INT,
    crm_cd INT,
    crm_cd_desc TEXT,
    mocodes TEXT,
    vict_age INT,
    vict_sex TEXT,
    vict_descent TEXT,
    premis_cd TEXT,
    premis_desc TEXT,
    weapon_used_cd TEXT,
    weapon_desc TEXT,
    status TEXT,
    status_desc TEXT,
    crm_cd_1 INT,
    crm_cd_2 INT,
    crm_cd_3 INT,
    crm_cd_4 INT,
    location TEXT,
    cross_street TEXT,
    lat TEXT,
    lon TEXT
);

--- Import the csv data into the first table ---
COPY la_crime_data.crime_data_2010_2019
FROM 'C:/Carpeta personal/Resume/Projects/LA-Crime/dataset/Crime_Data_from_2010_to_2019_20250110.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');

--- Second table to store the crime data (Crime_Data_from_2020_to_Present_20250110 csv data)---
create table la_crime_data.crime_data_2020_present(
    dr_no BIGINT,
    date_rptd TEXT,
    date_occ TEXT,
    time_occ TEXT,
    area INT,
    area_name TEXT,
    rpt_dist_No INT,
    part_1_2 INT,
    crm_cd INT,
    crm_cd_desc TEXT,
    mocodes TEXT,
    vict_age INT,
    vict_sex TEXT,
    vict_descent TEXT,
    premis_cd TEXT,
    premis_desc TEXT,
    weapon_used_cd TEXT,
    weapon_desc TEXT,
    status TEXT,
    status_desc TEXT,
    crm_cd_1 INT,
    crm_cd_2 INT,
    crm_cd_3 INT,
    crm_cd_4 INT,
    location TEXT,
    cross_street TEXT,
    lat TEXT,
    lon TEXT
);

--- Import the csv data into the second table ---
COPY la_crime_data.crime_data_2020_present
FROM 'C:/Carpeta personal/Resume/Projects/LA-Crime/dataset/Crime_Data_from_2020_to_Present_20250110.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');