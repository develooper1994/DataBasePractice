USE ETRADE
UPDATE CUSTOMERS
SET NATION='TR'

SELECT DATEDIFF(YEAR, '1980-12-11', '2020-01-01')

SELECT * FROM CUSTOMERS

SELECT DATEDIFF(YEAR, BIRTHDATE, GETDATE()) FROM CUSTOMERS

UPDATE CUSTOMERS
SET NATION='TR', AGE=DATEDIFF(YEAR, BIRTHDATE, GETDATE())