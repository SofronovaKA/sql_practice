-- Задания варианта 17

-- Задание 1. Нумерация писем для каждого клиента.
SELECT 
    customer_id,
    email_id,
    sent_date,
    email_subject,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY sent_date) AS email_rank
FROM emails
ORDER BY customer_id, sent_date
LIMIT 10;

-- Задание 2. Разница в датах открытия дилерских центров внутри штата.
WITH dealerships_with_lag AS (
    SELECT 
        dealership_id,
        state,
        date_opened,
        LAG(date_opened) OVER (PARTITION BY state ORDER BY date_opened) AS prev_open_date
    FROM dealerships
    WHERE date_opened IS NOT NULL
)
SELECT 
    state,
    dealership_id,
    date_opened,
    prev_open_date,
    date_opened - prev_open_date AS days_diff
FROM dealerships_with_lag
WHERE prev_open_date IS NOT NULL
ORDER BY state, date_opened
LIMIT 10;

-- Задание 3. Максимальная цена продажи в скользящем окне.
SELECT 
    product_id,
    sales_transaction_date,
    sales_amount,
    MAX(sales_amount) OVER (
        PARTITION BY product_id 
        ORDER BY sales_transaction_date 
        ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
    ) AS max_price_window
FROM sales
ORDER BY product_id, sales_transaction_date
LIMIT 10;
