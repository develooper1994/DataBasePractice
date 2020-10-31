/*
I am going to create a dummy table to show how to implement an algorihm in SQL
https://docs.microsoft.com/en-us/sql/t-sql/language-elements/variables-transact-sql?view=sql-server-ver15
*/
USE School

CREATE TABLE TestTable(a INT, b char(3));
GO
SET NOCOUNT ON;
GO

-- init counter
declare @counter int = 0;

while(@counter < 26)
begin
	insert into TestTable values 
	(
	@counter, 
	CHAR((@counter+ASCII('a')))
	);
	set @counter = @counter+1;
end
GO

SET NOCOUNT off;
GO

select * from TestTable;
GO

DROP TABLE TestTable;
GO