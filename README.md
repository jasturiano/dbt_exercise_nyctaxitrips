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


**Installing and Configuring dbt**

```
 $ sudo pip install dbt-mysql #Each integration needs to be installed separately
 $ dbt --version
 $ dbt init nyc_taxi_trips --adapter  mysql #Create the profile
```

Once we have the profile created, we need to put the DB information in the ~/.dbt/profiles.yml according with the choosen DB engine

The structure of the SQL transformation are in the *models* folder with the *schema.yml* containing the DDLs 

To Run the pipeline:

```
 $ dbt seed --profile taxi_trips_nyc #Just in case we need to load data, you will need to place the csv files in the data folder
 $ dbt run --profile taxi_trips_nyc
 $ dbt docs generate --profile taxi_trips_ny #Creates documentation about this profile
 $ dbt docs serve --profile taxi_trips_nyc #Opens a web browser to check above document
```


--- Pictures from dbt

**DB Outcome**

Once dbt has finished to build the tables according to the models, we'll have something like this this in the DB

```
mysql> show tables;
+----------------------------+
| Tables_in_nyc_taxi_trips   |
+----------------------------+
| most_popular_dest          | 
| popular_dest               |
| popular_dest_2019          |
| rides                      |
| taxi_zone_lookup           | <-- Raw Data coming from the Public Dataset
| test                       |
| yellow_tripdata_2019_01    | <-- Raw Data coming from the Public Dataset
| yellow_tripdata_2021_3mths | <-- Raw Data coming from the Public Dataset (Consolidated)
 +----------------------------+
8 rows in set (0.00 sec)
```

Monthly popular destinations where Pick Up zone were Central Park:

```
mysql> SELECT *  FROM popular_dest WHERE pkup_zone = 'Central Park' ORDER BY ranking;
+---------+--------------+-----------------------+------------------+---------+
| month   | pkup_zone    | dropoff_zone          | total_passengers | ranking |
+---------+--------------+-----------------------+------------------+---------+
| 2021-03 | Central Park | Upper East Side North |             4095 |       1 |
| 2021-03 | Central Park | Upper East Side South |             3720 |       2 |
| 2021-01 | Central Park | Upper East Side North |             3305 |       3 |
| 2021-02 | Central Park | Upper East Side North |             3132 |       4 |
| 2021-03 | Central Park | Central Park          |             3068 |       5 |
+---------+--------------+-----------------------+------------------+---------+
```

Monthly popular destinations where Pick Up zone was Central Park in 2019 (The difference after COVID is huge):

```
mysql> SELECT *  FROM popular_dest_2019 WHERE pkup_zone = 'Central Park' ORDER BY ranking;
+---------+--------------+-----------------------+------------------+---------+
| month   | pkup_zone    | dropoff_zone          | total_passengers | ranking |
+---------+--------------+-----------------------+------------------+---------+
| 2019-01 | Central Park | Upper East Side North |            14349 |       1 |
| 2019-01 | Central Park | Midtown Center        |            12747 |       2 |
| 2019-01 | Central Park | Upper East Side South |            12436 |       3 |
| 2019-01 | Central Park | Lincoln Square East   |            12048 |       4 |
| 2019-01 | Central Park | Central Park          |            11427 |       5 |
+---------+--------------+-----------------------+------------------+---------+
5 rows in set (0.00 sec)
```

Popular rides where Pick up Zone was The Bronx (Historical):

```
mysql> select * from rides where pkup = 'Bronx' and ranking <=5;
+---------+-------+-----------+-------------+---------+
| month   | pkup  | dropoff   | total_rides | ranking |
+---------+-------+-----------+-------------+---------+
| 2021-01 | Bronx | Bronx     |        8570 |       1 |
| 2021-03 | Bronx | Bronx     |        8525 |       2 |
| 2021-02 | Bronx | Bronx     |        6785 |       3 |
| 2021-03 | Bronx | Manhattan |        5572 |       4 |
| 2021-01 | Bronx | Manhattan |        4322 |       5 |
+---------+-------+-----------+-------------+---------+
5 rows in set (0.00 sec)
```

Most popular destinations order by month where Pick Up zone was Queens:

```
mysql> select * from most_popular_dest where pkup = 'Queens' order by month, ranking;
+---------+--------+-----------+---------+
| month   | pkup   | dropoff   | ranking |
+---------+--------+-----------+---------+
| 2021-01 | Queens | Queens    |       3 |
| 2021-01 | Queens | Manhattan |       4 |
| 2021-01 | Queens | Brooklyn  |       8 |
| 2021-02 | Queens | Queens    |       5 |
| 2021-02 | Queens | Manhattan |       6 |
| 2021-02 | Queens | Brooklyn  |       9 |
| 2021-03 | Queens | Manhattan |       1 |
| 2021-03 | Queens | Queens    |       2 |
| 2021-03 | Queens | Brooklyn  |       7 |
| 2021-03 | Queens | Bronx     |      10 |
+---------+--------+-----------+---------+
10 rows in set (0.00 sec)
```




