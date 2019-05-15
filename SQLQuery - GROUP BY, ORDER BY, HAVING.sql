/*
	TITLE:	Introductory Assignments 
	NAME:	Else
*/

-- 1) Select the Supplier key, Supplier name, and Category from all suppliers from dimension.supplier that have more than 14 days as payment term 
-- Highlight everything except the where clause and see what happens.

SELECT [Supplier Key],
		Supplier,
		Category
From Dimension.Supplier
	where [Payment Days] > 14

-- Add a where clause to show only the Suppliers that end with "Inc. 
SELECT [Supplier Key],
		Supplier,
		Category
From Dimension.Supplier
		where [Payment Days] > 14 and Supplier LIKE '%Inc.'

-- Search for a contact person of a supplier that has a first or last name that starts with an M
SELECT [Primary Contact]
From Dimension.Supplier
		where ([Primary Contact] LIKE 'm%' or [Primary Contact] LIKE '%[ ]m%')

-- Calculate the total of all transactions
SELECT SUM([Total Excluding Tax])
  FROM Fact.Sale

-- Calculate the average transaction
SELECT AVG([Total Excluding Tax])
  FROM Fact.Sale

-- Use GROUP BY to add an extra dimension to the SELECT statement
SELECT SUM([Total Excluding Tax]), 
Package
  FROM Fact.Sale
  GROUP BY Package

-- Calculate the average population per state and country, ignoring State Provinces with a value of 0 (unknown)
 SELECT avg([Latest Recorded Population]), 
			Country,
			[State Province]
  FROM Dimension.City
  where [Latest Recorded Population] > 0
  group by Country, [State Province] 

-- Use HAVING to select the states with an average number of inhabitant of 10.000 or more.
-- ATTENTION: aggregates cannot be included in the WHERE clause by using HAVING after WHERE the computing time will be slower

SELECT avg([Latest Recorded Population]),
	   Country,
	   [State Province]
  FROM Dimension.City
  where [Latest Recorded Population] > 0
  group by	Country, 
			[State Province]
  having avg([Latest Recorded Population]) > 10000

-- It is possible to ORDER BY several instances:
-- Column name: 'ORDER BY [State Province] ASC'
-- An expression or aggregate: 'ORDER BY avg([Latest Recorded Population]) DESC'
-- Column number: 'ORDER BY 1 DESC'

SELECT AVG([Latest Recorded Population]), 
			Country, 
			[State Province] 
  FROM Dimension.City
  where [Latest Recorded Population] > 0
  group by Country, [State Province]
  having AVG([Latest Recorded Population]) > 10000
  order by 1 desc

-- Calculate the average amount of Payment Days per Supplier
SELECT avg([Payment Days]),
			Supplier
FROM Dimension.Supplier
Group by Supplier
Order by avg([Payment Days]) DESC

-- Filter the above query in order to get only Suppliers with Category "Service"
SELECT avg([Payment Days]),
			Supplier
-- SELECT *
FROM Dimension.Supplier
Where Category LIKE '%Services%'
Group by Supplier
Order by avg([Payment Days]) DESC

-- Calculate in Fact.Purchase how many transactions there have been per Packaging Type
SELECT count([Is Order Finalized]),
			Package
FROM Fact.Purchase
Group by Package

-- Calculate how many items there are in stock
SELECT count([Quantity On Hand])
-- SELECT *
FROM Fact.[Stock Holding]

-- Calculate the total amount of all items in stock
SELECT sum([Quantity On Hand])
-- SELECT *
FROM Fact.[Stock Holding]

-- Select from Fact.Movement all the days between the 1st of January and the 1st of June when there were more items going out compared to coming in.
-- Order the results in DESC order

SELECT [Date Key],
		Quantity
FROM Fact.Movement
where ([Date Key] BETWEEN '2016-01-01' and '2016-06-01') AND Quantity < 0 
Order by Quantity ASC

-- Find the total amount of sold units and the total profit per item. 
-- Show only the DBA joke mug.
-- Show the best sellers on top.

SELECT	[Description],
		sum(Quantity) as [Total Quantity],
		sum(Profit) as [Total Profit]
FROM	Fact.Sale
Where [Description] LIKE '%DBA joke mug%'
Group by [Description] 
Order by sum(Quantity) DESC



-- Calculate the total profit per product per year (=year([Invoice Date Key]). 
-- Sort by year (ASC) and profit (DESC)

SELECT	year([Invoice Date Key]), --here you select only the year from the Invoice date key, instead of the whole date
		[Description],
		sum(Profit) as [Total Profit]
FROM	Fact.Sale
Group by year([Invoice Date Key]), [Description] 
Order by year([Invoice Date Key]) ASC, [Total Profit] DESC


