-- Индивидуальные задания. Вариант 17.

-- Задание 1.1. Поиск продажи (sales), где sales_amount < 100.

-- БЕЗ ИНДЕКСА
EXPLAIN ANALYZE
SELECT * FROM sales WHERE sales_amount < 100;

-- С ИНДЕКСОМ

-- Задание 1.2. Оптимизация запроса локально (создание индекса B-Tree)

-- Шаг 1. Создание индекса в локальной базе
CREATE INDEX idx_sales_amount ON sales(sales_amount);

-- Шаг 2. Повторный анализ с индексом
EXPLAIN ANALYZE
SELECT * FROM sales WHERE sales_amount < 100;

-- Шаг 3. Очистка (после проверки)
DROP INDEX idx_sales_amount;

-- Задание 2.1. Оптимизация поиска клиентов по ip_address

-- БЕЗ ИНДЕКСА
EXPLAIN ANALYZE
SELECT * FROM customers WHERE ip_address = '123.45.67.89';

-- С ИНДЕКСОМ

-- Задание 2.2. Оптимизация поиска клиентов по ip_address

-- Шаг 1. Создание индекса на ip_address (подойдёт B-Tree, т.к. поле уникальное или почти уникальное)
CREATE INDEX idx_customers_ip_address ON customers(ip_address);

-- Шаг 2. Повторный анализ
EXPLAIN ANALYZE
SELECT * FROM customers WHERE ip_address = '123.45.67.89';

-- Шаг 3. Очистка
DROP INDEX idx_customers_ip_address;
