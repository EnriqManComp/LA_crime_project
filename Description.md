# LA Crime Analysis

## First step: Create the Schema and the Dataset (import_data.sql file)

We have the original data in csv format. So, first we convert the two csv files in a sql database.

We run the following command in the csv file directory (on Windows). This command provide the name of each field.

```
    Get-Content Crime_Data_from_2010_to_2019_20250110.csv -TotalCount 1
```
Now we are able to create the schema and the database

### Create the schema

We create a different schema for divide the data from public schema.

### Create the dataset

Then, we create the dataset named "crime_data" and copy the name of the field get with the previous command. Additionally, we fix the name of the fields to a proper sql format.

The data type of each field are setted to TEXT type. In future steps we will fix this.

### Second csv dataset (Crime_Data_from_2020_to_Present_20250110)

Same as before we execute the next command to check if the two csv files have the same fields

```
    Get-Content Crime_Data_from_2020_to_Present_20250110.csv -TotalCount 1
```

## Second step: Data Cleaning (data_cleaning.sql file)

### Duplicate Records

There are 346180 duplicated records in the data provided since 2010 to 2019. Therefore, we procede to remove these records.

### Null Values

There are 6 fields with high percentage of null values. One of these fields is "weapon used code", we assume that null values here is a crime with unknow weapon or a crime commited without a weapon. So, we asign a code for these cases.

The remain fields: "weapon used description", "crime code 2", "crime code 3", "crime code 4", and "cross street" are not strictly relevant to a posterior analysis. This conclusion is due there are other related fields that have similar information or have a higher importance hierarchy.

Also, due to the arguments before is not needed any causal analysis in the highest percentage null value fields.

### Remove Unnecessary Fields










