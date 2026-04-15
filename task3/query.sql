show databases;
use office;

select * from Employees;

SELECT COUNT(*) AS TotalEmployees FROM Employees;


select round(avg(Salary),2) as avg_salary,
	min(Salary) as min_salary,
    max(Salary) as max_salary
from Employees;

SELECT Department,count(*) as Employee_count,
	   round(avg(Salary),2) as avg_salary,
	   sum(Salary) as total_payroll
From Employees
group by Department
order by avg_salary desc;


SELECT
    Department,
    ROUND(AVG(Salary), 2) AS AvgSalary
FROM Employees
GROUP BY Department
HAVING AVG(Salary) > 70000
ORDER BY AvgSalary DESC;
