/* Presented below is my analysis of the SQL Murder Mystery. */
/* To begin, the docket states that the murder in question occurred on January 15, 2018, in SQL City.*/
/* We run the initial query in the crime scene report table to further our leads. */

SELECT *
FROM crime_scene_report
WHERE date = '20180115'
AND type ='murder'
AND city = 'SQL City';

												/* Annabel's Route */
---------------------------------------------------------------------------------------------------------------------------------------------------------------
/* According to the report, two witnesses reportedly saw the crime, a resident living on the corner of "Northwestern Drive" and an Annabel living somewhere on Franklin. */
/* We separate these two witness reports into their respective routes, beginning with Annabel's testimony. */

CREATE VIEW annabel_miller AS
SELECT person.*, interview.*, get_fit_now_member.*, get_fit_now_check_in.*
FROM person
JOIN interview ON person.id = interview.person_id
JOIN get_fit_now_member ON person.id = get_fit_now_member.person_id
JOIN get_fit_now_check_in ON get_fit_now_check_in.membership_id = get_fit_now_member.id
WHERE person.name LIKE '%Annabel%'
AND address_street_name = 'Franklin Ave';

/* Information gathered about Annabel Miller, Id number 16371, license Id number 490173, Address 103 Franklin Ave.  */
/* We find that Annabel's testimony includes her previously seeing the killer working out at the same time in the local gym. */
/* We query all relevant tables to find any individuals who match the time presented and possibly have a testimony. */

SELECT get_fit_now_check_in.*, get_fit_now_member.*, person.*, interview.*
FROM get_fit_now_check_in
JOIN get_fit_now_member ON get_fit_now_check_in.membership_id = get_fit_now_member.id
JOIN person ON get_fit_now_member.person_id = person.id
JOIN interview ON person.id = interview.person_id
WHERE (get_fit_now_check_in.check_in_time = '1600' OR get_fit_now_check_in.check_out_time = '1700')
AND NOT get_fit_now_check_in.membership_id = '90081';

/* We find that a Mr. Jeremy Bowers admits to committing the crime after being hired by an unknown woman. */
/* The suspect is listed as height between 5'5" (65) to 5'7" (67), red hair while driving a tesla model S and attended the SQL Symphony Concert
3 times in December 2017. */

SELECT person.*, drivers_license.*, facebook_event_checkin.*
FROM person
JOIN drivers_license ON drivers_license.id = person.license_id
JOIN facebook_event_checkin ON facebook_event_checkin.person_id = person.id
WHERE (drivers_license.height BETWEEN 65 AND 67)
AND drivers_license.gender = 'female'
AND drivers_license.hair_color ='red'
AND drivers_license.car_make = 'Tesla'
AND drivers_license.car_model = 'Model S'
LIMIT 3;

/* Running the provided query we find a sole match; Ms. Miranda Priestly id number 99716 is a perfect match for all criteria. */
/* With all available information from Annabel's testimony we've found that Mr. Jermey Bowers committed the crime after being hired by Ms. Miranda Priestly */
---------------------------------------------------------------------------------------------------------------------------------------------------------------


												/* "Northwestern" Route */
---------------------------------------------------------------------------------------------------------------------------------------------------------------
/* We begin by studying the present testimony that the individual who witnessed the crimes lives on the corner of Northwestern Drive */
/* Querying potential residents, we find that Morty Schapiro, id number 14887, and 	Kinsey Erickson, id number 89906, live at the respective end of Northwestern */

SELECT *
FROM person
WHERE address_street_name LIKE '%Northwestern%'
ORDER BY address_number DESC

/* Morty Schapiro states he heard a gunshot followed by a man running past carrying a "Get Fit Now Gym" bag starting with "48Z", handed out to gold members 
at the local gym. With the getaway car license plate containing "H42W". */
/* Considering the provided information we query the tables for person, get_fit_now_member, drivers_license, and interview */

SELECT person.*, drivers_license.*, get_fit_now_member.*, interview.*
FROM person
JOIN drivers_license ON person.license_id = drivers_license.id
JOIN get_fit_now_member ON person.id = get_fit_now_member.person_id
JOIN interview ON person.id = interview.person_id
WHERE get_fit_now_member.id LIKE '%48Z%'
AND drivers_license.plate_number LIKE '%H42W%';

/* We find that a Mr. Jeremy Bowers admits to committing the crime after being hired by an unknown woman. */
/* The suspect is listed as height between 5'5" (65) to 5'7" (67), red hair while driving a tesla model S and attended the SQL Symphony Concert
3 times in December 2017. */

SELECT person.*, drivers_license.*, facebook_event_checkin.*
FROM person
JOIN drivers_license ON drivers_license.id = person.license_id
JOIN facebook_event_checkin ON facebook_event_checkin.person_id = person.id
WHERE (drivers_license.height BETWEEN 65 AND 67)
AND drivers_license.gender = 'female'
AND drivers_license.hair_color ='red'
AND drivers_license.car_make = 'Tesla'
AND drivers_license.car_model = 'Model S'
LIMIT 3;

/* Running the provided query we find a sole match; Ms. Miranda Priestly id number 99716 is a perfect match to all criteria. */
/* With all available information from Morty's testimony we've found that Mr. Jermey Bowers committed the crime after being hired by Ms. Miranda Priestly */
---------------------------------------------------------------------------------------------------------------------------------------------------------------

/* After querying both witness paths we find the killer Jeremy Bowers was hired by Miranda Priestly, and checking our work we are proven correct on both accounts. */