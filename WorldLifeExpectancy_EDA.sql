# World Life Expectancy Project (Exploratory Data Analysis)


SELECT *
FROM world_life_expectancy
;

# To observe how each country has increased life expctancy in the last 15 years

SELECT Country, MIN(`Life Expectancy`),
 MAX(`Life Expectancy`),
ROUND( MAX(`Life Expectancy`) - MIN(`Life Expectancy`),1) AS '15_Year_Increase'
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(`Life Expectancy`) <> 0
AND MAX(`Life Expectancy`) <> 0
ORDER BY `15_Year_Increase` DESC
;

# How the world's life expectancy has improved (2007-2022)

SELECT Year, ROUND(AVG(`Life Expectancy`),2) AS AVG_Life_Exp
FROM world_life_expectancy
WHERE `Life Expectancy` <> 0
AND `Life Expectancy` <> 0
GROUP BY YEAR
ORDER BY YEAR DESC
;

# Correlation between countries and their life expectancies

SELECT Country, ROUND(AVG(`life expectancy`),1) AS Life_Exp, ROUND(AVG(GDP),1) AS GDP
FROM world_life_expectancy
GROUP BY Country
Having Life_Exp <> 0
AND GDP > 0
ORDER BY GDP DESC
;

# Correlation between High/Low GDP countries and their life expectancies

SELECT
	SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) High_GDP_Count,
	AVG(CASE WHEN GDP >= 1500 THEN `life expectancy`  ELSE NULL END) 	High_GDP_Life_Expectancy,
	SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) Low_GDP_Count,
	AVG(CASE WHEN GDP <= 1500 THEN `life expectancy`  ELSE NULL END) Low_GDP_Life_Expectancy
	FROM world_life_expectancy
;

# The average life expectancies of Devloping/Developed countries

SELECT Status, COUNT(DISTINCT Country), ROUND(AVG(`Life Expectancy`),1) as AVG_Life_Exp
FROM world_life_expectancy
GROUP BY Status
;


# Life Expectancy vs BMI

SELECT Country, ROUND(AVG(`life expectancy`),1) AS Life_Exp, ROUND(AVG(BMI),1) AS BMI
FROM world_life_expectancy
GROUP BY Country
Having Life_Exp <> 0
AND BMI > 0
ORDER BY BMI ASC
;

# Rolling total of Adult Mortality rates and its impact on Life Expectancy

SELECT Country,
Year,
`Life Expectancy`,
`Adult Mortality`,
SUM(`Adult Mortality`) OVER(PARTITION BY Country ORDER BY Year) as Rolling_Total
FROM world_life_expectancy
#WHERE Country Like '%United%'

