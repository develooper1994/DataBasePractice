USE ETRADE2

SELECT TOP 100 *
FROM SALES

/*
Declare and assign a "constant"
*/
DECLARE @PI AS FLOAT = 3.14;
DECLARE @MYNAME NVARCHAR = 'Mustafa Selçuk Çaðlar', 
@MYNAME2 NVARCHAR(21) = 'Mustafa Selçuk Çaðlar',
@MYNAME3 NVARCHAR(10) = 'Mustafa Selçuk Çaðlar';
print @PI;
print @MYNAME;
print @MYNAME2;
print @MYNAME3;

/*
Declare a variable and then assign to it.
*/
DECLARE @e as FLOAT;
SET @e = 2.78;
print @e

/*
Assign a value from table
*/
DECLARE @BRAND_NAME NVARCHAR(15), @BRAND_ID INT
SELECT @BRAND_ID = 852
SET @BRAND_NAME = (SELECT BRAND FROM SALES WHERE ID=@BRAND_ID)
PRINT @BRAND_NAME
GO


use ETRADE2
DECLARE @NUMBER_OF_ITEMS INT;
SELECT @NUMBER_OF_ITEMS = COUNT(ITEMNAME)
FROM SALES
print @NUMBER_OF_ITEMS
select @NUMBER_OF_ITEMS  -- OR
GO

/*
Table variables
*/

use ETRADE2

Declare @dummy_table TABLE(
	ID int NOT NULL,
	ITEMCODE int NULL,
	BRAND nvarchar(20) NULL
);

INSERT INTO @dummy_table 
SELECT ID, ITEMCODE, BRAND
FROM SALES
WHERE CATEGORY1='GIDA'

SELECT * FROM @dummy_table
GO