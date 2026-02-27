Create database Fortune500;
use Fortune500;
CREATE TABLE fortune500 (
    Ranking INT,
    Company VARCHAR(255),
    Revenue DOUBLE,
    Growth DOUBLE,
    Profit DOUBLE,
    Profit_Margin DOUBLE,
    Assets DOUBLE,
    Employees INT,
    Years VARCHAR(20),
    Year INT
);
select * from fortune500;

# Total revenue per year
SELECT Year, SUM(Revenue) AS total_revenue
FROM fortune500
GROUP BY Year
ORDER BY Year;

#Average profit margin per year
SELECT Year, AVG(Profit_Margin) AS avg_margin
FROM fortune500
GROUP BY Year
ORDER BY Year;

#Total employees per year
SELECT Year, SUM(Employees) AS workforce
FROM fortune500
GROUP BY Year
ORDER BY Year;

#Top company per year
SELECT Year, Company, Revenue
FROM fortune500 f
WHERE Revenue = (
    SELECT MAX(Revenue)
    FROM fortune500
    WHERE Year = f.Year
);

#Companies present across all years
SELECT Company
FROM fortune500
GROUP BY Company
HAVING COUNT(DISTINCT Year) = 5;

#Duplicate check
SELECT Company, Year, COUNT(*)
FROM fortune500
GROUP BY Company, Year
HAVING COUNT(*) > 1;

#NULL check
SELECT *
FROM fortune500
WHERE Revenue IS NULL
   OR Profit IS NULL
   OR Employees IS NULL;
   
#Row count check
SELECT COUNT(*) FROM fortune500;

# Year wise revenue top 5 

SELECT Year,
       Company,
       Revenue,
       ROUND(
           Revenue * 100.0 / SUM(Revenue) OVER (PARTITION BY Year),
           2
       ) AS revenue_percentage
FROM (
    SELECT Year,
           Company,
           Revenue,
           ROW_NUMBER() OVER (PARTITION BY Year ORDER BY Revenue DESC) AS rn,
           SUM(Revenue) OVER (PARTITION BY Year) AS yearly_total
    FROM fortune500
) ranked
WHERE rn <= 5
ORDER BY Year, rn;

#Companies with highest growth per year
SELECT Year, Company, Growth
FROM (
    SELECT Year, Company, Growth,
           ROW_NUMBER() OVER (PARTITION BY Year ORDER BY Growth DESC) rn
    FROM fortune500
) t
WHERE rn = 1;


#Year with highest total profit
SELECT Year, SUM(Profit) AS total_profit
FROM fortune500
GROUP BY Year
ORDER BY total_profit DESC
LIMIT 1;