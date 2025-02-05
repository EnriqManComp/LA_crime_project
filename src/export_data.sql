COPY la_crime_data.crime_data_2010_2019 
TO 'C:/Carpeta personal/Resume/Projects/LA_crime_project/data/Crime_Data_from_2010_to_2019.csv' 
WITH (FORMAT csv, HEADER true, DELIMITER ',');

COPY la_crime_data.mocodes_data 
TO 'C:/Carpeta personal/Resume/Projects/LA_crime_project/data/Mocodes_Data.csv' 
WITH (FORMAT csv, HEADER true, DELIMITER ',');

