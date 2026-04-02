-- Задание 1. Общее количество проданных единиц товара
SELECT 
    COUNT(*) AS total_units_sold
FROM 
    sales;

-- Задание 2. Группировка продаж по channel и dealership_id
SELECT 
    channel,
    dealership_id,
    SUM(sales_amount) AS total_sales_amount
FROM 
    sales
GROUP BY 
    channel,
    dealership_id
ORDER BY 
    channel,
    dealership_id;

-- Задание 3. Штаты, где клиентов-мужчин больше 100
SELECT 
    state,
    COUNT(*) AS male_customers_count
FROM 
    customers
WHERE 
    gender = 'M'
    AND state IS NOT NULL
GROUP BY 
    state
HAVING 
    COUNT(*) > 100
ORDER BY 
    male_customers_count DESC;
