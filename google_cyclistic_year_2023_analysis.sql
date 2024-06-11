/* Analysis will begin by finding the amount of ride per month using the CTE format. 
CTE is used here as a practice method and is genearly not necessary for this type of analysis. */

WITH year_2023_selection AS (
	SELECT 
		started_at_alt,
		member_casual,
	EXTRACT(MONTH FROM started_at) AS testing_month
	FROM google_cyclistic_bike_share_year_2023
),
members_longest_ride_time AS (
	SELECT 
	member_casual,
	COUNT(testing_month) AS month
	FROM year_2023_selection
	GROUP BY member_casual, testing_month
	ORDER BY member_casual, testing_month
)
SELECT *
FROM members_longest_ride_time;

/* Analysis of the average ride time for casuals and members. */

WITH year_2023_selection AS (
	SELECT 
	member_casual,
	EXTRACT(MINUTE FROM started_at) AS minutes
	FROM google_cyclistic_bike_share_year_2023
),
members_longest_ride_time AS (
	SELECT 
	member_casual,
	AVG(minutes) AS avg_minutes
	FROM year_2023_selection
	GROUP BY member_casual
)
SELECT *
FROM members_longest_ride_time;

/* Figuring the amount of rides per a givin day of the week */

SELECT member_casual, start_day_of_week, COUNT(*) AS daily_rides
FROM google_cyclistic_bike_share_year_2023
GROUP BY member_casual, start_day_of_week;

/* Total rides between members and casuals givin a specific bike type */

SELECT rideable_type, member_casual, COUNT(*)AS ride_amount
FROM google_cyclistic_bike_share_year_2023
GROUP BY rideable_type, member_casual
ORDER BY member_casual, rideable_type;

/* Calculating the most common trip among members */

SELECT start_station_name, end_station_name, COUNT(*) AS name
FROM google_cyclistic_bike_share_year_2023
WHERE member_casual ='member' AND start_station_name <> 'On Bike Lock'
GROUP BY start_station_name, end_station_name
ORDER BY name DESC;
	
/* Calculating the most common trip among casuals */
	
SELECT start_station_name, end_station_name, COUNT(*) AS name
FROM google_cyclistic_bike_share_year_2023
WHERE member_casual ='casual' AND start_station_name <> 'On Bike Lock'
GROUP BY start_station_name, end_station_name
ORDER BY name DESC;

/* Figuring the longest rides among members */

SELECT ride_time, start_station_name, end_station_name, COUNT(*) AS longest_member_ride
FROM google_cyclistic_bike_share_year_2023
WHERE member_casual='member' AND start_station_name <> 'On Bike Lock'
GROUP BY ride_time, start_station_name, end_station_name
ORDER BY longest_member_ride DESC;

/* Figuring the longest ride among casuals*/

SELECT ride_time, start_station_name, end_station_name, COUNT(*) AS longest_member_ride
FROM google_cyclistic_bike_share_year_2023
WHERE member_casual='casual' AND start_station_name <> 'On Bike Lock'
GROUP BY ride_time, start_station_name, end_station_name
ORDER BY longest_member_ride DESC;

/* Creating views of our member and casuals demographics, these views will be used to highlight
the difference between ride habits and analysis the best methods to maximize value. */

CREATE VIEW members_2023_view AS
SELECT ride_id,
		rideable_type,
		start_station_name,
		end_station_name,
		started_at_alt,
		ended_at_alt,
		start_lat,
		end_lat,
		start_lng,
		end_lng,
		ride_time,
		member_casual
FROM google_cyclistic_bike_share_year_2023
WHERE member_casual='member';

CREATE VIEW casuals_2023_view AS
SELECT ride_id,
		rideable_type,
		start_station_name,
		end_station_name,
		started_at_alt,
		ended_at_alt,
		start_lat,
		end_lat,
		start_lng,
		end_lng,
		ride_time,
		member_casual
FROM google_cyclistic_bike_share_year_2023
WHERE member_casual='casuals';	 

/* Tables are created with the intent purpose to practice joins and provide further analyzation
of the provided data. Created tables are ment to provide an example joins givin if the data was 
split along lines of member or casual, and classic or electric bikes. */		

CREATE TABLE members_2023 AS
SELECT ride_id,
		rideable_type,
		start_station_name,
		end_station_name,
		started_at_alt,
		ended_at_alt,
		start_lat,
		end_lat,
		start_lng,
		end_lng,
		ride_time,
		member_casual
FROM google_cyclistic_bike_share_year_2023
WHERE member_casual = 'member';

CREATE TABLE casuals_2023 AS
SELECT ride_id,
		rideable_type,
		start_station_name,
		end_station_name,
		started_at_alt,
		ended_at_alt,
		start_lat,
		end_lat,
		start_lng,
		end_lng,
		ride_time,
		member_casual
FROM google_cyclistic_bike_share_year_2023
WHERE member_casual = 'casual';

CREATE TABLE electric_bikes_2023 AS
SELECT ride_id,
		rideable_type,
		start_station_name,
		end_station_name,
		started_at_alt,
		ended_at_alt,
		start_lat,
		end_lat,
		start_lng,
		end_lng,
		ride_time
FROM google_cyclistic_bike_share_year_2023
WHERE rideable_type = 'electric';

CREATE TABLE classic_bikes_2023 AS
SELECT ride_id,
		rideable_type,
		start_station_name,
		end_station_name,
		started_at_alt,
		ended_at_alt,
		start_lat,
		end_lat,
		start_lng,
		end_lng,
		ride_time
FROM google_cyclistic_bike_share_year_2023
WHERE rideable_type = 'classic';

/* Data along the rideable_type column is inserted into the talbes */

INSERT INTO electric_bikes_2023 (
ride_id,
rideable_type,
start_station_name,
end_station_name,
started_at_alt,
ended_at_alt,
start_lat,
end_lat,
start_lng,
end_lng,
ride_time)
SELECT 
ride_id,
rideable_type,
start_station_name,
end_station_name,
started_at_alt,
ended_at_alt,
start_lat,
end_lat,
start_lng,
end_lng,
ride_time
FROM google_cyclistic_bike_share_year_2023
WHERE google_cyclistic_bike_share_year_2023.rideable_type='electric_bike';

INSERT INTO classic_bikes_2023 (
ride_id,
rideable_type,
start_station_name,
end_station_name,
started_at_alt,
ended_at_alt,
start_lat,
end_lat,
start_lng,
end_lng,
ride_time)
SELECT 
ride_id,
rideable_type,
start_station_name,
end_station_name,
started_at_alt,
ended_at_alt,
start_lat,
end_lat,
start_lng,
end_lng,
ride_time
FROM google_cyclistic_bike_share_year_2023
WHERE google_cyclistic_bike_share_year_2023.rideable_type='classic_bike';

/* Joining of the casuals and classic_bikes tables to find total number of classic casual riders */

SELECT casuals_2023.ride_id,
		casuals_2023.rideable_type,
		casuals_2023.start_station_name,
		casuals_2023.end_station_name,
		casuals_2023.started_at_alt,
		casuals_2023.ended_at_alt,
		casuals_2023.start_lat,
		casuals_2023.end_lat,
		casuals_2023.start_lng,
		casuals_2023.end_lng,
		casuals_2023.ride_time,
		casuals_2023.member_casual
     FROM casuals_2023
INNER JOIN classic_bikes_2023 ON classic_bikes_2023.ride_id = casuals_2023.ride_id 
    WHERE casuals_2023.member_casual='casual' AND classic_bikes_2023.rideable_type='classic_bike';

/* Joining of the casuals and classic_bikes tables to find total number of electric casual riders */

SELECT casuals_2023.ride_id,
		casuals_2023.rideable_type,
		casuals_2023.start_station_name,
		casuals_2023.end_station_name,
		casuals_2023.started_at_alt,
		casuals_2023.ended_at_alt,
		casuals_2023.start_lat,
		casuals_2023.end_lat,
		casuals_2023.start_lng,
		casuals_2023.end_lng,
		casuals_2023.ride_time,
		casuals_2023.member_casual
     FROM casuals_2023
INNER JOIN electric_bikes_2023 ON electric_bikes_2023.ride_id = casuals_2023.ride_id 
    WHERE casuals_2023.member_casual='casual' AND electric_bikes_2023.rideable_type='electric_bike';

/* Joining of the members and classic_bikes tables to find total number of classic member riders */

SELECT members_2023.ride_id,
		members_2023.rideable_type,
		members_2023.start_station_name,
		members_2023.end_station_name,
		members_2023.started_at_alt,
		members_2023.ended_at_alt,
		members_2023.start_lat,
		members_2023.end_lat,
		members_2023.start_lng,
		members_2023.end_lng,
		members_2023.ride_time,
		members_2023.member_casual
     FROM members_2023
INNER JOIN classic_bikes_2023 ON classic_bikes_2023.ride_id = members_2023.ride_id 
    WHERE members_2023.member_casual='member' AND classic_bikes_2023.rideable_type='classic_bike';

/* Joining of the members and electric_bikes tables to find total number of electric member riders */

SELECT members_2023.ride_id,
		members_2023.rideable_type,
		members_2023.start_station_name,
		members_2023.end_station_name,
		members_2023.started_at_alt,
		members_2023.ended_at_alt,
		members_2023.start_lat,
		members_2023.end_lat,
		members_2023.start_lng,
		members_2023.end_lng,
		members_2023.ride_time,
		members_2023.member_casual
     FROM members_2023
INNER JOIN electric_bikes_2023 ON electric_bikes_2023.ride_id = members_2023.ride_id 
    WHERE members_2023.member_casual='member' AND electric_bikes_2023.rideable_type='electric_bike';

/* Final notes. I would like to thank the reader for analyzing my process in cleaning the Google Cyclistic bike-share analysis case study!
Furthor thanks are given to Iain Elliott whose analysis provided a clear base line for the begining of my analysis. */