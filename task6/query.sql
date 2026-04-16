SELECT 
    order_id,
    order_date,
    delivery_date,
    DATEDIFF(day, order_date, delivery_date) AS days_taken
FROM Orders;

SELECT 
    order_id,
    order_date,
    DATEADD(day, 7, order_date) AS expected_delivery
FROM Orders;

SELECT *
FROM Orders
WHERE order_date >= DATEADD(day, -30, GETDATE());

SELECT 
    order_id,
    CONVERT(VARCHAR, order_date, 103) AS formatted_order_date
FROM Orders;