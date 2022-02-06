WITH passengers_info AS (
SELECT
	date_format(tripdata.tpep_pickup_datetime, '%Y-%m') as month,
	lookup.zone as pkup_zone,
	lookup2.zone as dropoff_zone,
	sum(tripdata.passenger_count) as total_passengers
FROM nyc_taxi_trips.yellow_tripdata_2019_01 tripdata
LEFT JOIN nyc_taxi_trips.taxi_zone_lookup lookup
ON lookup.LocationID = tripdata.PULocationID
LEFT JOIN nyc_taxi_trips.taxi_zone_lookup lookup2
ON lookup2.LocationID = tripdata.DOLocationID
GROUP BY date_format(tripdata.tpep_pickup_datetime, '%Y-%m'), lookup.zone, lookup2.zone
),
get_rank AS (
	SELECT *,
  		rank() over (PARTITION BY pkup_zone ORDER BY total_passengers DESC) AS ranking
FROM passengers_info
)
SELECT * FROM get_rank WHERE ranking <= 5