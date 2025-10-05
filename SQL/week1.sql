-- =====================================
-- SQL Library Inventory Project
-- Table: books
-- Purpose: Practice SELECT, WHERE, BETWEEN, IN, LIKE, ORDER BY, LIMIT
-- =====================================

-- 1️ Create Table
CREATE TABLE books (
    book_id INT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    author VARCHAR(100) NOT NULL,
    genre VARCHAR(50),
    price DECIMAL(6,2) CHECK (price >= 0),
    stock_qty INT CHECK (stock_qty >= 0),
    published_year INT CHECK (published_year BETWEEN 1900 AND 2025),
    added_at DATE
);

-- 2️ Insert Data
INSERT INTO books (book_id, title, author, genre, price, stock_qty, published_year, added_at) VALUES
(1, 'In Search of Lost Time', 'M. Proust', 'novel', 129.90, 25, 1913, '2025-08-20'),
(2, 'The Alchemist', 'P. Coelho', 'novel', 89.50, 40, 1988, '2025-08-21'),
(3, 'Sapiens', 'Y. N. Harari', 'history', 159.00, 18, 2011, '2025-08-25'),
(4, 'Memed, My Hawk', 'Y. Kemal', 'novel', 99.90, 12, 1955, '2025-08-22'),
(5, 'Blindness', 'J. Saramago', 'novel', 119.00, 7, 1995, '2025-08-28'),
(6, 'Dune', 'F. Herbert', 'science', 149.00, 30, 1965, '2025-09-01'),
(7, 'Animal Farm', 'G. Orwell', 'novel', 79.90, 55, 1945, '2025-08-23'),
(8, '1984', 'G. Orwell', 'novel', 99.00, 35, 1949, '2025-08-24'),
(9, 'The Speech (Nutuk)', 'M. K. Atatürk', 'history', 139.00, 20, 1927, '2025-08-27'),
(10, 'The Little Prince', 'A. de Saint-Exupéry', 'children', 69.90, 80, 1943, '2025-08-26'),
(11, 'Origin', 'D. Brown', 'novel', 109.00, 22, 2017, '2025-09-02'),
(12, 'Atomic Habits', 'J. Clear', 'self-development', 129.00, 28, 2018, '2025-09-03'),
(13, 'A Brief History of Time', 'S. Hawking', 'science', 119.50, 16, 1988, '2025-08-29'),
(14, 'The Orange Marmalade', 'J. M. de Vasconcelos', 'novel', 84.90, 45, 1968, '2025-08-30'),
(15, 'The Last Day of a Condemned Man', 'V. Hugo', 'novel', 74.90, 26, 1829, '2025-08-31');

-- =====================================
-- 3️ Queries
-- =====================================

-- 1. List all books with title, author, price sorted by ascending price
SELECT title, author, price
FROM books
ORDER BY price ASC;

-- 2. Show books with genre 'novel' A→Z by title
SELECT title, author, genre
FROM books
WHERE genre = 'novel'
ORDER BY title ASC;

-- 3. List books with price between 80 and 120 inclusive
SELECT title, author, price
FROM books
WHERE price BETWEEN 80 AND 120;

-- 4. Find books with stock less than 20
SELECT title, stock_qty
FROM books
WHERE stock_qty < 20;

-- 5. Filter books whose title contains 'time' (case-insensitive in MySQL)
SELECT *
FROM books
WHERE title LIKE '%time%';

-- 6. List books with genre 'novel' or 'science' using IN
SELECT title, author, genre
FROM books
WHERE genre IN ('novel', 'science');

-- 7. Books published in 2000 or later, sorted newest first
SELECT title, author, published_year
FROM books
WHERE published_year >= 2000
ORDER BY published_year DESC;

-- 8. Books added in the last 10 days
SELECT title, added_at
FROM books
WHERE added_at >= DATE_SUB(CURDATE(), INTERVAL 10 DAY);

-- 9. Top 5 most expensive books
SELECT title, author, price
FROM books
ORDER BY price DESC
LIMIT 5;

-- 10. Books with stock between 30 and 60, sorted by ascending price
SELECT title, stock_qty, price
FROM books
WHERE stock_qty BETWEEN 30 AND 60
ORDER BY price ASC;
