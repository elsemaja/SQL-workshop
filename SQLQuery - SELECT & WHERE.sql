
/*

	TITLE:	Introduction 
	NAME:	Else


Selecting columns from tables in a specific database:

SELECT <Top x > <distinct>  <tablename.>columnname1
	  , <tablename.>columnname2	   ..
FROM	  databasename.schema.tablename <;>

*/

--- Select the following columns from Dimension.City: City, State Province and Country 
SELECT	 City.City
		 ,City.[State Province]
		 ,City.Country
FROM	 WideWorldImportersDW.Dimension.City 

--- Or less elaborate:

SELECT	City
		 ,[State Province]
		 ,Country
FROM	 Dimension.City 

--- Select distinct cities

SELECT	distinct City
		 ,[State Province]
		 ,Country
FROM	 Dimension.City 

---  Use Top x for the first x number of rows:

SELECT	Top 10 City
		 ,[State Province]
		 ,Country
FROM	 Dimension.City 

--- Use the where clause to select all the columns from the table Fact.Stock Holding 
--- where the quantity is more than 300000:

SELECT *  
FROM Fact.[Stock Holding]
  where [Quantity On Hand] > 300000

 --- Select the columns Supplier, Category and Supplier Reference from the table Dimension.Supplier 
 --- where Category is equal to Novelty Goods Supplier

SELECT Supplier
      ,Category
      ,[Supplier Reference]
FROM Dimension.Supplier
	where Category = 'Novelty Goods Supplier'

--- Select all columns from the table Dimension.Supplier 
--- where column 'Valid To' has a data after 30th of August 2016:

SELECT * 
FROM Dimension.Supplier
  where   [Valid To] > '2016-08-30'

--- Select Supplier, Category and Supplier Reference from the table Dimension.Supplier and 
--- filter on Novelty Goods Supplier and the amount of payment days should be more than 14

SELECT Supplier
      ,Category
      ,Supplier Reference
FROM Dimension.Supplier
	where (Category = 'Novelty Goods Supplier'
	or [Payment Days] > 14 ) --- Use brackets in case you use 'or'

--- LIKE is used to search for parts of a string (multiple characters such as "Novelty Goods Supplier"
--- % is a 'wildcard' indicating which characters are coming in front or after the searched unit

--- Select the employees with names ending with 'a'

SELECT * 
FROM Dimension.Employee 
	where Employee LIKE '%a'

--- Select the employees with names that do not end with 'a'

SELECT * 
FROM Dimension.Employee 
	where Employee NOT LIKE '%a'

--- Select the employees with names starting with 'a'

SELECT * 
FROM Dimension.Employee 
	where Employee LIKE 'a%'

--- Select the employees with names not starting with 'a'

SELECT * 
FROM Dimension.Employee 
	where Employee NOT LIKE 'a%'

--- Select the employees with names that include 'an'

SELECT employee.Employee
--SELECT * 
FROM Dimension.Employee 
	where Employee LIKE '%an%'


--- Difference between the use of "where ... = '...' or ... = '...' or ... = '...'"
--- and the use of 'where ... IN ('...', '...', '...')'

SELECT * 
FROM Dimension.Supplier
  where  ( [Primary Contact] = 'Bill Lawson'
	OR	[Primary Contact] = 'Hai Dam'
	OR [Primary Contact]  = 'Hubert Helms' )

SELECT * 
FROM Dimension.Supplier
  where   [Primary Contact] IN ( 'Bill Lawson' , 'Hai Dam' , 'Hubert Helms' )

--- '...' >= x and '...' <= x geeft hetzelfde resultaat als '...' BETWEEN x and x
SELECT * 
FROM Dimension.Supplier
  where   [Supplier Key] >= 5 and [Supplier Key] <= 10


SELECT * 
FROM Dimension.Supplier
  where   [Supplier Key] BETWEEN 5 and 10


