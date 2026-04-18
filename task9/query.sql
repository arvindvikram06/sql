CREATE DATABASE SchoolDB;
GO

USE SchoolDB;
GO

CREATE TABLE Students (
    StudentID   INT PRIMARY KEY IDENTITY(1,1),
    StudentName VARCHAR(50),
    Mark        INT,
    JoinDate    DATE
);
GO

INSERT INTO Students (StudentName, Mark, JoinDate)
VALUES
    ('Alice',  85, '2024-01-10'),
    ('Bob',    60, '2024-02-15'),
    ('Charlie',90, '2024-03-20'),
    ('Diana',  45, '2024-04-25'),
    ('Eve',    75, '2024-05-30');
GO

CREATE PROCEDURE GetStudentsByDate
    @StartDate DATE,
    @EndDate   DATE
AS
BEGIN
    SELECT StudentName, Mark, JoinDate
    FROM   Students
    WHERE  JoinDate BETWEEN @StartDate AND @EndDate;
END;
GO

CREATE FUNCTION dbo.GetGrade (@Mark INT)
RETURNS VARCHAR(10)
AS
BEGIN
    DECLARE @Grade VARCHAR(10);
    IF @Mark >= 90 SET @Grade = 'A';
    ELSE IF @Mark >= 75 SET @Grade = 'B';
    ELSE IF @Mark >= 60 SET @Grade = 'C';
    ELSE SET @Grade = 'F';
    RETURN @Grade;
END;
GO

CREATE FUNCTION dbo.GetStudentsByGrade (@Grade VARCHAR(10))
RETURNS TABLE
AS
RETURN
(
    SELECT StudentName, Mark
    FROM   Students
    WHERE  dbo.GetGrade(Mark) = @Grade
);
GO

EXEC GetStudentsByDate @StartDate = '2024-01-01', @EndDate = '2024-04-30';
GO

SELECT StudentName, Mark, dbo.GetGrade(Mark) AS Grade
FROM Students;
GO

SELECT * FROM dbo.GetStudentsByGrade('B');
GO