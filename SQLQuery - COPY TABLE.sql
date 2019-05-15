/* 

		Title: COPY TABLE AND INSERT DATA (Assignment 36)
		Name: Else

*/

USE [WideWorldImportersDW]
GO

/****** Object:  Table [dbo].[Dim_Customer]    Script Date: 5/7/2019 1:54:49 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Dim_Customer2](
	[Customer_Key] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](30) NULL,
	[LastName] [nvarchar](30) NULL,
	[Birthday] [date] NULL,
	[CustomerCategory] [nvarchar](30) NULL,
	[DistanceFromStore] [int] NULL,
	[Gender] [nchar](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[Customer_Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [USERDATA]
) ON [USERDATA]
GO

-- check contents of this table
SELECT * FROM Dim_Customer2

-- create an insert statement that inserts all data from the original Dim_Customer table, except DistanceFromStore. 
-- do not inserts identities, they are configured automatically.
INSERT INTO		Dim_Customer2 ([FirstName],[LastName],[Birthday],[CustomerCategory],[Gender])
	SELECT		[FirstName], [LastName],[Birthday],[CustomerCategory],[Gender]
	FROM		Dim_Customer

SELECT * FROM Dim_Customer2

-- fill in the missing data with an update command
UPDATE Dim_Customer2 SET DistanceFromStore = 5 
UPDATE Dim_Customer2 SET DistanceFromStore =
		(SELECT DistanceFromStore FROM Dim_Customer 
		Where Dim_Customer2.Customer_Key = Dim_Customer.Customer_Key)

UPDATE Dim_Customer2
   SET DistanceFromStore = 15
 WHERE Customer_Key = 11

SELECT * FROM Dim_Customer2																				

-- copy the create table form YoungCloseCustomers and insert the data from Dim_Customers. 
-- make sure that Age is inserted correctly and make sure that only the data is inserted that meet the constraints.

CREATE TABLE [dbo].[Dim_YoungCloseCustomers](
	[YoungCloseCustomer_Key] int identity primary key,
	[FirstName] [nvarchar](30) not null,
	[LastName] [nvarchar](30)  ,
	[Birthday] [date]  not null default('1900-01-01'),
	[CustomerCategory] nvarchar(30) ,
	[DistanceFromStore] [int] CHECK( [DistanceFromStore] < 50),
	[Gender] [char](1),
	[Age] int CHECK(Age <= 30),
	constraint UniquePeople Unique (FirstName , LastName, Birthday) ,
	constraint Genders CHECK(Gender IN ('F', 'M' , 'U'))
) 

INSERT INTO		[Dim_YoungCloseCustomers] ([FirstName],[LastName],[Birthday],[CustomerCategory],[Gender])
	SELECT		[FirstName],[LastName],[Birthday],[CustomerCategory],[Gender]
	FROM		Dim_Customer

-- Add  the distance from store < 50 
-- fill in the missing data with an update command

SELECT * FROM Dim_YoungCloseCustomers

UPDATE Dim_YoungCloseCustomers														-- select table
SET DistanceFromStore = 
	(																				-- set column to be updated
	SELECT DistanceFromStore														-- specify with what kind of data
		FROM Dim_Customer
		WHERE DistanceFromStore < 50
		AND Dim_YoungCloseCustomers.YoungCloseCustomer_Key = Dim_Customer.Customer_Key
	)

-- Insert the age of these customers
-- add age as a colum							-- how?

UPDATE	Dim_YoungCloseCustomers
SET Age = dbo.YearsOld(cast(Birthday as datetime), GETDATE())
where dbo.YearsOld(cast(Birthday as datetime), GETDATE()) < 30


-- Delete the rows that contain row with NULL values
DELETE FROM Dim_YoungCloseCustomers
	WHERE DistanceFromStore is null OR Age is null

-- Add an extra row manually

INSERT INTO Dim_YoungCloseCustomers ([FirstName],[LastName],[Birthday],[CustomerCategory],[DistanceFromStore],[Gender],[Age])
		VALUES ('Else', 'Frijling', '1989-03-28', 'Gold', 25, 'F', 30)

SELECT * FROM Dim_YoungCloseCustomers

-- Calculate a discount percentage based on DistanceFromStore / Age * 100
ALTER TABLE Dim_YoungCloseCustomers
ADD Discount numeric(5,2) CHECK(Discount <= 35)


UPDATE Dim_YoungCloseCustomers
SET Discount = 
	(select case when cast(DistanceFromStore as decimal)/cast(Age as decimal)*100 > 35 
	then 35 
	else cast(DistanceFromStore as decimal)/cast(Age as decimal)*100 
	end
	FROM Dim_YoungCloseCustomers as cus
	WHERE Dim_YoungCloseCustomers.YoungCloseCustomer_Key = cus.YoungCloseCustomer_Key)	-- in a subquery always add a condition

UPDATE Dim_YoungCloseCustomers															-- it is not necessary to use a subquery if you use data from same table
SET Discount = 
	case when cast(DistanceFromStore as decimal)/cast(Age as decimal)*100 > 35 
		then 35 
		else cast(DistanceFromStore as decimal)/cast(Age as decimal)*100 
		end

-- calculate the total quantity sold and the total revenue per sales territory
-- join fact.sales and dim.city
-- sum total quantity from fact.sales
-- sum total excluding tax
-- group by sales territory
-- insert into fact.SalesByTerritory


SELECT [Sales Territory],
		sum(Quantity),
		sum([Total Excluding Tax])
		FROM Fact.Sale
inner join Dimension.City
on Dimension.[City Key] = Fact.Sale.[City Key]
	group by Sales, Territory, Quantity, [Total Excluding Tax]
	order by [Total Excluding Tax] DESC
