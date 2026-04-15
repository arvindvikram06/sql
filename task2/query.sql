SELECT * FROM Employees
WHERE Department = 'Sales';

SELECT * FROM Employees
WHERE Department = 'IT'
ORDER BY Salary DESC;

SELECT FirstName, LastName, Department, Salary
FROM Employees
WHERE Department = 'Sales'
  AND Salary > 63000
ORDER BY Salary DESC;

SELECT FirstName, LastName, Department, Salary
FROM Employees
WHERE Department = 'HR'
   OR Department = 'Finance'
ORDER BY LastName ASC;