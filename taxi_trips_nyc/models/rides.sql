WITH rides AS (
	SELECT
		date_format(tripdata.tpep_pickup_datetime, '%Y-%m') as month,
		lookup.Borough as pkup,
		lookup2.Borough as dropoff,
		count(tripdata.PULocationID) total_rides
	FROM nyc_taxi_trips.yellow_tripdata_2021_3mths tripdata
	LEFT JOIN nyc_taxi_trips.taxi_zone_lookup lookup
	ON lookup.LocationID = tripdata.PULocationID
	LEFT JOIN nyc_taxi_trips.taxi_zone_lookup lookup2
	ON lookup2.LocationID = tripdata.DOLocationID
	GROUP BY date_format(tripdata.tpep_pickup_datetime, '%Y-%m'), lookup.Borough, lookup2.Borough
),
get_rank AS (
	SELECT *,
  		rank() over (PARTITION BY pkup ORDER BY total_rides DESC) AS ranking
	FROM rides
)
SELECT * FROM get_rank