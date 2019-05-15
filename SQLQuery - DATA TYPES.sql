/*

		Title:	Introduction to SQL: data types & create tables (opdracht 36)
		Name:	Else

>> Numeric data types <<
int
decimal(n,m)	-- n, m are maximum amount of charachters in front and after the comma
numeric(n,m)
money
bit				-- 0 or 1, but could be used for TRUE/FALSE 
float			

>> Character sting data types <<
nchar(n)		-- exact n
nvarchar(n)		-- variable, but max n
ntext		

>> Date data types <<
date
time 
datetime

>> Make explicite converts <<
CONVERT(data type, expression)

>> CREATE TABLE <<

CREATE TABLE <schema name.?[table name] (
		[colum1, name] [ data type] <constraints>,
		[column2 name] [ data type] <constraints>, ...
		<constraint [constraint name] [constraint type] ([column 1], [column2]>
		)

>> Column types and constraints <<
Not Null
Primary Key
Unique
Identity
Check
Default

>> Insert data into table <<
INSERT INTO		tablename	(<column1> , <column2>, ..)
				values		( row1value1 , row1value2, ..),
							( row2value1 , row2value2, ..)

>> Select data from other table to insert in table <<
INSERT INTO		tablename (<column1> , <column2>, ..)
	SELECT		( <column1> , <column2>, ..)
	FROM		<tablename2>

>> Table commands <<
TRUNCATE TABLE							-- empty table
DELETE FROM tablename WHERE (condition)	-- delete rows from table (DELETE FROM Dim_customer2 WHERE CustomerCategory is null)
UPDATE tablename SET column = (expression) < WHERE (condition) >
DROP TABLE tablename	

*/

CREATE TABLE dbo.Test (
	LASTNAME nvarchar(20),
	AGE int
	)

	-- make an empy copy of dbo.Dim_Customer
