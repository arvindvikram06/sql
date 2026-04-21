
-- remove existing tables
DROP TABLE IF EXISTS audit_log;
DROP TABLE IF EXISTS order_details;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS customers;

-- =========================
-- TABLES
-- =========================

-- stores product categories
CREATE TABLE categories (
    category_id   INTEGER PRIMARY KEY AUTOINCREMENT,
    category_name TEXT NOT NULL UNIQUE
);

-- stores buyer information
CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name  TEXT NOT NULL,
    last_name   TEXT NOT NULL,
    email       TEXT NOT NULL UNIQUE,
    phone       TEXT,
    address     TEXT,
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- stores items for sale
CREATE TABLE products (
    product_id   INTEGER PRIMARY KEY AUTOINCREMENT,
    product_name TEXT NOT NULL,
    price        REAL NOT NULL CHECK(price > 0),
    stock        INTEGER NOT NULL DEFAULT 0 CHECK(stock >= 0),
    category_id  INTEGER NOT NULL,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- stores each purchase by a customer
CREATE TABLE orders (
    order_id     INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id  INTEGER NOT NULL,
    order_date   DATETIME DEFAULT CURRENT_TIMESTAMP,
    status       TEXT NOT NULL DEFAULT 'pending'
                 CHECK(status IN ('pending','processing','shipped','delivered','cancelled')),
    total_amount REAL DEFAULT 0.0,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- stores which products are in each order
CREATE TABLE order_details (
    detail_id  INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id   INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity   INTEGER NOT NULL CHECK(quantity > 0),
    unit_price REAL NOT NULL CHECK(unit_price > 0),
    line_total REAL GENERATED ALWAYS AS (quantity * unit_price) STORED,
    FOREIGN KEY (order_id)   REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- records important changes automatically
CREATE TABLE audit_log (
    log_id     INTEGER PRIMARY KEY AUTOINCREMENT,
    table_name TEXT NOT NULL,
    action     TEXT NOT NULL,
    record_id  INTEGER,
    old_values TEXT,
    new_values TEXT,
    changed_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- INDEXES
-- =========================

CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_order_details_order ON order_details(order_id);

-- =========================
-- TRIGGERS
-- =========================

-- reduce stock when item is ordered
CREATE TRIGGER trg_reduce_stock
AFTER INSERT ON order_details
BEGIN
    UPDATE products SET stock = stock - NEW.quantity WHERE product_id = NEW.product_id;
END;

-- recalculate order total when item is added
CREATE TRIGGER trg_update_total
AFTER INSERT ON order_details
BEGIN
    UPDATE orders SET total_amount = (
        SELECT COALESCE(SUM(line_total), 0) FROM order_details WHERE order_id = NEW.order_id
    ) WHERE order_id = NEW.order_id;
END;

-- restore stock when order is cancelled
CREATE TRIGGER trg_restore_stock
AFTER UPDATE OF status ON orders
WHEN NEW.status = 'cancelled' AND OLD.status != 'cancelled'
BEGIN
    UPDATE products SET stock = stock + (
        SELECT quantity FROM order_details
        WHERE order_details.order_id = NEW.order_id AND order_details.product_id = products.product_id
    ) WHERE product_id IN (SELECT product_id FROM order_details WHERE order_id = NEW.order_id);
END;

-- log price changes to audit table
CREATE TRIGGER trg_audit_price
AFTER UPDATE OF price ON products
WHEN OLD.price != NEW.price
BEGIN
    INSERT INTO audit_log (table_name, action, record_id, old_values, new_values)
    VALUES ('products', 'PRICE_CHANGE', NEW.product_id, 'price=' || OLD.price, 'price=' || NEW.price);
END;

-- =========================
-- VIEWS
-- =========================

-- order details with customer and product names
CREATE VIEW vw_order_summary AS
SELECT o.order_id, c.first_name || ' ' || c.last_name AS customer,
       p.product_name, od.quantity, od.unit_price, od.line_total, o.status
FROM order_details od
JOIN orders o    ON od.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p  ON od.product_id = p.product_id;

-- product stock status
CREATE VIEW vw_inventory AS
SELECT p.product_name, cat.category_name, p.price, p.stock,
       CASE WHEN p.stock = 0 THEN 'OUT OF STOCK' WHEN p.stock < 10 THEN 'LOW' ELSE 'IN STOCK' END AS stock_status
FROM products p JOIN categories cat ON p.category_id = cat.category_id;

-- total spending per customer
CREATE VIEW vw_customer_spending AS
SELECT c.first_name || ' ' || c.last_name AS name, c.email,
       COUNT(DISTINCT o.order_id) AS total_orders, COALESCE(SUM(o.total_amount), 0) AS total_spent
FROM customers c LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

-- =========================
-- SAMPLE DATA
-- =========================

INSERT INTO categories (category_name) VALUES ('Electronics'), ('Clothing'), ('Books');

INSERT INTO customers (first_name, last_name, email, phone, address) VALUES
    ('Arvind', 'vikram',  'arvind@gmail.com', '9876543210', 'Bangalore'),
    ('Priya',  'Sharma', 'priya@gmail.com',  '9876543211', 'Mumbai'),
    ('Rahul',  'Patel',  'rahul@gmail.com',  '9876543212', 'Chennai');

INSERT INTO products (product_name, price, stock, category_id) VALUES
    ('iPhone 15',      79999.00,  50, 1),
    ('Samsung Galaxy', 69999.00,  35, 1),
    ('Cotton T-Shirt',   499.00, 200, 2),
    ('Denim Jeans',     1299.00, 150, 2),
    ('Python Book',      650.00, 100, 3);

-- =========================
-- TRANSACTIONS
-- =========================

-- Arvind buys iPhone + 2 Python Books
BEGIN TRANSACTION;
    INSERT INTO orders (customer_id) VALUES (1);
    INSERT INTO order_details (order_id, product_id, quantity, unit_price) VALUES (1, 1, 1, 79999.00);
    INSERT INTO order_details (order_id, product_id, quantity, unit_price) VALUES (1, 5, 2, 650.00);
COMMIT;

-- Priya buys Samsung + 2 Jeans
BEGIN TRANSACTION;
    INSERT INTO orders (customer_id) VALUES (2);
    INSERT INTO order_details (order_id, product_id, quantity, unit_price) VALUES (2, 2, 1, 69999.00);
    INSERT INTO order_details (order_id, product_id, quantity, unit_price) VALUES (2, 4, 2, 1299.00);
COMMIT;

-- Rahul buys 3 T-Shirts
BEGIN TRANSACTION;
    INSERT INTO orders (customer_id) VALUES (3);
    INSERT INTO order_details (order_id, product_id, quantity, unit_price) VALUES (3, 3, 3, 499.00);
COMMIT;

-- =========================
-- TEST QUERIES
-- =========================

SELECT product_name, stock FROM products;
SELECT order_id, total_amount, status FROM orders;
SELECT * FROM vw_order_summary;
SELECT * FROM vw_inventory;
SELECT * FROM vw_customer_spending;

-- test price change audit
UPDATE products SET price = 74999.00 WHERE product_id = 1;
SELECT * FROM audit_log;

-- test cancel restores stock
UPDATE orders SET status = 'cancelled' WHERE order_id = 2;
SELECT product_name, stock FROM products WHERE product_id IN (2, 4);

-- test rollback undoes changes
BEGIN TRANSACTION;
    INSERT INTO orders (customer_id) VALUES (1);
    INSERT INTO order_details (order_id, product_id, quantity, unit_price) VALUES (last_insert_rowid(), 1, 5, 79999.00);
ROLLBACK;
SELECT product_name, stock FROM products WHERE product_id = 1;
