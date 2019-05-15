/*

		Title:	Introduction to SQL: CASE WHEN
		Name:	Else

*/

-- Calculate the average price of the total sales divided by the quantity:
SELECT  * , 
		Total / Quantity as AveragePrice
FROM dbo.fact_Sales

-- Concatenate First and Last name into a FullName column, add a space in between:
SELECT FirstName + ' ' + LastName as FullName
  FROM dbo.Dim_Customer

/*
Condition or the "if"- function from SQL can be used in the SELECT. WHERE, GROUP BY, ORDER BY and HAVING statements:

case	when (condition)		then (result) 
		when (2nd condition)	then (result) ..
		else (result) 
		end < as (Name) >

*/

SELECT *,
	case when Quantity < 3 then 'Small Quantity'
	when Quantity >=3 AND Quantity < 6 then 'Medium Quantity'
	else 'Huge Quantity' end as QuantitySize
FROM dbo.fact_Sales
Order by Quantity DESC

-- Use the CASE: WHEN .. THEN .. ELSE .. END .. to calculate the total sales per gender

SELECT	sum(case when dc.Gender = 'F' then fs.Total else 0 end) as TotalFemaleSales,
		sum(case when dc.Gender = 'M' then fs.Total else 0 end) as TotalMaleSales	
from fact_Sales as fs
join Dim_Customer as dc on dc.Customer_Key = fs.Customer_Key

-- dbo.safedivide is a function to divide safely, je kunt bijvoorbeeld niet door 0 delen.
CREATE FUNCTION [dbo].[SafeDivide](
                  @Numerator  decimal(38,19)
                 ,@divisor    decimal(38,19) )
 
RETURNS decimal(38,6)
 
BEGIN
-- **************************************************************************
-- Description:
-- This function divides the first argument by the second argument after
-- checking for NULL or 0 divisors to avoid "divide by zero" errors.
-- **************************************************************************
DECLARE @quotient   decimal(38,6);
 
SET @quotient = null;
 
IF (     @divisor is not null
     AND @divisor <> 0
     AND @Numerator is not null )
   SET @quotient = @Numerator / @divisor;
 
   RETURN(@quotient)
 
END

-- Use the function SUBTRING() on the Employee Colymn from Dimension.Employee
SELECT SUBSTRING(Employee, 1, 4) FROM Dimension.Employee

-- Create new column with LastName from the Employee column

SELECT CHARINDEX(' ', Employee) FROM Dimension.Employee

SELECT SUBSTRING(
				Employee,					-- Select the right column
				CHARINDEX(' ', Employee)+1,	-- Calculate the position of the space and make sure that the Last name begins without the space itself
				50)							-- Define the position of the last character	
				as LastName
FROM Dimension.Employee

-- Select the SUM and the AVG of the Total Excl. Tax, create a third column dividing SUM by AVG and a 4th column counting all the rows in Fact.Sale
SELECT	sum([Total Excluding Tax]) as [TotalExTax],
		avg([Total Excluding Tax]) as [AvgExTax],
		sum([Total Excluding Tax])/avg([Total Excluding Tax]), 
		count([Sale Key]) as TotalRows
FROM Fact.Sale

-- Select City, State Province, and Country from Dimension.City. Add a column that shows all three in one with a comma and space as seperator.
SELECT	City,
		[State Province],
		Country,
		(City + ', ' + [State Province] + ', ' + Country) AS [Location]
FROM Dimension.City

--- Select all columns from Dim_customer and make an extra column based on DistanceFromStore
-- 5 or less: Walking distance
-- 6 - 20: Cycling distance
-- more than 20: Long distance

SELECT *, 
	case when DistanceFromStore <= 5 then 'WalkingDistance'
	when DistanceFromStore >=6 AND DistanceFromStore <= 20 then 'CyclingDistance'
	else'LongDistance' end as Distance
FROM Dim_Customer
Order by DistanceFromStore ASC

--- Calculate the amount of discount that each customer would have had based on the following customer categories:
-- None = 0%
-- Bronze = 5%
-- Silver = 10%
-- Gold = 15%

SELECT	CustomerCategory,
		LastName,
		FirstName,
		Total,
		case when CustomerCategory = 'Gold' then cast(round(Total * 0.15, 2) as decimal(10,2))
		when CustomerCategory = 'Silver' then cast(round(Total * 0.10, 2)  as decimal(10,2))
		when CustomerCategory = 'Bronze' then cast(round(Total * 0.05, 2) as decimal(10,2))
		else Total * 0 end Discount,
		Total - case when CustomerCategory = 'Gold' then cast(round(Total * 0.15, 2) as decimal(10,2))
		when CustomerCategory = 'Silver' then cast(round(Total * 0.10, 2)  as decimal(10,2))
		when CustomerCategory = 'Bronze' then cast(round(Total * 0.05, 2) as decimal(10,2))
		else Total * 0 end TotalWithDiscount
From dbo.Dim_Customer as dc
inner join dbo.fact_Sales as fs on dc.Customer_Key = fs.Customer_Key

--- Create a column that displays the final due date for payment
SELECT	*,
		Dateadd(mm, +2, TransactionDate_Key ) as DueDate,
		Dateadd(mm, +2, Dateadd(dd, + Quantity * 2, TransactionDate_Key)) as DueDatePlus
FROM dbo.fact_Sales

-- Calculate the exact age of the customers, use GETDATE(), DATEDIFF(), DATEPART() and a CASE WHEN (35)
-- SQL rounds the Years incorrectly, therefore calculate the current age in years, months and days seperately
-- My try for a solution
SELECT *,
	DATEDIFF(yy, Birthday, GETDATE())
	, 
	case 
		when (
		datepart(mm, getdate()) <= Datepart(mm, Birthday) AND DATEPART(dd, getdate()) > Datepart(dd, Birthday)
		) 
	then (DATEDIFF(yy, Birthday, GETDATE()) - 1) 
	else DATEDIFF(yy, Birthday, GETDATE()) 
	end as Age 
	FROM Dim_Customer



SELECT *
	, Datepart(mm, getdate()) - Datepart(mm, Birthday),
	case when (Datepart(mm, getdate()) - Datepart(mm, Birthday) < 0 
	AND Datepart(dd, getdate()) <= Datepart(dd, Birthday))
	then (12 + (Datepart(mm, getdate()) - Datepart(mm, Birthday))) else Datepart(mm, getdate()) - Datepart(mm, Birthday) end as Months FROM dbo.Dim_Customer



-- Dennis Solution:
select [dbo].[Age](cast(Birthday as datetime), GETDATE()) as Age FROM Dim_Customer


create function [dbo].[Age](@dayOfBirth datetime, @today datetime)
   RETURNS varchar(100)
AS

Begin
DECLARE @thisYearBirthDay datetime
DECLARE @years int, @months int, @days int
set @thisYearBirthDay = DATEADD(year, DATEDIFF(year, @dayOfBirth, @today), @dayOfBirth)
set @years = DATEDIFF(year, @dayOfBirth, @today) - (CASE WHEN @thisYearBirthDay > @today THEN 1 ELSE 0 END)
set @months = MONTH(@today - @thisYearBirthDay) - 1
set @days = DAY(@today - @thisYearBirthDay) - 1
return cast(@years as varchar(2)) + ' years,' + cast(@months as varchar(2)) + ' months,' + cast(@days as varchar(3)) + ' days'
end



-- Create three age categories: 0-30, 31-50, 50+. Show the sales per age group and gender.
SELECT	Gender,
		sum(Total),
		case when Datediff(yy, Birthday, Getdate()) <= 30 then 'Young' 
		when Datediff(yy, Birthday, Getdate()) <= 50 and Datediff(yy, Birthday, Getdate()) > 30 then 'MiddleAged'
		when Datediff(yy, Birthday, Getdate()) > 50   then '50PLUS'
		end as AgeGroup
From dbo.Dim_Customer as dc
inner join dbo.fact_Sales as fs 
on dc.Customer_Key = fs.Customer_Key
Group by Birthday, Gender				-- why do I have 3 50PLUS agegroups? I should have 2: M & F
Order by sum(Total) DESC






