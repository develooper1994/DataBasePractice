USE ETRADE2

SELECT TOP 100 *
FROM SALES

SELECT CONVERT(date, DATE_) AS DATE2, *
FROM SALES WHERE CITY='ANKARA'
ORDER BY DATE_

SELECT CONVERT(time, '2020-06-07 21:32:11.000')
SELECT CONVERT(date, '2020-06-07 21:32:11.000')
SELECT CONVERT(datetime, '2020-06-07 21:32:11.000')