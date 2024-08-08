# US Household Income (Data Cleaning) ------

	# Finding and deleting duplicate data, looking for mispellings, and looking for and populating NULL/blank data (if needed)
    
SELECT * 
FROM us_household_income
;

SELECT *
FROM us_household_income_statistics
;

SELECT COUNT(id) 
FROM us_household_income
;

SELECT COUNT(id) 
FROM us_household_income_statistics
;

 # Finding duplicate data in the us_household_income table ------
 
SELECT id, COUNT(id)
FROM us_household_income
GROUP BY id
HAVING COUNT(id) > 1
;

SELECT *
FROM(
SELECT row_id,
id,
ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
FROM us_household_income
) duplicates
WHERE row_num > 1
;

# Deleting duplicate data ------

DELETE FROM us_household_income
WHERE row_id IN (
	SELECT row_id
	FROM(
		SELECT row_id,
		id,
		ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
		FROM us_household_income
		) duplicates
	WHERE row_num > 1
)
;

# Finding duplicate data in the us_household_income_statistics table (NONE FOUND) ------

SELECT id, COUNT(id)
FROM us_household_income_statistics
GROUP BY id
HAVING COUNT(id) > 1
;

# Finding mispellings in the `State_Name` column ------

SELECT DISTINCT(State_Name)
FROM us_household_income
GROUP BY State_Name
ORDER BY 1
;

UPDATE us_household_income
SET State_Name = 'Georgia'
WHERE State_Name = 'georia'
;

UPDATE us_household_income
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama'
;

# Finding NULL data in the `Place` column ------

SELECT *
FROM us_household_income
WHERE Place IS NULL
;

SELECT City, Place, County
FROM us_household_income
WHERE County = 'Autauga County'
;

# Populating NULL `Place` value with 'Autaugaville' ------

UPDATE us_household_income
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
AND City = 'Vinemont'
;

# Checking the `Type` column ------

SELECT Type, COUNT(Type)
FROM us_household_income
GROUP BY Type
;

# Updating 'Boroughs' in the `Type` column to 'Borough'  ------

UPDATE us_household_income
SET Type = 'Borough'
WHERE Type = 'Boroughs'
;

SELECT * 
FROM us_household_income
;

# Checking the `AWater` column ------

SELECT ALand, AWater
FROM us_household_income
WHERE (AWater = 0 OR AWater IS NULL OR AWater = '')
;

# Checking the `ALand` column ------

SELECT ALand
FROM us_household_income
WHERE (ALand = 0 OR ALand IS NULL OR ALand = '')
;




