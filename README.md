# LA Crime Analysis

## First step: Create the Schema and the Dataset

We have the original data in csv format. So, first we convert the two csv files in a sql database.

We run the following command in the csv file directory (on Windows). This command provide the name of each field.

```
    Get-Content Crime_Data_from_2010_to_2019_20250110.csv -TotalCount 1
```
Now we are able to create the schema and the database

### Create the schema


