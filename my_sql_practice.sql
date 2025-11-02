/********************************************************************
  PROJECT: SQL Portfolio Project – Data Analysis Queries
  AUTHOR: Nurudeen Kanabe
  DESCRIPTION:
    This project showcases SQL data analysis skills across three datasets:
    1. Market Basket Dataset – Retail transaction analysis
    2. Global Sales Performance – Sales trend and performance
    3. Hiring Dataset – Recruitment and HR analytics
*********************************************************************/

---------------------------------------------------------------------
-- SECTION 1: Market Basket Dataset
---------------------------------------------------------------------

-- 1. Show the first 10 transactions.
SELECT TOP 10 *
FROM Market_Basket_Dataset;
GO

-- 2. Get all items purchased by CustomerID = 52299.
SELECT *
FROM Market_Basket_Dataset
WHERE customerID = 52299;
GO

-- 3. Count how many times "Potatoes" were sold.
SELECT
    Itemname,
    COUNT(*) AS Potatoesales
FROM Market_Basket_Dataset
WHERE Itemname = 'Potatoes'
GROUP BY Itemname;
GO

---------------------------------------------------------------------
-- SECTION 2: Global Sales Performance
---------------------------------------------------------------------

-- 4. Show the first 10 sales orders
SELECT TOP 10 *
FROM Global_sales_performance;
GO

-- 5. List all unique countries where sales happened.
SELECT
    country
FROM Global_sales_performance
GROUP BY country;
GO

-- 6. Find all orders from London.
SELECT *
FROM Global_sales_performance
WHERE City = 'London';
GO

---------------------------------------------------------------------
-- SECTION 3: Hiring Dataset
---------------------------------------------------------------------

-- 7. Show all applicants with "Master's" degree.
SELECT *
FROM Hiring_dataset
WHERE Education_level = 'Master''s';
GO

-- 8. Count how many applicants were hired.
SELECT
    COUNT(*) AS Hired
FROM hiring_dataset
WHERE Hired_Yes_No = 1;
GO

-- 9. Find the youngest applicant who got hired.
SELECT TOP 1 *
FROM Hiring_dataset
WHERE Hired_Yes_No = 1
ORDER BY Applicant_age ASC;
GO

---------------------------------------------------------------------
-- SECTION 4: Market Basket Dataset (additional)
---------------------------------------------------------------------

-- 10. Find the total revenue from all sales.
SELECT
    SUM(price) AS Totalsales
FROM Market_Basket_Dataset;
GO

-- 11. Show the top 5 most sold items.
SELECT TOP 5
    Itemname,
    SUM(Quantity) AS TOP5
FROM Market_Basket_Dataset
GROUP BY Itemname
ORDER BY SUM(Quantity) DESC;
GO

-- 12. Find how many unique customers exist (count rows per customer)
SELECT
    customerID,
    COUNT(*) AS TransactionsCount
FROM Market_Basket_Dataset
GROUP BY customerID;
GO

---------------------------------------------------------------------
-- SECTION 5: Global Sales Performance (additional)
---------------------------------------------------------------------

-- 13. Show the total sales per country.
SELECT
    Country,
    SUM(sales) AS TotalCountrySales
FROM Global_sales_Performance
GROUP BY country;
GO

-- 14. Find the product category with the highest sales.
SELECT TOP 1
    Product_category,
    SUM(sales) AS CategorySales
FROM Global_sales_performance
GROUP BY Product_category
ORDER BY SUM(sales) DESC;
GO

-- 15. Calculate average profit per region.
SELECT
    Region,
    AVG(Profit) AS AvgProfit
FROM Global_sales_performance
GROUP BY Region;
GO

---------------------------------------------------------------------
-- SECTION 6: Hiring Dataset (additional)
---------------------------------------------------------------------

-- 16. Count hires by education level.
SELECT
    Education_Level,
    COUNT(*) AS EducationHired
FROM hiring_dataset
WHERE Hired_Yes_No = 1
GROUP BY Education_level;
GO

-- 17. Find the average age of hired vs not hired.
SELECT
    Hired_Yes_No,
    AVG(Applicant_Age) AS HireAvgAge
FROM hiring_dataset
GROUP BY Hired_Yes_No;
GO

-- 18. Count male vs female hires.
SELECT
    Gender,
    COUNT(*) AS MaleFemaleHire
FROM hiring_dataset
WHERE Hired_Yes_No = 1
GROUP BY Gender;
GO

---------------------------------------------------------------------
-- SECTION 7: Market Basket — Association & Ranking
---------------------------------------------------------------------

-- 19. Find which product was most frequently bought together with "Milk".
SELECT TOP 1
    Itemname,
    COUNT(*) AS Frequency
FROM Market_Basket_Dataset
WHERE BillNO IN (
    SELECT BillNo
    FROM Market_Basket_Dataset
    WHERE Itemname = 'Milk'
)
AND Itemname <> 'Milk'
GROUP BY Itemname
ORDER BY COUNT(*) DESC;
GO

-- 20. Calculate total spending per customer and rank them.
SELECT
    CustomerID,
    SUM(price) AS CustomerSpending,
    RANK() OVER (ORDER BY SUM(price) DESC) AS Ranking
FROM Market_Basket_Dataset
GROUP BY CustomerID
ORDER BY CustomerSpending DESC;
GO

---------------------------------------------------------------------
-- SECTION 8: Global Sales Performance (more)
---------------------------------------------------------------------

-- 21. Find top 5 most profitable products.
SELECT TOP 5
    Product_category,
    SUM(Profit) AS ProductProfit
FROM Global_sales_performance
GROUP BY Product_category
ORDER BY SUM(Profit) DESC;
GO

-- 22. Show sales trend per year/month.
SELECT
    YEAR(Order_date) AS YearlyTrend,
    MONTH(Order_date) AS MonthlyTrend,
    SUM(sales) AS TotalSales
FROM Global_sales_performance
GROUP BY YEAR(Order_date), MONTH(Order_date)
ORDER BY YearlyTrend, MonthlyTrend;
GO

-- 23. Which region generated the highest profit margin?
SELECT
    Region,
    SUM(Profit) AS TotalProfit,
    SUM(sales) AS TotalSales,
    (SUM(Profit) * 100.0 / NULLIF(SUM(sales), 0)) AS Profit_Margin
FROM Global_sales_performance
GROUP BY Region
ORDER BY Profit_Margin DESC;
GO

---------------------------------------------------------------------
-- SECTION 9: Hiring Dataset — advanced grouping
---------------------------------------------------------------------

-- 24. Find correlation between age group and hiring.
SELECT
    CASE
        WHEN APPLICANT_AGE BETWEEN 18 AND 25 THEN '18-25'
        WHEN APPLICANT_AGE BETWEEN 26 AND 29 THEN '26-29'
        WHEN APPLICANT_AGE BETWEEN 30 AND 35 THEN '30-35'
        WHEN APPLICANT_AGE BETWEEN 36 AND 41 THEN '36-41'
        WHEN APPLICANT_AGE BETWEEN 42 AND 47 THEN '42-47'
        WHEN APPLICANT_AGE BETWEEN 48 AND 53 THEN '48-53'
        WHEN APPLICANT_AGE BETWEEN 54 AND 59 THEN '54-59'
        ELSE '60+'
    END AS AGEGROUP,
    HIRED_Yes_No,
    COUNT(*) AS [HIRED_OR_NOT]
FROM hiring_dataset
GROUP BY 
    CASE
        WHEN APPLICANT_AGE BETWEEN 18 AND 25 THEN '18-25'
        WHEN APPLICANT_AGE BETWEEN 26 AND 29 THEN '26-29'
        WHEN APPLICANT_AGE BETWEEN 30 AND 35 THEN '30-35'
        WHEN APPLICANT_AGE BETWEEN 36 AND 41 THEN '36-41'
        WHEN APPLICANT_AGE BETWEEN 42 AND 47 THEN '42-47'
        WHEN APPLICANT_AGE BETWEEN 48 AND 53 THEN '48-53'
        WHEN APPLICANT_AGE BETWEEN 54 AND 59 THEN '54-59'
        ELSE '60+'
    END,
    HIRED_Yes_No
ORDER BY AGEGROUP, HIRED_Yes_No;
GO

-- 25. If the company wants to hire more women, how many more females applied compared to males?
SELECT
    SUM(CASE WHEN GENDER = 'FEMALE' THEN 1 ELSE 0 END) AS [FEMALE_APPLICANT],
    SUM(CASE WHEN GENDER = 'MALE' THEN 1 ELSE 0 END) AS [MALE_APPLICANT],
    SUM(CASE WHEN GENDER = 'FEMALE' THEN 1 ELSE 0 END) -
    SUM(CASE WHEN GENDER = 'MALE' THEN 1 ELSE 0 END) AS [GENDER_DIFFERENCE]
FROM HIRING_DATASET;
GO

-- 26. Which education level has the highest hire rate (%)?
SELECT
    EDUCATION_LEVEL,
    SUM(CASE WHEN HIRED_Yes_No = 1 THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(*),0) AS HIRERATE
FROM HIRING_DATASET
GROUP BY EDUCATION_LEVEL
ORDER BY HIRERATE DESC;
GO




/* ==========================================================
   AUTHOR: Nurudeen Kanabe
   TITLE: SQL Data Analysis Portfolio Project
   DESCRIPTION:
   Practical SQL analytical tasks demonstrating the use of 
   joins, aggregation, CTEs, window functions, ranking, 
   percentage calculations, and performance tagging.
   ========================================================== */


/* ==========================================================
   SECTION 1: Foundational Analytical Queries
   ---------------------------------------------------------- */

/* --- Task 1: Top 5 Customers Overall --- */
SELECT TOP 5
    C.CustomerName,
    SUM(P.Price * S.Quantity) AS SalesTotal,
    ROW_NUMBER() OVER (ORDER BY SUM(P.Price * S.Quantity) DESC) AS RowNumber
FROM Sales AS S
INNER JOIN Customers AS C ON S.CustomerID = C.CustomerID
INNER JOIN Products AS P ON S.ProductID = P.ProductID
GROUP BY C.CustomerName;


/* --- Task 2: Monthly Sales Trend --- */
WITH MonthlySales AS
(
    SELECT
        E.EmployeeName,
        E.EmployeeID,
        MONTH(SaleDate) AS MonthlyNo,
        SUM(P.Price * S.Quantity) AS MonthlyTotalS
    FROM Sales AS S
    INNER JOIN Employees AS E ON S.EmployeeID = E.EmployeeID
    INNER JOIN Products AS P ON S.ProductID = P.ProductID
    GROUP BY MONTH(SaleDate), E.EmployeeName, E.EmployeeID
),
MonthlyAVG AS
(
    SELECT 
        AVG(MonthlyTotalS) AS MonthlyAverage
    FROM MonthlySales
)
SELECT 
    M.EmployeeName,
    M.EmployeeID,
    M.MonthlyNo,
    M.MonthlyTotalS,
    O.MonthlyAverage,
    CASE 
        WHEN M.MonthlyTotalS > O.MonthlyAverage THEN 'Excellent'
        ELSE 'Very Good'
    END AS PerformanceTag
FROM MonthlySales AS M
CROSS JOIN MonthlyAVG AS O
ORDER BY M.EmployeeName, M.MonthlyNo;


/* ==========================================================
   SECTION 2: Product and Department Insights
   ---------------------------------------------------------- */

/* --- Task 3: Product Performance Insight --- */
WITH ProductSale AS 
(
    SELECT 
        P.ProductName,
        P.ProductID,
        SUM(S.Quantity) AS TotalQuantity,
        SUM(P.Price * S.Quantity) AS TotalRevenue 
    FROM Sales AS S
    INNER JOIN Products AS P ON S.ProductID = P.ProductID
    GROUP BY P.ProductID, P.ProductName 
),
RevenueRank AS 
(
    SELECT   
        ProductID,
        RANK() OVER (ORDER BY TotalRevenue DESC) AS RevRank 
    FROM ProductSale
)
SELECT 
    T.ProductID,
    T.ProductName,
    T.TotalQuantity,
    T.TotalRevenue,
    R.RevRank,
    CASE 
        WHEN R.RevRank <= 3 THEN 'Best Seller'
        ELSE 'Standard Product'
    END AS PerformanceTag
FROM ProductSale AS T
INNER JOIN RevenueRank AS R ON T.ProductID = R.ProductID
ORDER BY R.RevRank;


/* --- Task 4: Department Contribution Overview --- */
WITH Department AS
(
    SELECT 
        E.Department,
        SUM(P.Price * S.Quantity) AS DepartmentSales 
    FROM Sales AS S
    INNER JOIN Employees AS E ON S.EmployeeID = E.EmployeeID 
    INNER JOIN Products AS P ON S.ProductID = P.ProductID 
    GROUP BY E.Department
)
SELECT 
    Department,
    DepartmentSales,
    CAST(DepartmentSales * 100.0 / SUM(DepartmentSales) OVER() AS DECIMAL(5,2)) AS PercentageContribution 
FROM Department
ORDER BY PercentageContribution DESC;


/* ==========================================================
   SECTION 3: Real-World Business Sales Dashboard
   ---------------------------------------------------------- */

/* --- Task 5: Full Dashboard Query --- */
WITH EmployeeTSales AS
(
    SELECT       
        E.EmployeeName,
        E.Department,
        SUM(P.Price * S.Quantity) AS EmpSales 
    FROM Sales AS S
    INNER JOIN Employees AS E ON S.EmployeeID = E.EmployeeID 
    INNER JOIN Products AS P ON S.ProductID = P.ProductID 
    GROUP BY E.Department, E.EmployeeName
),
Ranked AS
(
    SELECT 
        EmployeeName,
        Department,
        EmpSales,
        SUM(EmpSales) OVER (PARTITION BY Department) AS DepartmentSales,
        RANK() OVER (PARTITION BY Department ORDER BY EmpSales DESC) AS DepartmentRank 
    FROM EmployeeTSales 
),
PercentContribution AS 
( 
    SELECT 
        EmployeeName,
        Department,
        EmpSales,
        DepartmentSales,
        DepartmentRank,
        CAST(EmpSales * 100.0 / DepartmentSales AS DECIMAL(5,2)) AS PerContribution 
    FROM Ranked 
)
SELECT 
    EmployeeName,
    Department,
    EmpSales,
    DepartmentRank,
    PerContribution,
    CASE
        WHEN PerContribution >= 50 THEN 'Top Performer'
        WHEN PerContribution >= 20 THEN 'Strong Contributor'
        ELSE 'Team Player'
    END AS RoleTag
FROM PercentContribution 
ORDER BY Department, DepartmentRank;




