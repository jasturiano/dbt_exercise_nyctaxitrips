# Exploring dbt features using a public dataset about New York Taxi Data

This exercise explores dbt as part of a ETL, specially in the Transformation Layer.

We believe that dbt is the right tool for your data transformations if:

1. Your analytics warehouse runs on separate hardware from the database used by your product;
2. A copy of your source data is already loaded into your analytics warehouse;
3. Your data transformation logic can be expressed in SQL;
3. Your data can be transformed in batch; and
4. You write idempotent data transformations.

Please refer to this [doc](https://blog.getdbt.com/is-dbt-the-right-tool-for-my-data-transformations/) for further information about use cases.


**The use Case**

Create a data pipeline that collects information about the most popular destinations of taxi customers for a given pick-up point. We want to be able to query&explore this data over time afterwards using SQL. The New York City Taxi & Limousine Commission (NYC TLC) provides a [public data set](https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page)

A dbt profile was created with its models in order to get the information from seeds and then apply transformation using MySQL as target database.

*Note: As part of this exercise, it was realized that dbt is not good for load huge amount of data, always is recommended that you already have data in S3, GCS or a DWH prior start the transformations* 
