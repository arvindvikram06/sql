
CREATE TABLE Customers (
    CustomerID   INT          PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    City         VARCHAR(50),
    Email        VARCHAR(100)
);

CREATE TABLE Orders (
    OrderID    INT           PRIMARY KEY,
    CustomerID INT           NOT NULL,
    OrderDate  DATE,
    Amount     DECIMAL(10,2),
    Status     VARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
 
INSERT INTO Customers (CustomerID, CustomerName, City, Email) VALUES
(1, 'Acme Corp',     'New York',  'acme@gmail.com'),
(2, 'Beta Ltd',      'Chicago',   'beta@gmail.com'),
(3, 'Gamma Inc',     'Houston',   'gamma@gmail.com'),
(4, 'Delta Co',      'Phoenix',   'delta@gmail.com'),
(5, 'Epsilon LLC',   'Seattle',   'epsilon@gmail.com');


INSERT INTO Orders (OrderID, CustomerID, OrderDate, Amount, Status) VALUES
(101, 1, '2024-01-15', 1500.00, 'Completed'),
(102, 2, '2024-02-20', 2300.00, 'Completed'),
(103, 1, '2024-03-05',  800.00, 'Pending'),
(104, 3, '2024-03-18', 3100.00, 'Completed'),
(105, 2, '2024-04-01', 1200.00, 'Cancelled'),
(106, 4, '2024-04-22',  950.00, 'Pending');


SELECT
    c.CustomerName,
    c.City,
    o.OrderID,
    o.OrderDate,
    o.Amount,
    o.Status
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
ORDER BY c.CustomerName, o.OrderDate;

SELECT
    c.CustomerName,
    c.City,
    o.OrderID,
    o.Amount
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
ORDER BY c.CustomerName;
