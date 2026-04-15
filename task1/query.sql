
show databases;

create database office;

use office;

CREATE TABLE Employees (
    EmployeeID   INT           PRIMARY KEY,
    FirstName    VARCHAR(50)   NOT NULL,
    LastName     VARCHAR(50)   NOT NULL,
    Department   VARCHAR(50),
    Salary       DECIMAL(10,2),
    HireDate     DATE
);


INSERT INTO Employees (EmployeeID, FirstName, LastName, Department, Salary, HireDate) VALUES
(1,  'Alice',   'Johnson',  'Sales',     62000.00, '2020-03-15'),
(2,  'Bob',     'Smith',    'IT',        85000.00, '2019-07-01'),
(3,  'Carol',   'Williams', 'HR',        54000.00, '2021-01-10'),
(4,  'David',   'Brown',    'Sales',     67000.00, '2018-11-20'),
(5,  'Eve',     'Davis',    'IT',        91000.00, '2017-05-30'),
(6,  'Frank',   'Miller',   'Finance',   75000.00, '2022-02-14'),
(7,  'Grace',   'Wilson',   'HR',        58000.00, '2020-09-03'),
(8,  'Henry',   'Moore',    'Finance',   80000.00, '2016-12-01'),
(9,  'Isla',    'Taylor',   'Sales',     61000.00, '2023-04-18'),
(10, 'Jack',    'Anderson', 'IT',        88000.00, '2019-08-22');


SELECT * FROM Employees;