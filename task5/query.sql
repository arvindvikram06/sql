-- Non-correlated subquery
SELECT FirstName, LastName, Department, Salary
FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees)
ORDER BY Salary DESC;

-- Correlated subquery
SELECT FirstName, LastName, Department, Salary
FROM Employees e
WHERE Salary > (
    SELECT AVG(Salary)
    FROM Employees dept
    WHERE dept.Department = e.Department
)
ORDER BY Department, Salary DESC;

-- each employee's salary vs their department average
SELECT
    FirstName,
    LastName,
    Department,
    Salary,
    (SELECT ROUND(AVG(Salary), 2)
     FROM Employees dept
     WHERE dept.Department = e.Department) AS DeptAvgSalary,
    Salary - (SELECT ROUND(AVG(Salary), 2)
              FROM Employees dept
              WHERE dept.Department = e.Department) AS DiffFromAvg
FROM Employees e
ORDER BY Department, DiffFromAvg DESC;

