USE walmart;

-- Total records
SELECT COUNT(*) AS Total_Records
FROM walmart;

-- View sample data
SELECT *
FROM walmart
LIMIT 10;

-- Unique stores
SELECT DISTINCT Store
FROM walmart;

-- Unique departments
SELECT DISTINCT Dept
FROM walmart;

-- Total sales
SELECT SUM(Weekly_Sales) AS Total_Sales
FROM walmart;

-- Average sales
SELECT AVG(Weekly_Sales) AS Avg_Sales
FROM walmart;

-- Highest sales
SELECT MAX(Weekly_Sales) AS Max_Sales
FROM walmart;

-- Lowest sales
SELECT MIN(Weekly_Sales) AS Min_Sales
FROM walmart;

-- Total sales by store
SELECT Store,
       SUM(Weekly_Sales) AS Total_Sales
FROM walmart
GROUP BY Store;

-- Average sales by store
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

-- Total records by store
SELECT Store,
       COUNT(*) AS Total_Records
FROM walmart
GROUP BY Store;

-- Total sales by department
SELECT Dept,
       SUM(Weekly_Sales) AS Total_Sales
FROM walmart
GROUP BY Dept
ORDER BY Total_Sales DESC;

-- Best performing department
SELECT Dept,
       SUM(Weekly_Sales) AS Total_Sales
FROM walmart
GROUP BY Dept
ORDER BY Total_Sales DESC
LIMIT 1;

-- Departments with average sales above 20000
SELECT Dept,
       AVG(Weekly_Sales) AS Avg_Sales
FROM walmart
GROUP BY Dept
HAVING AVG(Weekly_Sales) > 20000;

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

-- Holiday vs non-holiday sales
SELECT IsHoliday,
       SUM(Weekly_Sales) AS Total_Sales,
       AVG(Weekly_Sales) AS Avg_Sales
FROM walmart
GROUP BY IsHoliday;

-- Highest sales record
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

-- Stores with total sales above 10 million
SELECT Store,
       SUM(Weekly_Sales) AS Total_Sales
FROM walmart
GROUP BY Store
HAVING SUM(Weekly_Sales) > 10000000;

-- Departments with average sales above 20000
SELECT Dept,
       AVG(Weekly_Sales) AS Avg_Sales
FROM walmart
GROUP BY Dept
HAVING AVG(Weekly_Sales) > 20000;

-- Rank stores by total sales
SELECT
    Store,
    SUM(Weekly_Sales) AS Total_Sales,
    RANK() OVER (ORDER BY SUM(Weekly_Sales) DESC) AS Sales_Rank
FROM walmart
GROUP BY Store;

-- Sales contribution by store
SELECT
    Store,
    SUM(Weekly_Sales) AS Total_Sales,
    ROUND(
        SUM(Weekly_Sales) * 100.0 / SUM(SUM(Weekly_Sales)) OVER(),
        2
    ) AS Contribution_Percentage
FROM walmart
GROUP BY Store;

-- Store performance category
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

-- Best department in each store
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

-- Year-over-year sales growth
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

-- Sales variation by store
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
