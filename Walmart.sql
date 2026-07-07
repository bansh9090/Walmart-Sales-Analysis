
USE walmart;

----------------------------------------------------
-- 🔰 BASIC LEVEL
----------------------------------------------------

-- Total records
SELECT COUNT(*) AS Total_Records
FROM walmart;

-- Sample data
SELECT *
FROM walmart
LIMIT 10;

-- Distinct stores
SELECT DISTINCT Store
FROM walmart;

-- Distinct departments
SELECT DISTINCT Dept
FROM walmart;

----------------------------------------------------
-- 📊 BASIC ANALYSIS
----------------------------------------------------

-- Total sales
SELECT SUM(Weekly_Sales) AS Total_Sales
FROM walmart;

-- Average sales
SELECT AVG(Weekly_Sales) AS Avg_Sales
FROM walmart;

-- Max sales
SELECT MAX(Weekly_Sales) AS Max_Sales
FROM walmart;

-- Min sales
SELECT MIN(Weekly_Sales) AS Min_Sales
FROM walmart;

----------------------------------------------------
-- 🏬 STORE LEVEL (INTERMEDIATE)
----------------------------------------------------

-- Total sales per store
SELECT Store,
       SUM(Weekly_Sales) AS Total_Sales
FROM walmart
GROUP BY Store;

-- Average sales per store
SELECT Store,
       AVG(Weekly_Sales) AS Avg_Sales
FROM walmart
GROUP BY Store;

-- Top 5 stores
SELECT Store,
       SUM(Weekly_Sales) AS Total_Sales
FROM walmart
GROUP BY Store
ORDER BY Total_Sales DESC
LIMIT 5;

-- Bottom 5 stores
SELECT Store,
       SUM(Weekly_Sales) AS Total_Sales
FROM walmart
GROUP BY Store
ORDER BY Total_Sales ASC
LIMIT 5;

-- Store transaction count
SELECT Store,
       COUNT(*) AS Total_Records
FROM walmart
GROUP BY Store;

----------------------------------------------------
-- 🏷️ DEPARTMENT LEVEL
----------------------------------------------------

-- Total sales per dept
SELECT Dept,
       SUM(Weekly_Sales) AS Total_Sales
FROM walmart
GROUP BY Dept
ORDER BY Total_Sales DESC;

-- Top department
SELECT Dept,
       SUM(Weekly_Sales) AS Total_Sales
FROM walmart
GROUP BY Dept
ORDER BY Total_Sales DESC
LIMIT 1;

-- High performing departments
SELECT Dept,
       AVG(Weekly_Sales) AS Avg_Sales
FROM walmart
GROUP BY Dept
HAVING AVG(Weekly_Sales) > 20000;

----------------------------------------------------
-- 📅 TIME ANALYSIS
----------------------------------------------------

-- Monthly sales
SELECT Month,
       SUM(Weekly_Sales) AS Total_Sales
FROM walmart
GROUP BY Month
ORDER BY Month;

-- Yearly sales
SELECT Year,
       SUM(Weekly_Sales) AS Total_Sales
FROM walmart
GROUP BY Year
ORDER BY Year;

----------------------------------------------------
-- 🎉 HOLIDAY ANALYSIS
----------------------------------------------------

SELECT IsHoliday,
       SUM(Weekly_Sales) AS Total_Sales,
       AVG(Weekly_Sales) AS Avg_Sales
FROM walmart
GROUP BY IsHoliday;

----------------------------------------------------
-- 📉 EXTREME VALUES
----------------------------------------------------

-- Highest sale record
SELECT *
FROM walmart
ORDER BY Weekly_Sales DESC
LIMIT 1;

-- Top 10 sales
SELECT *
FROM walmart
ORDER BY Weekly_Sales DESC
LIMIT 10;

-- Bottom 10 sales
SELECT *
FROM walmart
ORDER BY Weekly_Sales ASC
LIMIT 10;

----------------------------------------------------
-- 🚨 BUSINESS RULES (HAVING)
----------------------------------------------------

-- Stores with sales > 10M
SELECT Store,
       SUM(Weekly_Sales) AS Total_Sales
FROM walmart
GROUP BY Store
HAVING SUM(Weekly_Sales) > 10000000;

-- Departments avg sales > 20K
SELECT Dept,
       AVG(Weekly_Sales) AS Avg_Sales
FROM walmart
GROUP BY Dept
HAVING AVG(Weekly_Sales) > 20000;

----------------------------------------------------
-- 🚀 ADVANCED LEVEL (INTERVIEW READY)
----------------------------------------------------

-- Store ranking
SELECT 
    Store,
    SUM(Weekly_Sales) AS Total_Sales,
    RANK() OVER (ORDER BY SUM(Weekly_Sales) DESC) AS Sales_Rank
FROM walmart
GROUP BY Store;

-- Sales contribution %
SELECT 
    Store,
    SUM(Weekly_Sales) AS Total_Sales,
    ROUND(
        SUM(Weekly_Sales) * 100.0 / SUM(SUM(Weekly_Sales)) OVER(),
        2
    ) AS Contribution_Percentage
FROM walmart
GROUP BY Store;

-- Performance category
SELECT 
    Store,
    SUM(Weekly_Sales) AS Total_Sales,
    CASE 
        WHEN SUM(Weekly_Sales) > 10000000 THEN 'High'
        WHEN SUM(Weekly_Sales) BETWEEN 5000000 AND 10000000 THEN 'Medium'
        ELSE 'Low'
    END AS Performance_Level
FROM walmart
GROUP BY Store;

-- Best department per store
SELECT *
FROM (
    SELECT 
        Store,
        Dept,
        SUM(Weekly_Sales) AS Total_Sales,
        RANK() OVER (PARTITION BY Store ORDER BY SUM(Weekly_Sales) DESC) AS rnk
    FROM walmart
    GROUP BY Store, Dept
) t
WHERE rnk = 1;

-- Year over year growth
SELECT 
    Year,
    SUM(Weekly_Sales) AS Total_Sales,
    LAG(SUM(Weekly_Sales)) OVER (ORDER BY Year) AS Prev_Year,
    ROUND(
        (SUM(Weekly_Sales) - LAG(SUM(Weekly_Sales)) OVER (ORDER BY Year)) * 100.0 /
        LAG(SUM(Weekly_Sales)) OVER (ORDER BY Year),
        2
    ) AS Growth_Percentage
FROM walmart
GROUP BY Year;

-- Sales variation (risk analysis)
SELECT 
    Store,
    AVG(Weekly_Sales) AS Avg_Sales,
    MAX(Weekly_Sales) AS Max_Sales,
    MIN(Weekly_Sales) AS Min_Sales,
    (MAX(Weekly_Sales) - MIN(Weekly_Sales)) AS Variation
FROM walmart
GROUP BY Store
ORDER BY Variation DESC;

-- Sales stability
SELECT 
    Store,
    AVG(Weekly_Sales) AS Avg_Sales,
    STDDEV(Weekly_Sales) AS Sales_StdDev
FROM walmart
GROUP BY Store
ORDER BY Sales_StdDev ASC;