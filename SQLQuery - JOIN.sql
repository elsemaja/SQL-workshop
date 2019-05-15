/*

		Title:	Introduction to JOINS
		Name:	Else

GENERAL FORMAT OF JOINS:
SELECT [column a]. [column b] ..
FROM [table a]
<LEFT/RIGHT> <INNER/OUTER/CROSS> JOIN [table b]
ON [table a].[column a] = [table b].[column a]
< AND [table a].[column c] = [table b].[column c]
*/

-- Compare the row from the following to queries:

SELECT * FROM Fact.Sale

SELECT * FROM Fact.Sale
INNER JOIN Dimension.Customer
ON Customer.[Customer Key] = Sale.[Customer Key]

-- Create a Simple Customer dimension 
create table dbo.Dim_Customer (
		Customer_Key int identity primary key, 
		FirstName nvarchar(30), 
		LastName  nvarchar(30),
		Birthday  date,
		CustomerCategory nvarchar(30), 
		DistanceFromStore int,
		Gender nchar(1)
		)

insert into dbo.Dim_Customer (FirstName , LastName, Birthday, CustomerCategory, DistanceFromStore, Gender)
	values( 'Piet' , 'Zwart' , '1966-08-12' , 'Gold' , 40, 'M'),
	( 'Henk' , 'Peters' , '1989-11-03' , 'None' , 5, 'M'),
	( 'Anita' , 'van Veen' , '1976-01-23' , 'None' , 3, 'F'),
	( 'Karin' , 'Zwart' , '1964-03-25' , 'Silver' , 40, 'F'),
	( 'Mike' , 'Janssen' , '1990-01-08' , 'Bronze' , 40, 'M'),
	( 'Harry' , 'Jansen' , '1946-06-06' , 'Bronze' , 22, 'M'),
	( 'Jan' , 'Verhoeven' , '2000-09-30' , 'Silver' , 13, 'M'),
	( 'Anouk' , 'Visser' , '1979-02-22' , 'Bronze' , 98, 'F'),
	( 'Henk' , 'Hoogendoorn' , '1988-04-03' , 'Bronze' , 8, 'M'),
	( 'Marit' , 'Markering' , '1992-05-29' , 'Silver' , 6, 'F')

-- create a simple Sales Fact
create table dbo.fact_Sales (
		Customer_Key int, 
		TransactionDate_Key date, 
		Quantity int,
		Total decimal(10,2), 
		)

insert into dbo.fact_Sales(Customer_Key, TransactionDate_Key, Quantity, Total )
	values( 1 , '2016-01-01' , 5, 100.00),
	( 8 , '2016-02-01' , 6, 120.12),
	( 2 , '2016-03-01' , 2, 41.20),
	( 4 , '2016-04-02' , 8, 162.23),
	( 5 , '2016-05-02' , 1, 19.75),
	( -1 , '2016-06-04' , 5, 98.40),
	( 6 , '2016-01-05' , 4, 117.89),
	( 7 , '2016-02-05' , 3, 56.09),
	( 8 , '2016-03-05' , 5, 85.01),
	( 9 , '2016-04-05' , 7, 138.65),
	( 1 , '2016-05-06' , 7, 199.90),
	( 4 , '2016-06-06' , 2, 21.20),
	( 5 , '2016-01-06' , 1, 8.70),
	( 8 , '2016-02-06' , 1, 19.30),
	( 7 , '2016-03-07' , 10, 221.99),
	( 4 , '2016-04-07' , 5, 100.90)


-- Select everything from fact_sales and im_customer and study the contents

SELECT * FROM dbo.Dim_Customer

SELECT * FROM dbo.fact_Sales

-- Write a query that selects everything from both tables and see what the difference is between:
-- LEFT JOIN, RIGHT JOIN, FULL OUTER JOIN and INNER JOIN


SELECT * FROM dbo.Dim_Customer
left join dbo.fact_Sales 
on dbo.Dim_Customer.Customer_Key = dbo.fact_Sales.Customer_Key

SELECT * FROM dbo.Dim_Customer
right join dbo.fact_Sales 
on dbo.Dim_Customer.Customer_Key = dbo.fact_Sales.Customer_Key

SELECT * FROM dbo.Dim_Customer
full outer join dbo.fact_Sales 
on dbo.Dim_Customer.Customer_Key = dbo.fact_Sales.Customer_Key

SELECT * FROM dbo.Dim_Customer
inner join dbo.fact_Sales 
on dbo.Dim_Customer.Customer_Key = dbo.fact_Sales.Customer_Key

-- Select Customer_Key, FirstName, TransactionDate_Key, and Total

SELECT dbo.fact_Sales.Customer_Key,
		FirstName,
		TransactionDate_Key,
		Total FROM dbo.Dim_Customer
left join dbo.fact_Sales 
on dbo.Dim_Customer.Customer_Key = dbo.fact_Sales.Customer_Key

-- A cross join will create 10 * 16 = 160 rows:
SELECT * FROM dbo.Dim_Customer
cross join dbo.fact_Sales 

-- Calculate the total amount spent per customer (also the customers that did not buy anything), ordered by "Total Bought" 
SELECT	LastName,
		FirstName,
		sum(Total) as [Total Bought]
FROM dbo.Dim_Customer as dc				-- rename the database+table to ds to write shorter code
full outer join dbo.fact_Sales as fs	-- rename the joiner here 
on dc.Customer_Key = fs.Customer_Key 
Group by LastName, FirstName			-- make sure to use the selected columns in the "group by" or "order by" function
order by [Total Bought] DESC

-- Add another Piet Zwart to the customer list. How do you make sure that these two persons are not aggregated?
-- The customer key is unique, therefore group by customer key:

insert into dbo.Dim_Customer (FirstName , LastName, Birthday, CustomerCategory, DistanceFromStore, Gender)
	values( 'Piet' , 'Zwart' , '1979-12-12' , 'None' , 5, 'M')

SELECT	dc.Customer_Key,
		LastName,
		FirstName,
		sum(Total) as [Total Bought]
FROM dbo.Dim_Customer as dc				
full outer join dbo.fact_Sales as fs	
on dc.Customer_Key = fs.Customer_Key 
Group by dc.Customer_Key, LastName, FirstName			
order by [Total Bought] DESC

-- Show only the customers that bought 10 or more items in total
SELECT	dc.Customer_Key,
		LastName,
		FirstName,
		Quantity,
		sum(Total) as [Total Bought]
FROM dbo.Dim_Customer as dc				
full outer join dbo.fact_Sales as fs	
on dc.Customer_Key = fs.Customer_Key 
Where Quantity >= 10
Group by dc.Customer_Key, LastName, FirstName, Quantity			
order by [Total Bought] DESC

-- How much is sold per month? Join Dimension Date (what kind of join?), Quantity ("Qty Sold"), Total ("Total Sales")
-- Order by Quantity, then by Sales

SELECT	Dimension.Date.[Calendar Month Label],
		sum(Quantity) as [Total Qty],
		sum(Total) as [Total Sales]
FROM Dimension.Date
right Join dbo.fact_Sales
ON Dimension.Date.Date = dbo.fact_Sales.TransactionDate_Key 
group by [Calendar Month Label]
Order by [Total Qty] DESC, [Total Sales] DESC

-- Compare the following two queries:

SELECT *
  FROM [WideWorldImportersDW].[dbo].[Dim_Customer]
  inner join fact_Sales on 1=1

SELECT *
  FROM [WideWorldImportersDW].[dbo].[Dim_Customer] 
  cross join fact_Sales


-- Compare the following two queries:

  SELECT *
  FROM [WideWorldImportersDW].[dbo].[Dim_Customer]
  cross join fact_Sales 
  where fact_Sales.Customer_Key = Dim_Customer.Customer_Key

SELECT *
  FROM [WideWorldImportersDW].[dbo].[Dim_Customer]
  inner join fact_Sales 
  on fact_Sales.Customer_Key = Dim_Customer.Customer_Key



