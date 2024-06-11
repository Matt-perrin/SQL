/* Stated below is my beginner analysis of the Google Coursera Cyclistic bike share data set for the year 2023, this is meant as a practice set
to learn SQL by developing advanced skills and promote active learning. By reading these statements I assume you arrived here from my application
and I wish to express my thanks for your time and consideration. */


-----------------------------------------------------------------------------------------------------------------------------------------------------
/* To start our analysis, we begin by joining the respective months to our total table for the year 2023, all analysis will have the goal 
to understand our market base use cases and how to better advertise our unique features. */

CREATE TABLE google_cyclistic_bike_share_year_2023 AS
SELECT * 
FROM( 
	SELECT * FROM january_2023
	UNION 
	SELECT * FROM febuary_2023
	UNION 
	SELECT * FROM march_2023
	UNION 
	SELECT * FROM april_2023
	UNION 
	SELECT * FROM may_2023
	UNION 
	SELECT * FROM june_2023
	UNION 
	SELECT * FROM july_2023
	UNION 
	SELECT * FROM august_2023
	UNION 
	SELECT * FROM september_2023
	UNION 
	SELECT * FROM october_2023
	UNION  
	SELECT * FROM november_2023
	UNION 
	SELECT * FROM december_2023
	);

/* First, we begin by checking that all data from the respective tables were joined properly. Utilizing a UNION command
we ensure that all rows from the related databases are integrated. Utilizing UNION vs UNION ALL will exclude any duplicate data, however 
utilizing count, we can verify the presence of duplication in order to inform our team. */

SELECT SUM(year_2023_review)
	FROM(
	(SELECT COUNT (*) AS year_2023_review FROM january_2023)
		UNION 
	(SELECT COUNT (*) FROM febuary_2023)
		UNION 
	(SELECT COUNT (*) FROM march_2023)
		UNION 
	(SELECT COUNT (*) FROM april_2023)
		UNION 
	(SELECT COUNT (*) FROM may_2023)
		UNION 
	(SELECT COUNT (*) FROM june_2023)
		UNION 
	(SELECT COUNT (*) FROM july_2023)
		UNION 
	(SELECT COUNT (*) FROM august_2023)
		UNION 
	(SELECT COUNT (*) FROM september_2023)
		UNION 
	(SELECT COUNT (*) FROM october_2023)
		UNION 
	(SELECT COUNT (*) FROM november_2023)
		UNION 
	(SELECT COUNT(*) FROM december_2023)
		);

/* Running a count command, we can see our new table total is 6651751, however running a DISTINCT command we can see 
the initial number decrease to 5719877 due to duplicates within our joined data. */

SELECT *
FROM google_cyclistic_bike_share_year_2023;

/* Querying the data we find out ride_id column consists of 16 alphanumeric identification numbers 
this is consistent with our instructions meaning these columns is error free. Analysis will move into
proper NULL clearing and data correction procedures outlined in the team docket. */

SELECT avg(LENGTH(ride_id))
FROM google_cyclistic_bike_share_year_2023;

ALTER TABLE google_cyclistic_bike_share_year_2023
ADD PRIMARY KEY (ride_id);

/* Finding nulls not including our start and end stations as null values in these are electric bike not present on an established bike lock, 
will update null values to be "On bike lock" 6990 nulls are present in the end_lat and end_lng columns, as requested in the doc.it we will be removing these nulls values. */ 

SELECT
	SUM(CASE WHEN ride_id ISNULL THEN 1 ELSE 0 END) ride_id,
	SUM(CASE WHEN rideable_type ISNULL THEN 1 ELSE 0 END) rideable_type,
	SUM(CASE WHEN started_at ISNULL THEN 1 ELSE 0 END) started_at,
	SUM(CASE WHEN ended_at ISNULL THEN 1 ELSE 0 END) ended_at,
	SUM(CASE WHEN start_station_name ISNULL THEN 1 ELSE 0 END) start_station_name,
	SUM(CASE WHEN start_station_id ISNULL THEN 1 ELSE 0 END) start_station_id,
	SUM(CASE WHEN end_station_name ISNULL THEN 1 ELSE 0 END) end_station_name,
	SUM(CASE WHEN end_station_id ISNULL THEN 1 ELSE 0 END) end_station_id,
	SUM(CASE WHEN start_lat ISNULL THEN 1 ELSE 0 END) start_lat,
	SUM(CASE WHEN start_lng ISNULL THEN 1 ELSE 0 END) start_lng,
	SUM(CASE WHEN end_lat ISNULL THEN 1 ELSE 0 END) end_lat,
	SUM(CASE WHEN end_lng ISNULL THEN 1 ELSE 0 END) end_lng,
	SUM(CASE WHEN member_casual ISNULL THEN 1 ELSE 0 END) member_casual
FROM google_cyclistic_bike_share_year_2023;

/*  NOTE the loss of end_lat or end_lng data is contained to our classic bikes with some being in the outdated name of docked_bike
, this information should be passed to the coding team as a bug report. */

SELECT *
FROM google_cyclistic_bike_share_year_2023
WHERE rideable_type='classic_bike' AND (end_lat ISNULL OR end_lng ISNULL);

SELECT *
FROM google_cyclistic_bike_share_year_2023
WHERE rideable_type='docked_bike' AND (end_lat ISNULL OR end_lng ISNULL);

DELETE FROM google_cyclistic_bike_share_year_2023
WHERE end_lat ISNULL OR end_lng ISNULL;

SELECT *
FROM google_cyclistic_bike_share_year_2023
WHERE rideable_type='classic_bike' AND (start_station_name ISNULL OR end_station_name ISNULL);

/* As stated within the docket the outdated term of "docked_bike" is still present within
the year_2023 data set, as such the team has requested that all instances of "docked_bike"
should be replaced with the "classic_bike" tag. */

SELECT *
FROM google_cyclistic_bike_share_year_2023
WHERE rideable_type='docked_bike';

UPDATE google_cyclistic_bike_share_year_2023
SET rideable_type = REPLACE(rideable_type, 'docked_bike', 'classic_bike');

SELECT *
FROM google_cyclistic_bike_share_year_2023
WHERE rideable_type='docked_bike';

/* Furthermore the "electric_bike" tag is a locked bike that does not require the bike
to be stored in a Cyclistic bike-share docking station, as such all instances of a 
"electric_bike" station name being null should be replaced with "On Bike Lock". */

SELECT *
FROM google_cyclistic_bike_share_year_2023
WHERE rideable_type='electric_bike' AND (start_station_name ISNULL OR end_station_name ISNULL);

UPDATE google_cyclistic_bike_share_year_2023
SET 
	start_station_name = coalesce(start_station_name, 'On Bike Lock'),
	start_station_id = coalesce(start_station_id, 'On Bike Lock'),
	end_station_name = coalesce(end_station_name, 'On Bike Lock'),
	end_station_id = coalesce(end_station_id, 'On Bike Lock');

SELECT *
FROM google_cyclistic_bike_share_year_2023;

/* As stated in the docket by the team some maintenance rides or missed named station
may have entered the data, we are tasked with identify these mistakes and removing them, or fixing
the name inconsistent errors. */

UPDATE google_cyclistic_bike_share_year_2023
set 
	start_station_name = TRIM('*' from start_station_name),
	end_station_name = TRIM('*' from end_station_name);

SELECT DISTINCT start_station_name
FROM google_cyclistic_bike_share_year_2023
WHERE start_station_name ilike '%/%'
	OR start_station_name ilike '%base%'
	OR start_station_name ilike '%temp%';

DELETE FROM google_cyclistic_bike_share_year_2023
WHERE start_station_name ilike '%TEMP%'
		OR start_station_name ilike '%base%';

UPDATE google_cyclistic_bike_share_year_2023
SET start_station_name = REPLACE(start_station_name, '/',' & ' );
	
SELECT DISTINCT end_station_name
FROM google_cyclistic_bike_share_year_2023
WHERE end_station_name ilike '%/%'
	OR end_station_name ilike '%base%'
	OR end_station_name ilike '%temp%';

DELETE FROM google_cyclistic_bike_share_year_2023
WHERE end_station_name ilike '%TEMP%'
	OR end_station_name ilike '%base%';

UPDATE google_cyclistic_bike_share_year_2023
SET end_station_name = REPLACE(end_station_name, '/',' & ' );

/* NOTE naming incessantly errors should be brought before the coding team to test for either bug
or the possibility of untracked data that could be deleted under company filters. */
/* As stated in the docket, all rides consisting of a time longer than 1 day or shorter than 1 minute are to be disregarded,
as such we establish a new column consisting of the total ride time length allowing future analysis of overall ride average duration
for both members and casual enjoyers. */

ALTER TABLE google_cyclistic_bike_share_year_2023
ADD ride_time interval;

UPDATE google_cyclistic_bike_share_year_2023
SET ride_time = (ended_at::TIMESTAMP - started_at::TIMESTAMP);

SELECT ride_time
FROM google_cyclistic_bike_share_year_2023
WHERE ride_time <= '00:01:00'::interval
ORDER BY ride_time DESC;

SELECT ride_time
FROM google_cyclistic_bike_share_year_2023
WHERE ride_time >= '24:00:00'::interval
ORDER BY ride_time ASC;

DELETE 
FROM google_cyclistic_bike_share_year_2023
WHERE ride_time >= '24:00:00'::interval OR ride_time <= '00:01:00'::interval;

/* Next, we will begin trimming our lat and lng columns to a uniform 5 decimal point length, 5 points was chosen
for shortened reading ability and ensure a 1 meter accuracy to the given location. While doing so we will extract 
the day, month, hour, and minute from our timestamp columns for further analysis, including but not limited to rides per day
average ride length, and total ride per month between causals and members. */

ALTER TABLE google_cyclistic_bike_share_year_2023
	ADD start_lat_trimmed numeric,
	ADD	start_lng_trimmed numeric,
	ADD end_lat_trimmed numeric,
	ADD end_lng_trimmed numeric,
	ADD start_day_of_week text,
	ADD start_month_of_year text,
	ADD start_day_of_month text,
	ADD start_year_2023 int,
	ADD end_day_of_week text,
	ADD end_month_of_year text,
	ADD end_day_of_month text,
	ADD end_year_2023 int,
	ADD started_at_alt text,
	ADD ended_at_alt text;

UPDATE google_cyclistic_bike_share_year_2023 
	SET
		start_lat_trimmed = ROUND(CAST(start_lat AS numeric),5),
		start_lng_trimmed = ROUND(CAST(start_lng AS numeric),5),
		end_lat_trimmed = ROUND(CAST(end_lat AS numeric),5),
		end_lng_trimmed = ROUND(CAST(end_lng AS numeric),5),
		start_day_of_week = CASE 
					  	WHEN EXTRACT(isodow FROM started_at) = 1 THEN 'Sun'
        			  	WHEN EXTRACT(isodow FROM started_at) = 2 THEN 'Mon'
        			  	WHEN EXTRACT(isodow FROM started_at) = 3 THEN 'Tues'
       				  	WHEN EXTRACT(isodow FROM started_at) = 4 THEN 'Wed'
        			  	WHEN EXTRACT(isodow FROM started_at) = 5 THEN 'Thur'
       				  	WHEN EXTRACT(isodow FROM started_at) = 6 THEN 'Fri'
        			  	ELSE'Sat'
					  	END,
		start_month_of_year = CASE
         				WHEN EXTRACT(MONTH FROM started_at) = 1 THEN 'Jan'
         				WHEN EXTRACT(MONTH FROM started_at) = 2 THEN 'Feb'
         				WHEN EXTRACT(MONTH FROM started_at) = 3 THEN 'Mar'
         				WHEN EXTRACT(MONTH FROM started_at) = 4 THEN 'Apr'
         				WHEN EXTRACT(MONTH FROM started_at) = 5 THEN 'May'
        	 			WHEN EXTRACT(MONTH FROM started_at) = 6 THEN 'Jun'
         				WHEN EXTRACT(MONTH FROM started_at) = 7 THEN 'July'
         				WHEN EXTRACT(MONTH FROM started_at) = 8 THEN 'Aug'
         				WHEN EXTRACT(MONTH FROM started_at) = 9 THEN 'Sept'
         				WHEN EXTRACT(MONTH FROM started_at) = 10 THEN 'Oct'
         				WHEN EXTRACT(MONTH FROM started_at) = 11 THEN 'Nov'
         				ELSE 'Dec'
    					END,
		start_day_of_month = EXTRACT(DAY FROM started_at),
		start_year_2023 = EXTRACT(YEAR FROM started_at),
		end_day_of_week = CASE 
					  	WHEN EXTRACT(isodow FROM ended_at) = 1 THEN 'Sun'
        			  	WHEN EXTRACT(isodow FROM ended_at) = 2 THEN 'Mon'
        			  	WHEN EXTRACT(isodow FROM ended_at) = 3 THEN 'Tues'
       				  	WHEN EXTRACT(isodow FROM ended_at) = 4 THEN 'Wed'
        			  	WHEN EXTRACT(isodow FROM ended_at) = 5 THEN 'Thur'
       				  	WHEN EXTRACT(isodow FROM ended_at) = 6 THEN 'Fri'
        			  	ELSE'Sat'
					  	END,
		end_month_of_year = CASE
         				WHEN EXTRACT(MONTH FROM ended_at) = 1 THEN 'Jan'
         				WHEN EXTRACT(MONTH FROM ended_at) = 2 THEN 'Feb'
         				WHEN EXTRACT(MONTH FROM ended_at) = 3 THEN 'Mar'
         				WHEN EXTRACT(MONTH FROM ended_at) = 4 THEN 'Apr'
         				WHEN EXTRACT(MONTH FROM ended_at) = 5 THEN 'May'
        	 			WHEN EXTRACT(MONTH FROM ended_at) = 6 THEN 'Jun'
         				WHEN EXTRACT(MONTH FROM ended_at) = 7 THEN 'July'
         				WHEN EXTRACT(MONTH FROM ended_at) = 8 THEN 'Aug'
         				WHEN EXTRACT(MONTH FROM ended_at) = 9 THEN 'Sept'
         				WHEN EXTRACT(MONTH FROM ended_at) = 10 THEN 'Oct'
         				WHEN EXTRACT(MONTH FROM ended_at) = 11 THEN 'Nov'
         				ELSE 'Dec'
    					END,
		end_day_of_month = EXTRACT(DAY FROM ended_at),
		end_year_2023 = EXTRACT(YEAR FROM ended_at);

/* We verify proper extraction and formatting before joining the date information back into a proper column with
the date written out in a typical calendar format. We will keep the day and month separate columns for ease of analysis,
however, views will be created to examine data in a proper table format. */

SELECT *
FROM google_cyclistic_bike_share_year_2023;

UPDATE google_cyclistic_bike_share_year_2023
	SET started_at_alt = CONCAT(start_day_of_week, ' ', start_month_of_year, ' ', start_day_of_month, ' ',start_year_2023),
		ended_at_alt = CONCAT(end_day_of_week, ' ', end_month_of_year, ' ', end_day_of_month, ' ',end_year_2023);

/* Dropping the non-uniform lng and lat columns. */

ALTER TABLE google_cyclistic_bike_share_year_2023
DROP COLUMN start_lat,
	 DROP COLUMN start_lng,
	 DROP COLUMN end_lat,
	 DROP COLUMN end_lng;
	
/* We rename the alternative lng and lat columns back to the original format following a uniform process. */	 

ALTER TABLE google_cyclistic_bike_share_year_2023
RENAME COLUMN start_lat_trimmed TO start_lat;
ALTER TABLE google_cyclistic_bike_share_year_2023
RENAME COLUMN start_lng_trimmed TO start_lng;
ALTER TABLE google_cyclistic_bike_share_year_2023
RENAME COLUMN end_lat_trimmed TO end_lat;
ALTER TABLE google_cyclistic_bike_share_year_2023
RENAME COLUMN end_lng_trimmed TO end_lng;

/* Following all cleaning and organization procedures we perform a final overview of all columns and data
to ensure proper format and plan the analysis portion of our review. */
SELECT *
FROM google_cyclistic_bike_share_year_2023;