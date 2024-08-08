# World Life Expectancy Project (Exploratory Data Analysis) ------

SELECT *
FROM world_life_expectancy
;

# 1. How much has the `Life expectancy` increased over 15 years?

SELECT Country, MIN(`Life expectancy`),
MAX(`Life expectancy`),
ROUND((MAX(`Life expectancy`) - MIN(`Life expectancy`)), 1) AS Life_Increase_15_Years
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(`Life expectancy`) <> 0
AND MAX(`Life expectancy`) <> 0
ORDER BY Life_Increase_15_Years DESC
;

SELECT Country, MIN(`Life expectancy`),
MAX(`Life expectancy`),
ROUND((MAX(`Life expectancy`) - MIN(`Life expectancy`)), 1) AS Life_Increase_15_Years
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(`Life expectancy`) <> 0
AND MAX(`Life expectancy`) <> 0
ORDER BY Life_Increase_15_Years ASC
;

# 2. What's the average Life expectancy for each year?

SELECT Year, ROUND(AVG(`Life expectancy`), 1)
FROM world_life_expectancy
WHERE `Life expectancy` <> 0
GROUP BY Year
ORDER BY Year
;

SELECT *
FROM world_life_expectancy
;

# 3. Correlation between `Life expectancy` and GDP (postive)

# picking out countries with 0s first

SELECT Country, ROUND(AVG(`Life expectancy`), 1) AS Life_Exp, ROUND(AVG(GDP), 1) AS GDP
FROM world_life_expectancy
GROUP BY Country
ORDER BY Life_Exp ASC
;

SELECT Country, ROUND(AVG(`Life expectancy`), 1) AS Avg_Life_Exp, ROUND(AVG(GDP), 1) AS Avg_GDP
FROM world_life_expectancy
GROUP BY Country
HAVING Avg_Life_Exp > 0
AND Avg_GDP > 0
ORDER BY Avg_GDP DESC
;

# 4. Using a CASE statment to categorize the data

SELECT Country, GDP
FROM world_life_expectancy
ORDER BY GDP
;

# 5. SUM: How many rows have a GDP >= 1500 (high) & GDP <= 1500 (low)
# 	AVG: `Life expectancy` of those high & low rows
# 	High Correlation

SELECT
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) High_GDP_Count,
AVG(CASE WHEN GDP >= 1500 THEN `Life expectancy` ELSE NULL END) High_GDP_Life_Expectancy,
SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) Low_GDP_Count,
AVG(CASE WHEN GDP <= 1500 THEN `Life expectancy` ELSE NULL END) Low_GDP_Life_Expectancy
FROM world_life_expectancy
;

# 6. What's the COUNT & AVG `Life expectancy` of Developed vs Developing countries?

SELECT Status, COUNT(DISTINCT(Country)), ROUND(AVG(`Life expectancy`), 1)
FROM world_life_expectancy
GROUP BY Status
;

# 7. Comparing Country & BMI

SELECT Country, BMI
FROM world_life_expectancy
GROUP BY Status
;

SELECT Country, ROUND(AVG(`Life expectancy`), 1) AS Avg_Life_Exp, ROUND(AVG(BMI), 1) AS Avg_BMI
FROM world_life_expectancy
GROUP BY Country
HAVING Avg_Life_Exp > 0
AND Avg_BMI > 0
ORDER BY Avg_BMI ASC
;

# 8. Rolling Total with `Adult Mortality`, ORDER BY Year b/c we want to add up year by year

SELECT Year,
Country,
`Life expectancy`,
`Adult Mortality`,
SUM(`Adult Mortality`) OVER(PARTITION BY Country ORDER BY Year) AS Rolling_Total
FROM world_life_expectancy
#WHERE Country LIKE '%United%'
;

SELECT *
FROM world_life_expectancy
;


