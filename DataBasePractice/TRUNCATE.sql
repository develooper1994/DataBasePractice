-- RESTART THE TABLE.
-- returns to its original state
-- DELETE ALL VALUES, SETTINGS AND COLOUMNS
-- * Resets auto-increment
-- very fast operation

USE ETRADE

INSERT INTO 
CUSTOMERS(CUSTOMERNAME,CITY,DISTRICT,BIRTHDATE,GENDER) 
VALUES 
('Volkan ÇEKÝP','Bartýn','Kurucaþile','1997-10-24 00:00:00.000','E')

SELECT * FROM CUSTOMERS

-- first see the affect of delete
DELETE FROM CUSTOMERS

-- add a second understand the affect of delete
-- returns to its original state
TRUNCATE TABLE CUSTOMERS