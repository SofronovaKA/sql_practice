-- Практическая работа 1. Геопространственный анализ данных
-- Вариант 17
-- Задания: №1, №6, №16

-- Задание №1. Дни недели продаж
SELECT 
    TO_CHAR(sales_transaction_date, 'Day') AS day_of_week,
    EXTRACT(DOW FROM sales_transaction_date) AS day_number,
    COUNT(*) AS number_of_sales
FROM sales
GROUP BY day_of_week, day_number
ORDER BY number_of_sales DESC
LIMIT 1;

-- Задание №6. Ближайший дилер для клиентов из NYC
WITH customer_dealer_distance AS (
    SELECT 
        c.customer_id,
        c.first_name,
        c.last_name,
        d.dealership_id,
        d.state,
        point(c.longitude, c.latitude) <@> point(d.longitude, d.latitude) AS distance_miles,
        ROW_NUMBER() OVER (PARTITION BY c.customer_id ORDER BY 
            point(c.longitude, c.latitude) <@> point(d.longitude, d.latitude)) AS rn
    FROM customers c
    CROSS JOIN dealerships d
    WHERE c.city = 'New York City'
)
SELECT 
    customer_id,
    first_name,
    last_name,
    dealership_id,
    state,
    ROUND(distance_miles::numeric, 2) AS nearest_dealer_distance_miles
FROM customer_dealer_distance
WHERE rn = 1
ORDER BY distance_miles
LIMIT 10;

-- Задание №16. Топ-10 самых частых слов в отзывах
SELECT 
    LOWER(word) AS word,
    COUNT(*) AS frequency
FROM (
    SELECT 
        UNNEST(
            STRING_TO_ARRAY(
                REGEXP_REPLACE(feedback, '[^a-zA-Zа-яА-Я\s]', ' ', 'g'),
                ' '
            )
        ) AS word
    FROM customer_survey
    WHERE feedback IS NOT NULL
) AS words
WHERE LENGTH(word) >= 3
  AND word != ''
GROUP BY LOWER(word)
ORDER BY frequency DESC
LIMIT 10;
