-- Delete table Employee, Department and Company
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Department;
DROP TABLE IF EXISTS Company;

-- Create department table
CREATE TABLE department(
	id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

-- Create employee table
CREATE TABLE employee(
	id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    city VARCHAR(150) NOT NULL,
    department_id INT NOT NULL,
    salary INT NOT NULL,
    FOREIGN KEY (department_id) REFERENCES department(id)
);

-- Create company table
CREATE TABLE company(
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	revenue INT
);

-- Add rows into Department table
INSERT INTO department(name)
VALUES
('IT'),
('Management'),
('IT'),
('Support');

-- Add rows into Company table
INSERT INTO company(name,revenue)
VALUES
('IBM', 2000000),
('GOOGLE', 9000000),
('Apple', 10000000);

-- Add rows into employee table
INSERT INTO employee (name,city,department_id,salary)
VALUES
('David', 'London', 3, 80000),
('Emily', 'London', 3, 70000),
('Peter', 'Paris', 3, 60000),
('Ava', 'Paris', 3, 50000),
('Penny', 'London', 2, 110000),
('Jim', 'London', 2, 90000),
('Amy', 'Rome', 4, 30000),
('Cloe', 'London', 3, 110000);

-- Query all rows from Department table
SELECT *
FROM department;

-- Change the name of department with id =  1 to 'Management'
UPDATE department
SET name = 'Management'
WHERE id = 1;

-- Delete employees with salary greater than 100000
DELETE FROM employee
WHERE salary > 100000;

-- Query the names of companies
SELECT name
FROM company;

-- Query the name and city of every employee
SELECT name, city
FROM employee;

-- Query all companies with revenue greater than 5 000 000
SELECT *
FROM company
WHERE revenue > 5000000

-- Query all companies with revenue smaller than 5 000 000
SELECT *
FROM company
WHERE revenue < 5000000

--  Query all companies with revenue smaller than 5 000 000, but you cannot use the '<' operator
SELECT *
FROM company
LIMIT 1;

-- version 2
SELECT *
FROM company
WHERE NOT revenue >= 5000000;

-- Query all employees with salary greater than 50 000 and smaller than 70 000
SELECT *
FROM employee
WHERE salary > 50000 AND salary < 70000

-- Query all employees with salary equal to 80 000
SELECT *
FROM employee
WHERE salary = 80000

-- Query all employees with salary not equal to 80 000
SELECT *
FROM employee
WHERE salary <> 80000

-- Query all names of employees with salary greater than 70 000 together with employees who work on the 'IT' department.
SELECT e.name
FROM employee e
LEFT JOIN department d
ON e.department_id = d.id
WHERE e.salary > 70000
	OR d.name = 'IT';
	
-- or
SELECT name
FROM employee
WHERE salary > 70000
OR department_id IN (
	SELECT id
	FROM department
	WHERE name = 'IT');

-- Query all employees that work in city that starts with 'L'
SELECT *
FROM employee
WHERE city LIKE 'L%';

-- Query all employees that work in city that starts with 'L' or ends with 's'
SELECT *
FROM employee
WHERE city LIKE 'L%'
	OR city LIKE '%_s';

-- Query all employees that  work in city with 'o' somewhere in the middle
SELECT *
FROM employee
WHERE city LIKE '%o%';

-- Query all departments (each name only once)
SELECT DISTINCT name
FROM department;

-- Query names of all employees together with id of department they work in, but you cannot use JOIN
SELECT e.name, d.id, d.name
FROM employee e, department d
WHERE e.department_id = d.id
ORDER BY e.name, d.id;

-- Query names of all employees together with id of department they work in, using JOIN
SELECT e.name, d.id, d.name AS dept_name
FROM employee e
LEFT JOIN department d
ON e.department_id = d.id
ORDER BY e.name, d.id;

-- Query name of every company together with every department
SELECT c.name, d.name
FROM company c, department d
ORDER BY c.name;

-- Query name of every company together with departments without the 'Support' department
SELECT c.name, d.name
FROM company c, department d
WHERE d.name <> 'Support'
ORDER BY c.name;

-- Query employee name together with the department name that they are not working in
SELECT e.name, d.name
FROM employee e, department d
WHERE e.department_id <> d.id;

/*
Query company name together with other companies names
LIKE:
GOOGLE Apple
GOOGLE IBM
Apple IBM
...
*/

SELECT c.name, c2.name
FROM company c, company c2
WHERE c.name <> c2.name
ORDER BY c.name, c2.name DESC;

/*
Query employee names with salary smaller than 80 000 without using NOT and <
NOTE: for POSTGRESQL only. Mysql doesn't support except
*/

SELECT name
FROM employee
EXCEPT
SELECT name
FROM employee
WHERE salary >= 80000
ORDER BY name;

-- Query names of every company and change the name of column to 'Company'
SELECT name AS Company
FROM company;

-- Query all employees that work in same department as Peter
SELECT name
FROM employee
WHERE department_id IN (
	SELECT department_id
	FROM employee
	WHERE name LIKE 'Peter')
AND name <> 'Peter';

