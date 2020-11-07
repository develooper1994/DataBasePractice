CREATE TABLE SampleFruits ( 
Id INT PRIMARY KEY IDENTITY(1,1) , 
FruitName VARCHAR(50) , 
Price INT
)
GO
INSERT INTO SampleFruits VALUES('Apple',20)
INSERT INTO SampleFruits VALUES('Apricot',12)
INSERT INTO SampleFruits VALUES('Banana',8)
INSERT INTO SampleFruits VALUES('Cherry',11)
INSERT INTO SampleFruits VALUES('Strawberry',26)
INSERT INTO SampleFruits VALUES('Lemon',4)  
INSERT INTO SampleFruits VALUES('Kiwi',14)  
INSERT INTO SampleFruits VALUES('Coconut',34) 
INSERT INTO SampleFruits VALUES('Orange',24)  
INSERT INTO SampleFruits VALUES('Raspberry',13)
INSERT INTO SampleFruits VALUES('Mango',9)
INSERT INTO SampleFruits VALUES('Mandarin',19)
INSERT INTO SampleFruits VALUES('Pineapple',22)
GO

SELECT * FROM SampleFruits
ORDER BY Price 

-- Pagination
DECLARE @Page INT = 1,
		@RowPagePartiton INT = 2,
		@Allrows INT = 0,
		@Rowperpage INT = 0,
		@PageOffset INT = 0;
SELECT @Allrows = COUNT(1) FROM SampleFruits
PRINT '@Allrows: ' + cast(@Allrows as varchar)

SELECT @Rowperpage = 
	CASE
	WHEN @Allrows%2=0 THEN @Allrows/@RowPagePartiton 
	ELSE @Allrows/@RowPagePartiton+1
	END
PRINT '@Rowperpage: ' + cast(@Rowperpage as varchar)

SET @PageOffset = @Page * @Rowperpage
PRINT '@PageOffset: ' + cast(@PageOffset as varchar)

SELECT FruitName,Price FROM SampleFruits
ORDER BY Price 
OFFSET (@PageOffset) ROWS 
FETCH NEXT @Rowperpage ROWS ONLY

DROP TABLE SampleFruits;