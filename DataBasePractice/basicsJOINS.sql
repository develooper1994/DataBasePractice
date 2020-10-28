-- CREATE DATABASE
--CREATE DATABASE 
-- CREATE TABLES

USE Employement

CREATE TABLE department(
    DepartmentID INT PRIMARY KEY NOT NULL,
    DepartmentName VARCHAR(20)
);

CREATE TABLE employee (
    LastName VARCHAR(20),
    DepartmentID INT REFERENCES department(DepartmentID)
);

INSERT INTO department
VALUES (31, 'Sales'),
       (33, 'Engineering'),
       (34, 'Clerical'),
       (35, 'Marketing');

INSERT INTO employee
VALUES ('Rafferty', 31),
       ('Jones', 33),
       ('Heisenberg', 33),
       ('Robinson', 34),
       ('Smith', 34),
       ('Williams', NULL);

SELECT *
FROM employee CROSS JOIN department;

SELECT *
FROM employee, department;

-- INNER-JOIN
SELECT *
FROM employee e
INNER JOIN department d ON
e.DepartmentID = d.DepartmentID

-- LEFT-JOIN
SELECT *
FROM employee e
LEFT JOIN department d ON  -- LEFT OUTER ...  -- These are the same.
e.DepartmentID = d.DepartmentID

-- RIGHT-JOIN
SELECT *
FROM employee e
RIGHT JOIN department d ON  -- RIGHT OUTER ...  -- These are the same.
e.DepartmentID = d.DepartmentID

-- FULL-JOIN
SELECT *
FROM employee e
FULL JOIN department d ON  -- FULL OUTER ...  -- These are the same.
e.DepartmentID = d.DepartmentID

-- NATURAL-JOIN


-- SELF-JOIN
USE Employement

SELECT F.EmployeeID, F.LastName, S.EmployeeID, S.LastName, F.Country
FROM EmployeeDemo F INNER JOIN EmployeeDemo S ON F.Country = S.Country
WHERE F.EmployeeID < S.EmployeeID
ORDER BY F.EmployeeID, S.EmployeeID;


-- IMPORTANT NOTES
-- "left outer join" emulation
SELECT e.LastName, e.DepartmentID, d.DepartmentName
FROM employee e
INNER JOIN department d ON e.DepartmentID = d.DepartmentID

UNION ALL

SELECT e.LastName, e.DepartmentID, cast(NULL as varchar(20))
FROM employee e
WHERE NOT EXISTS (
    SELECT * FROM department d
             WHERE e.DepartmentID = d.DepartmentID)

-- some databases doesn't support "FULL OUTER JOIN". But we can emulate it with "UNION ALL" command.
-- combine all the other joins: """ left & inner & right """
-- >> inner part
SELECT e.DepartmentID, e.LastName,
d.DepartmentName, d.DepartmentID
FROM employee e
INNER JOIN department d ON e.DepartmentID = d.DepartmentID

UNION ALL

-- >> left part
SELECT e.LastName, e.DepartmentID,
       cast(NULL as varchar(20)), cast(NULL as integer)
FROM employee e
WHERE NOT EXISTS (
    SELECT * FROM department d
             WHERE e.DepartmentID = d.DepartmentID)

UNION ALL

-- >> right part
SELECT cast(NULL as varchar(20)), cast(NULL as integer),
       d.DepartmentName, d.DepartmentID
FROM department d
WHERE NOT EXISTS (
    SELECT * FROM employee e
             WHERE e.DepartmentID = d.DepartmentID)