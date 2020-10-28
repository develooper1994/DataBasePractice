USE ETRADE

SELECT *
FROM CUSTOMERS
WHERE DATEDIFF(YEAR, BIRTHDATE, GETDATE()) <= 40 AND GENDER = 'E'
ORDER BY BIRTHDATE DESC, CUSTOMERNAME ASC, CITY, DISTRICT  -- default is ASC