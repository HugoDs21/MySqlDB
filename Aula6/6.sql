DELIMITER $

CREATE FUNCTION getChargeValue(stream_time DATETIME, movie_id INT, customer_id INT)
RETURNS DECIMAL(4,2)
BEGIN
DECLARE c DECIMAL(4,2);
DECLARE movie_duration INT(4);
DECLARE customer_country VARCHAR(255);
DECLARE customer_regionID INT(4);
DECLARE customer_region VARCHAR(255);

SELECT Duration INTO movie_duration	
FROM MOVIE WHERE MovieId = movie_id;	
SET c = 0.5+0.01*movie_duration;

SELECT Country INTO customer_country
FROM CUSTOMER WHERE CUSTOMER.CustomerId = customer_id;

SELECT RegionID INTO customer_regionID
FROM COUNTRY WHERE COUNTRY.Name = customer_country;

SELECT Name INTO customer_region
FROM REGION WHERE REGION.RegionID = customer_regionID;


IF customer_country = 'United States'
OR customer_region = 'Europe' THEN
SET c = c + 1;


IF HOUR(stream_time) >= 21 THEN
SET c = c + 0.75;
IF WEEKDAY(stream_time) >= 4 THEN	
SET c = c + 0.75;

END IF;
END IF;
END IF;

RETURN c;
END $



































CREATE FUNCTION getChargeValueTest(stream_time DATETIME, movie_id INT, customer_id INT)
RETURNS DECIMAL(4,2)
BEGIN
DECLARE c DECIMAL(4,2);
SET c = 0;
RETURN c;
END $


