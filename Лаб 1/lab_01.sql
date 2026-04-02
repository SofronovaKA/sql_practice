Создание таблицы и наполнение данными:

CREATE TABLE customers (
    index INTEGER,
    customer_id VARCHAR(50),
    title VARCHAR(10),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    suffix VARCHAR(10),
    email VARCHAR(100),
    gender VARCHAR(10),
    ip_address VARCHAR(20),
    phone VARCHAR(20),
    street_address VARCHAR(200),
    city VARCHAR(50),
    state VARCHAR(2),
    postal_code VARCHAR(10),
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    date_added DATE
);

INSERT INTO customers (customer_id, first_name, last_name, email, city, state, date_added) VALUES
(10014, 'John', 'Smith', 'john@example.com', 'New York City', 'NY', '2023-01-01'),
(10015, 'Jane', 'Doe', 'jane@example.com', 'New York City', 'NY', '2023-01-02'),
(10016, 'Bob', 'Johnson', 'bob@example.com', 'Los Angeles', 'CA', '2023-01-03');

Удаление клиентов с индексом 10014:

DELETE FROM customers_rus
WHERE customer_id = 10014;

Добавление текстового столбца event:

ALTER TABLE customers_rus
ADD COLUMN event TEXT;

Добавление данных в столбец event:

UPDATE customers_rus
SET event = 'thank-you party';

Обновление столбца event:

UPDATE customers_rus
SET event = 'thank-you party';

Задание 1: Клиенты (customers) из города 'Chicago'. Сортировка: индекс.

SELECT *
FROM customers
WHERE city = 'Chicago'
ORDER BY index ASC;  -- или ORDER BY customer_id ASC, если колонки index нет

Задание 2: Продажи (sales) с NULL в поле dealership_id.

SELECT *
FROM sales
WHERE dealership_id IS NULL;

Задание 3: Таблица emails_click (письма с кликами). Добавить score=10. Удалить старые (<2012).

Создание таблицы emails_click:

CREATE TABLE emails_click (
    id SERIAL PRIMARY KEY,
    email VARCHAR(100),
    click_date DATE,
    score INTEGER
);

Добавление текстовых данных:

INSERT INTO emails_click (email, click_date, score) VALUES
('user1@example.com', '2010-05-10', NULL),
('user2@example.com', '2011-08-15', NULL),
('user3@example.com', '2015-03-20', NULL),
('user4@example.com', '2016-07-25', NULL),
('user5@example.com', '2018-01-30', NULL);


Добавление score = 10 (для всех писем с кликами):

UPDATE emails_click
SET score = 10;

Удаление старых записей (< 2012 года):

DELETE FROM emails_click
WHERE click_date < '2012-01-01';
