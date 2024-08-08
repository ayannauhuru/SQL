# US Household Income (Exploratory Data Analysis) ------
   
   # Looking at the area of the land and Water, joining the household income tables,
   # finding some 'dirty data' with 0s in the `Mean` column,
   # looking at the average mean and median household incomes on the state level, and
   # looking at the `Type` column, looking at which cities had the highest average incomes
   
SELECT * 
FROM us_household_income
;

SELECT *
FROM us_household_income_statistics
;

# Order states by Area of Land (ALand) ------

SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_household_income
GROUP BY State_Name
ORDER BY 2 DESC
;

# Order states by Area of Water (AWater) ------

SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_household_income
GROUP BY State_Name
ORDER BY 3 DESC
;

# Find top 10 largest states by land ------

SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_household_income
GROUP BY State_Name
ORDER BY 2 DESC
LIMIT 10
;

# Find top 10 largest states by water ------

SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_household_income
GROUP BY State_Name
ORDER BY 3 DESC
LIMIT 10
;

# Filtering out 0s in the data ------

SELECT * 
FROM us_household_income u
INNER JOIN us_household_income_statistics us
ON u.id = us.id
WHERE Mean <> 0
;

# Looking at Mean & Median Income ------

SELECT u.State_Name, County, Type, `Primary`, Mean, Median
FROM us_household_income u
INNER JOIN us_household_income_statistics us
ON u.id = us.id
WHERE Mean <> 0
;

# Looking at Mean & Median Income on the state level for the lowest 10 states (ordered by lowest avg income) ------ 

SELECT u.State_Name, ROUND(AVG(Mean), 1), ROUND(AVG(Median), 1)
FROM us_household_income u
INNER JOIN us_household_income_statistics us
ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 2
LIMIT 10
;

# Looking at Mean & Median Income on the state level for the highest 10 states (ordered by highest avg income)  ------ 

SELECT u.State_Name, ROUND(AVG(Mean), 1), ROUND(AVG(Median), 1)
FROM us_household_income u
INNER JOIN us_household_income_statistics us
ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 2 DESC
LIMIT 10 
;

# Looking at Mean & Median Income on the state level for the highest 10 states (ordered by the highest median incomes) ------ 

SELECT u.State_Name, ROUND(AVG(Mean), 1), ROUND(AVG(Median), 1)
FROM us_household_income u
INNER JOIN us_household_income_statistics us
ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 3 DESC
LIMIT 10 
;

# Looking at Mean & Median Income on the state level for the lowest 10 states (ordered by the lowest median incomes) ------ 

SELECT u.State_Name, ROUND(AVG(Mean), 1), ROUND(AVG(Median), 1)
FROM us_household_income u
INNER JOIN us_household_income_statistics us
ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 3 ASC
LIMIT 10 
;

# Looking at Mean & Median Income by `Type` (ordered on avg mean) ------ 

SELECT Type, COUNT(Type), ROUND(AVG(Mean), 1), ROUND(AVG(Median), 1)
FROM us_household_income u
INNER JOIN us_household_income_statistics us
ON u.id = us.id
WHERE Mean <> 0
GROUP BY 1
ORDER BY 3 DESC
LIMIT 20
;

# Looking at Mean & Median Income by `Type` (ordered on avg median, filtering out Types with low counts (outliers)) ------ 

SELECT Type, COUNT(Type), ROUND(AVG(Mean), 1), ROUND(AVG(Median), 1)
FROM us_household_income u
INNER JOIN us_household_income_statistics us
ON u.id = us.id
WHERE Mean <> 0
GROUP BY 1
HAVING COUNT(Type) > 100
ORDER BY 4 DESC
LIMIT 20
;

SELECT *
FROM us_household_income
WHERE Type = 'Community'
;

# Looking at highest avg mean and avg median household income on the City level ------ 

SELECT u.State_Name, City, ROUND(AVG(Mean), 1), ROUND(AVG(Median), 1)
FROM us_household_income u
INNER JOIN us_household_income_statistics us
ON u.id = us.id
GROUP BY u.State_Name, City
ORDER BY ROUND(AVG(Mean), 1) DESC
;

