/* On: an examination of the various sql joins */
/* An exploration of the 6 various SQL joins, syntax, usecases, with provided examples. */

CREATE TABLE employees(
	employee_id INT PRIMARY KEY,
	employee_name TEXT,
	email TEXT,
	location TEXT,
	age INT,
	gender TEXT, 
	manager_id INT,
	manager_name TEXT
);

INSERT INTO employees(employee_id, employee_name, email, location, age, gender, manager_id, manager_name)
VALUES
	('1', 'Courage', 'CourageTheDawg@gmail.com', 'Nowhere, Kansas', '10', 'Male', '7', 'Shirley' ),
	('2', 'Muriel Bagge', 'MBagge@gmail.com', 'Nowhere, Kansas', '89', 'Female', NULL, NULL),
	('3', 'Eustace Bagge', 'EBagge12@gmail.com', 'Nowhere, Kansas', '106', 'Male', '2', 'Muriel Bagge'),
	('5', 'Katz', 'TheKatz1@gmail.com', 'Edinburgh, Scotland', '30', 'Male', '3', 'Eustace Bagge'),
	('6', 'King Ramses', 'K!ngRam@gmail.com', 'Cairo, Egypt', '3236', 'Ghost', '3', 'Eustace Bagge'),
	('7', 'Shirley', 'ShirleyTM@gmail.com', NULL, '30', NULL, '3', 'Eustace Bagge'),
	('8', 'Nowhere Newsman', 'NNMan@gmail.com', NULL, NULL, NULL, NULL, NULL),
	('9', NULL, NULL, NULL, NULL, NULL, '7', 'Shirley');

CREATE TABLE finances(
	employee_id INT, 
	paystamp_id INT,
	years_at_company INT,
	position TEXT,
	hourly_rate INT,
	salary INT,
	FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

INSERT INTO finances(employee_id, paystamp_id, years_at_company, position, hourly_rate, salary)
VALUES
	('1', '106', '5', 'labour', '20', '36000'),
	('2', '101', '45', 'CEO', '45', '81000'),
	(NULL, '103', '45', 'COO', '45', '81000'),
	('5', '103', '20', 'Digital Marketing', '30', '54000'),
	('6', '105', '35', 'Retired', NULL, NULL),
	(NULL, '103', '15', 'Project Manager', '25', '35000'),
	('8', '109', NULL, NULL, NULL, NULL),
	('9', '106', '12', 'labour', '12', '21600');


/* INNER JOIN*/
/* An SQL INNER JOIN (often simply written as JOIN) allows you to combine two or more tables based on a shared matching value between them.*/
SELECT employees.*, finances.*
FROM employees INNER JOIN finances ON employees.employee_id = finances.employee_id
WHERE employee_name = 'Courage';

SELECT SUM(finances.salary) AS yearly_total, COUNT(employees.employee_id) AS total_number_of_employees
FROM finances JOIN employees ON employees.employee_id = finances.employee_id;

SELECT SUM(hourly_rate * 40 * 22) AS months, employees.employee_name, finances.position
FROM finances JOIN employees ON employees.employee_id = finances.employee_id
WHERE position IN ('CEO', 'COO', 'Project Oversight')
GROUP BY employees.employee_name, finances.position
ORDER BY finances.position;
/* Further practical examples of using a (inner) join include, books and authors, users and roles, and students and grades. */


/* LEFT JOIN*/
/* A SQL LEFT JOIN returns all records from the left table and the matching records from the right table. 
If there is no match, NULL values are returned for the columns from the right table. */
SELECT employees.*, finances.*
FROM employees RIGHT JOIN finances ON employees.employee_id = finances.employee_id;

SELECT employees.*, finances.*, (finances.years_at_company * finances.salary) AS total_payout
FROM employees RIGHT JOIN finances ON employees.employee_id = finances.employee_id;

SELECT employees.*, finances.*
FROM employees RIGHT JOIN finances ON employees.employee_id = finances.employee_id
WHERE employees.employee_id IS NULL;
/* Further practical examples of using a left join include, users and post, products and reviews, and countries and cities. */

/*RIGHT JOIN*/
/* A SQL RIGHT JOIN returns all records from the right table and the matching records from the left table. 
If there is no match, NULL values are returned for the columns from the left table. */
SELECT finances.*, employees.*
FROM finances LEFT JOIN employees ON employees.employee_id = finances.employee_id
WHERE finances.paystamp_id IN ('103');

SELECT employees.employee_id, employees.employee_name, finances.position, finances.hourly_rate
FROM finances LEFT JOIN employees ON employees.employee_id = finances.employee_id
WHERE finances.position IN ('labour','Project Manager')
ORDER BY finances.position;

SELECT finances.*, employees.*
FROM finances LEFT JOIN employees ON employees.employee_id = finances.employee_id
WHERE finances.employee_id IS NULL;
/* Further practical examples of using a Right join include, product inventory and sales, sales orders, and employee and department. */

/*FULL OUTER JOIN*/
/* A SQL FULL OUTER JOIN combines the specified tables by including all rows from both tables. If there are no matching records in either table, 
the resulting output will display NULL for any missing data. */
SELECT employees.*, finances.*
FROM employees full outer join finances ON employees.employee_id = finances.employee_id
ORDER BY employees.employee_id;

SELECT employees.*, finances.*
FROM employees full outer join finances ON employees.employee_id = finances.employee_id
WHERE employees.employee_id	IS NULL AND finances.employee_id IS NULL
ORDER BY employees.employee_id;
/* Further practical examples of using a full outer join include, university enrollment, product sales and returns, customer orders. */

/*SELF JOIN*/
/* A Self Join in SQL is a type of join where a table is joined with itself. This is often used when you need to relate rows within the same table. 
For example, in a hierarchical data structure, such as an employee-supervisor relationship, you can use a Self Join to analyze who supervises a particular employee. */
SELECT A.employee_name AS employee, B.employee_name AS manager
FROM employees A
JOIN employees B ON A.manager_name = B.employee_name
ORDER BY manager
/* Further practical examples of using a inner join include, patient healthcare, event management, and finacial reports. */

/*CROSS JOIN*/
/* A Cross Join creates a combination of each row from the left table with every possible row from the right table. 
For example, each row in the left table is paired with all rows in the right table, resulting in a Cartesian product. */
SELECT *
FROM employees
CROSS JOIN finances;
/* By using the WHERE clause with conditions, we can perform an inner join using the cross join syntax. */
SELECT *
FROM employees
CROSS JOIN finances
WHERE employees.employee_id = finances.employee_id;
/* Further practical examples of using a cross join include, generating combinations for 
car makes and paint options, student years and class options, and T-shirt sizes and color options. */