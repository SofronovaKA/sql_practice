-- Общие задания

-- Задание 1.1. Базовый поиск (Salespeople). Женщины-продавцы (первые 10 нанятых)
SELECT username
FROM salespeople
WHERE gender = 'F'  -- или 'Female', зависит от данных
ORDER BY hire_date
LIMIT 10;

-- Мужчины-продавцы (первые 10 нанятых)
SELECT username
FROM salespeople
WHERE gender = 'M'  -- или 'Male'
ORDER BY hire_date
LIMIT 10;

-- Задание 1.2. Работа с клиентами (Customers). Email клиентов из Флориды (FL), сортировка по алфавиту
SELECT email
FROM customers
WHERE state = 'FL'
ORDER BY email;

-- Имя, фамилия, email клиентов из Нью-Йорка (NYC, NY)
SELECT first_name, last_name, email
FROM customers
WHERE city = 'New York City' AND state = 'NY'
ORDER BY last_name, first_name;

-- Все клиенты с телефонами, сортировка по дате добавления
SELECT *
FROM customers
ORDER BY date_added;

-- Задание 1.3. Операции CRUD.
-- 1. CREATE — создание таблицы customers_nyc с данными клиентов из города New York City (штат NY)
CREATE TABLE customers_nyc AS
SELECT *
FROM customers_nyc
WHERE city = 'New York City';

-- 2. ALTER — добавление текстового столбца event
ALTER TABLE customers_nyc
ADD COLUMN event TEXT;

-- 3. UPDATE — заполните столбец event значением 'thank-you party' через удаление данных 
UPDATE customers_nyc
SET event = 'thank-you party';

-- 4. DELETE — удаление из новой таблицы клиентов с индексом 10014 
DELETE FROM customers_nyc
WHERE postal_code = '10014';

-- Проверка
SELECT customer_id, first_name, last_name, city, postal_code, event 
FROM customers_nyc 
LIMIT 15;

-- Самостоятельная работа

-- Задание 1. Клиенты из города Chicago. Сортировка: индекс (postal_code)
SELECT *
FROM customers
WHERE city = 'Chicago'
ORDER BY postal_code;

-- Задание 2. Продажи с NULL в поле dealership_id
SELECT *
FROM sales
WHERE dealership_id IS NULL;

-- Задание 3. Операции CRUD.
-- 1. CREATE — создание таблицы emails_click на основе данных из emails
CREATE TABLE emails_click AS
SELECT *
FROM emails;

-- 2. ALTER — добавление столбца score
ALTER TABLE emails_click
ADD COLUMN score INTEGER;

-- 3. UPDATE — заполнение score значением 10
UPDATE emails_click
SET score = 10;

-- 4. DELETE — удаление записей, где clicked_date раньше 2012 года
DELETE FROM emails_click
WHERE EXTRACT(YEAR FROM clicked_date) < 2012;

-- Проверка
SELECT * FROM emails_click LIMIT 15;
