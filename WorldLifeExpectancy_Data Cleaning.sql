# World Life Expectancy Project (Data Cleaning)

SELECT * 
FROM world_life_expectancy
;

# Identifying Duplicates

SELECT Country, Year, COUNT(CONCAT(Country, Year)) as Count
FROM world_life_expectancy
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1
;


# Creating new unique column

SELECT*
FROM (
	SELECT Row_ID,
	CONCAT(Country, Year), 
	ROW_NUMBER() OVER( PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, 	Year)) as row_num
	FROM world_life_expectancy
 ) AS Row_Table
WHERE row_num > 1
 ;
 
 # Deleting Duplicates
 
 DELETE FROM world_life_expectancy
WHERE
	ROW_ID IN (
		SELECT ROW_ID
    FROM (
	SELECT Row_ID,
	CONCAT(Country, Year), 
	ROW_NUMBER() OVER( PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, 	Year)) as row_num
	FROM world_life_expectancy
 ) AS Row_Table
WHERE row_num > 1
)
;



# Filling in blank values

SELECT DISTINCT(status)
FROM world_life_expectancy
WHERE Status <> ''
;

SELECT *
FROM world_life_expectancy
WHERE Status = ''
;

# If a countries status was Developing/Developed, the blank value would be replaced with the correspopnding status.


SELECT DISTINCT(Country)
FROM world_life_expectancy
WHERE Status = 'Developing'
;

UPDATE world_life_expectancy
SET Status = 'Developing'
WHERE Country IN (SELECT DISTINCT(Country)
FROM world_life_expectancy
WHERE Status = 'Developing');

UPDATE world_life_expectancy a
JOIN world_life_expectancy b
	ON a.Country = b.Country
SET a.Status = 'Developing'
WHERE a.Status = ''
AND b.Status <> ''
AND b.Status = 'Developing'
;


UPDATE world_life_expectancy a
JOIN world_life_expectancy b
	ON a.Country = b.Country
SET a.Status = 'Developed'
WHERE a.Status = ''
AND b.Status <> ''
AND b.Status = 'Developed'
;

SELECT *
FROM world_life_expectancy
WHERE Country = 'United States of America'
;


# Life expectancy

SELECT *
FROM world_life_expectancy
WHERE `life expectancy` = ''
;


SELECT a.Country, a.Year, a.`life expectancy`,
b.Country, b.Year, b.`life expectancy`,
c.Country, c.Year, c.`life expectancy`,
ROUND((b.`life expectancy` + c.`life expectancy`)/2,1) as '2018'
FROM world_life_expectancy a
JOIN world_life_expectancy b
	ON a.Country = b.Country
    AND a.Year = b.Year - 1
    JOIN world_life_expectancy c
	ON a.Country = c.Country
    AND a.Year = c.Year + 1
WHERE a.`life expectancy` = ''
;



UPDATE  world_life_expectancy a
JOIN world_life_expectancy b
	ON a.Country = b.Country
    AND a.Year = b.Year - 1
JOIN world_life_expectancy c
	ON a.Country = c.Country
    AND a.Year = c.Year + 1
SET a.`life expectancy` = ROUND((b.`life expectancy` + c.`life expectancy`)/2,1) 
WHERE a.`life expectancy`  = ''

;

