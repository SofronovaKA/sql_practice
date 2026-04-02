-- ОБЩИЕ ЗАДАНИЯ

-- Задание 2.1. Поиск покупателей авто (INNER JOIN)
SELECT
    customers.customer_id, 
    customers.first_name, 
    customers.last_name, 
    customers.phone
FROM 
    sales
JOIN 
    customers ON sales.customer_id = customers.customer_id
JOIN 
    products ON sales.product_id = products.product_id
WHERE 
    customers.phone IS NOT NULL
    AND products.product_type = 'automobile';

-- Задание 2.2. Вечеринка в Лос-Анджелесе (UNION)
SELECT 
    first_name,
    last_name,
    'Customer' AS guest_type
FROM 
    customers
WHERE 
    city = 'Los Angeles'

UNION

SELECT 
    s.first_name,
    s.last_name,
    'Employee' AS guest_type
FROM 
    salespeople s
INNER JOIN 
    dealerships d ON s.dealership_id = d.dealership_id
WHERE 
    d.city = 'Los Angeles'

ORDER BY 
    last_name;

-- Задание 2.3. Создание витрины данных (Data Transformation)
SELECT 
    s.*,
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.phone,
    c.city,
    c.state,
    p.product_id,
    p.model,
    p.product_type,
    p.base_msrp,
    COALESCE(s.dealership_id, -1) AS dealership_id_clean,
    d.city AS dealership_city,
    d.state AS dealership_state,
    CASE 
        WHEN (p.base_msrp - s.sales_amount) > 500 THEN 1 
        ELSE 0 
    END AS high_savings
FROM 
    sales s
LEFT JOIN 
    customers c ON s.customer_id = c.customer_id
LEFT JOIN 
    products p ON s.product_id = p.product_id
LEFT JOIN 
    dealerships d ON s.dealership_id = d.dealership_id;

-- ИНДИВИДУАЛЬНЫЕ ЗАДАНИЯ

-- Задача 1. Использование JOIN (соединение 2-3 таблиц)
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    MAX(s.sales_transaction_date) AS last_purchase_date
FROM 
    customers c
LEFT JOIN 
    sales s ON c.customer_id = s.customer_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name
ORDER BY 
    c.customer_id;

-- Задача 2. Использование подзапросов или UNION
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.phone,
    c.city,
    c.state
FROM 
    customers c
WHERE 
    c.state = 'TX'
    AND NOT EXISTS (
        SELECT 1
        FROM sales s
        JOIN products p ON s.product_id = p.product_id
        WHERE s.customer_id = c.customer_id
          AND p.product_type = 'scooter'
    );

-- Задача 3. Преобразование данных (CASE, COALESCE, CAST)
SELECT 
    customer_id,
    first_name,
    last_name,
    state,
    -- CAST: преобразование в INTEGER
    CAST(latitude AS INTEGER) AS latitude_int,
    CAST(longitude AS INTEGER) AS longitude_int,
    -- COALESCE: замена NULL на 0
    COALESCE(CAST(latitude AS INTEGER), 0) AS latitude_clean,
    COALESCE(CAST(longitude AS INTEGER), 0) AS longitude_clean,
    -- CASE: категория по координатам
    CASE 
        WHEN latitude IS NULL OR longitude IS NULL THEN 'No coordinates'
        WHEN CAST(latitude AS INTEGER) > 0 AND CAST(longitude AS INTEGER) > 0 THEN 'NE Quadrant'
        WHEN CAST(latitude AS INTEGER) > 0 AND CAST(longitude AS INTEGER) < 0 THEN 'NW Quadrant'
        WHEN CAST(latitude AS INTEGER) < 0 AND CAST(longitude AS INTEGER) > 0 THEN 'SE Quadrant'
        WHEN CAST(latitude AS INTEGER) < 0 AND CAST(longitude AS INTEGER) < 0 THEN 'SW Quadrant'
        ELSE 'On axis'
    END AS quadrant
FROM 
    customers;
