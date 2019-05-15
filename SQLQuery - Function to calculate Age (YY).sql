--- Create Function to calculate Year of Age

create function [dbo].[YearsOld](@dayOfBirth datetime, @today datetime)
   RETURNS varchar(100)
AS

Begin
DECLARE @thisYearBirthDay datetime
DECLARE @years int
set @thisYearBirthDay = DATEADD(year, DATEDIFF(year, @dayOfBirth, @today), @dayOfBirth)
set @years = DATEDIFF(year, @dayOfBirth, @today) - (CASE WHEN @thisYearBirthDay > @today THEN 1 ELSE 0 END)
return cast(@years as int) 
end


select [dbo].[YearsOld](cast(Birthday as datetime), GETDATE()) as Age FROM Dim_Customer
