# World Life Expectancy Project (Data Cleaning) ------
	# Completed as Part of the AnalystBuilder MySQL for Data Analytics Course

SELECT *
FROM world_life_expectancy
;

# using `Country` & `Year` to check for duplicate data

SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM world_life_expectancy
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1
;

# finding out the Row_IDs of the duplicate rows
SELECT *
FROM (
	SELECT Row_ID,
	CONCAT(Country, Year),
	ROW_NUMBER() OVER( PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_Num
	FROM world_life_expectancy
	) AS row_table
WHERE Row_Num > 1
;

# deleting selected Row_IDs in the table we created in the FROM statement where the Row_Num is > 1 (duplicates)

DELETE FROM world_life_expectancy
WHERE
	Row_ID IN (
    SELECT Row_ID
FROM (
	SELECT Row_ID,
	CONCAT(Country, Year),
	ROW_NUMBER() OVER( PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_Num
	FROM world_life_expectancy
	) AS row_table
WHERE Row_Num > 1
    )
;

# Finding blank data in the `Status` column

SELECT *
FROM world_life_expectancy
WHERE Status = ''
;

# what's the possible data for the `Status` column? (Developing & Developed)

SELECT DISTINCT(Status)
FROM world_life_expectancy
WHERE Status <> ''
;

SELECT DISTINCT(Country)
FROM world_life_expectancy
WHERE Status = 'Developing'
;

# updating table WLE to set the Status = 'Developing' where Country is in this list (to remove blanks) 
# CAN'T USE SUBQUERY - DOESN'T WORK

UPDATE world_life_expectancy
SET Status = 'Developing'
WHERE Country IN (
	SELECT DISTINCT(Country)
	FROM world_life_expectancy
	WHERE Status = 'Developing'
);

# using SELF JOIN, set Status = 'Developing', where t1 is blank and t2 is not blank, and t2.Status = 'Developing'
# ex: If Afghanistan = Afghanistan AND if Afghanistan is blank in t1 AND Afghanistan not blank in t2 and 'Developing', we set it to 'Developing' in t1

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developing'
;

SELECT *
FROM world_life_expectancy
WHERE Country = 'United States of America'
;
# same update for 'Developed' countries

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
ON t1.Country = t2.Country
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developed'
;

# checking for NULLs

SELECT *
FROM world_life_expectancy
WHERE Status IS NULL
;

# checking `Life expectancy`

SELECT Country, Year, `Life expectancy`
FROM world_life_expectancy
#WHERE `Life expectancy` = ''
;

# looking at the years before and after the blank `Life expectancy` and using their average to populate the blank column

SELECT t1.Country, t1.Year, t1.`Life expectancy`,
t2.Country, t2.Year, t2.`Life expectancy`,
t3.Country, t3.Year, t3.`Life expectancy`,
ROUND((t2.`Life expectancy` + t3.`Life expectancy`) / 2, 1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
WHERE t1.`Life expectancy` = ''
;

# the actual UPDATE statement

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
SET t1.`Life expectancy` = ROUND((t2.`Life expectancy` + t3.`Life expectancy`) / 2, 1)
WHERE t1.`Life expectancy` = ''
;

SELECT Country, Year, `Life expectancy`
FROM world_life_expectancy
#WHERE `Life expectancy` = ''
;


