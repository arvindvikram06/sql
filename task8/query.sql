CREATE TABLE Employee (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    salary INT
);

INSERT INTO Employee (id, name, department, salary) VALUES
(1, 'Arun', 'IT', 50000),
(2, 'Bala', 'IT', 60000),
(3, 'Charan', 'IT', 60000),
(4, 'Divya', 'HR', 40000),
(5, 'Esha', 'HR', 70000),
(6, 'Farhan', 'HR', 70000),
(7, 'Gokul', 'Sales', 45000),
(8, 'Hari', 'Sales', 55000),
(9, 'Isha', 'Sales', 55000);

WITH dept_summary AS (
    SELECT department, COUNT(*) AS total_emp, AVG(salary) AS avg_salary
    FROM Employee
    GROUP BY department
)
SELECT * FROM dept_summary;

WITH dept_summary AS (
    SELECT department, COUNT(*) AS total_emp, AVG(salary) AS avg_salary
    FROM Employee
    GROUP BY department
)
SELECT * FROM dept_summary
WHERE avg_salary > 50000;

CREATE TABLE EmployeeHierarchy (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    manager_id INT
);

INSERT INTO EmployeeHierarchy VALUES
(1, 'CEO', NULL),
(2, 'Manager1', 1),
(3, 'Manager2', 1),
(4, 'Employee1', 2),
(5, 'Employee2', 2),
(6, 'Employee3', 3);

WITH RECURSIVE emp_tree AS (
    SELECT id, name, manager_id, 1 AS level
    FROM EmployeeHierarchy
    WHERE manager_id IS NULL
    UNION ALL
    SELECT e.id, e.name, e.manager_id, et.level + 1
    FROM EmployeeHierarchy e
    JOIN emp_tree et ON e.manager_id = et.id
)
SELECT * FROM emp_tree;