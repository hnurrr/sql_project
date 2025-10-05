-- =====================================================
-- Online Shopping Platform Database
-- Author: Nur
-- Purpose: Demonstrate database design, data insertion,
--          updates, and reporting queries for an e-commerce platform
-- =====================================================

-- =====================================================
-- 1 Create Tables
-- =====================================================

-- Customer Table
CREATE TABLE Customer (
    id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    city VARCHAR(50),
    registration_date DATE
);

-- Seller Table
CREATE TABLE Seller (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(200)
);

-- Category Table
CREATE TABLE Category (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

-- Product Table
CREATE TABLE Product (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(8,2) NOT NULL CHECK (price >= 0),
    stock INT NOT NULL CHECK (stock >= 0),
    category_id INT,
    seller_id INT,
    FOREIGN KEY (category_id) REFERENCES Category(id),
    FOREIGN KEY (seller_id) REFERENCES Seller(id)
);

-- Order Table
CREATE TABLE Orders (
    id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    payment_type VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES Customer(id)
);

-- Order Details Table
CREATE TABLE Order_Detail (
    id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(8,2),
    FOREIGN KEY (order_id) REFERENCES Orders(id),
    FOREIGN KEY (product_id) REFERENCES Product(id)
);

-- =====================================================
-- 2 Insert Sample Data
-- =====================================================

-- Customers
INSERT INTO Customer VALUES
(1, 'Ahmet', 'Yilmaz', 'ahmet@example.com', 'Istanbul', '2025-01-10'),
(2, 'Ayse', 'Kaya', 'ayse@example.com', 'Ankara', '2025-02-15'),
(3, 'Mehmet', 'Demir', 'mehmet@example.com', 'Izmir', '2025-03-05'),
(4, 'Fatma', 'Celik', 'fatma@example.com', 'Bursa', '2025-04-20'),
(5, 'Emre', 'Sahin', 'emre@example.com', 'Antalya', '2025-05-10');

-- Sellers
INSERT INTO Seller VALUES
(1, 'TechStore', 'Istanbul, Tech Street 12'),
(2, 'FashionHub', 'Ankara, Fashion Street 5'),
(3, 'HomeGoods', 'Izmir, Home Avenue 7');

-- Categories
INSERT INTO Category VALUES
(1, 'Electronics'),
(2, 'Clothing'),
(3, 'Home & Kitchen');

-- Products
INSERT INTO Product VALUES
(1, 'Laptop', 5000.00, 50, 1, 1),
(2, 'Smartphone', 3000.00, 100, 1, 1),
(3, 'T-Shirt', 150.00, 200, 2, 2),
(4, 'Jeans', 250.00, 150, 2, 2),
(5, 'Coffee Maker', 350.00, 80, 3, 3),
(6, 'Vacuum Cleaner', 800.00, 40, 3, 3);

-- Orders
INSERT INTO Orders VALUES
(1, 1, '2025-08-01', 8150.00, 'Credit Card'),
(2, 2, '2025-08-03', 400.00, 'PayPal'),
(3, 3, '2025-08-05', 1250.00, 'Credit Card'),
(4, 1, '2025-08-07', 3000.00, 'Credit Card');

-- Order Details
INSERT INTO Order_Detail VALUES
(1, 1, 1, 1, 5000.00),
(2, 1, 2, 1, 3000.00),
(3, 1, 3, 1, 150.00),
(4, 2, 3, 2, 300.00),
(5, 3, 4, 5, 1250.00),
(6, 4, 2, 1, 3000.00);

-- =====================================================
-- 3 Update / Stock Management Examples
-- =====================================================

-- Reduce stock when an order is made
UPDATE Product
SET stock = stock - 1
WHERE id = 1;

-- Update product price
UPDATE Product
SET price = 5200.00
WHERE id = 1;

-- Delete a product
DELETE FROM Product
WHERE id = 6;

-- Truncate table (delete all orders)
-- TRUNCATE TABLE Orders;

-- =====================================================
-- 4? Reporting / Analytics Queries
-- =====================================================

-- Top 5 customers by number of orders
SELECT C.id, C.first_name, C.last_name, COUNT(O.id) AS order_count
FROM Customer C
JOIN Orders O ON C.id = O.customer_id
GROUP BY C.id, C.first_name, C.last_name
ORDER BY order_count DESC
LIMIT 5;

-- Most sold products
SELECT P.id, P.name, SUM(OD.quantity) AS total_sold
FROM Product P
JOIN Order_Detail OD ON P.id = OD.product_id
GROUP BY P.id, P.name
ORDER BY total_sold DESC;

-- Sellers with highest revenue
SELECT S.id, S.name, SUM(OD.quantity * OD.price) AS revenue
FROM Seller S
JOIN Product P ON S.id = P.seller_id
JOIN Order_Detail OD ON P.id = OD.product_id
GROUP BY S.id, S.name
ORDER BY revenue DESC;

-- Customers per city
SELECT city, COUNT(*) AS customer_count
FROM Customer
GROUP BY city;

-- Total sales per category
SELECT C.name AS category, SUM(OD.quantity * OD.price) AS total_sales
FROM Category C
JOIN Product P ON C.id = P.category_id
JOIN Order_Detail OD ON P.id = OD.product_id
GROUP BY C.name;

-- Orders per month
SELECT MONTH(order_date) AS month, COUNT(*) AS order_count
FROM Orders
GROUP BY MONTH(order_date);

-- Order details with customer + product + seller info
SELECT O.id AS order_id, C.first_name AS customer_first_name, C.last_name AS customer_last_name,
       P.name AS product_name, OD.quantity, OD.price, S.name AS seller_name
FROM Orders O
JOIN Customer C ON O.customer_id = C.id
JOIN Order_Detail OD ON O.id = OD.order_id
JOIN Product P ON OD.product_id = P.id
JOIN Seller S ON P.seller_id = S.id;

-- Products never sold
SELECT P.id, P.name
FROM Product P
LEFT JOIN Order_Detail OD ON P.id = OD.product_id
WHERE OD.id IS NULL;

-- Customers who never ordered
SELECT C.id, C.first_name, C.last_name
FROM Customer C
LEFT JOIN Orders O ON C.id = O.customer_id
WHERE O.id IS NULL;
