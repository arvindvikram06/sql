SELECT name, department, salary,
ROW_NUMBER() OVER (
    PARTITION BY department
    ORDER BY salary DESC
) AS row_num
FROM Employee;

SELECT name, department, salary,
RANK() OVER (
    PARTITION BY department
    ORDER BY salary DESC
) AS rank_val
FROM Employee;

SELECT name, department, salary,
DENSE_RANK() OVER (
    PARTITION BY department
    ORDER BY salary DESC
) AS dense_rank_val
FROM Employee;

SELECT name, department, salary,
LAG(salary) OVER (
    PARTITION BY department
    ORDER BY salary
) AS prev_salary
FROM Employee;

SELECT name, department, salary,
LEAD(salary) OVER (
    PARTITION BY department
    ORDER BY salary
) AS next_salary
FROM Employee;

SELECT *
FROM (
    SELECT name, department, salary,
    RANK() OVER (
        PARTITION BY department
        ORDER BY salary DESC
    ) AS rnk
    FROM Employee
) t
WHERE rnk = 1;