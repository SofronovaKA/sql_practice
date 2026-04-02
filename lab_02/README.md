# Лабораторная работа №2. Использование соединений (JOIN), подзапросов и функций преобразования данных.
**Вариант:** 17  
**Выполнила:** Софронова Кира

---

## Описание лабораторной работы

В рамках данной работы были выполнены **3 общих задания** (для всех вариантов) и **3 индивидуальных задания**.

### Общие задания:
- **2.1.** Поиск покупателей авто (INNER JOIN)
- **2.2.** Вечеринка в Лос-Анджелесе (UNION)
- **2.3.** Создание витрины данных (Data Transformation)

### Индивидуальные задания:
- **1.** Использование JOIN (список клиентов и дата последней покупки)
- **2.** Использование подзапросов (клиенты из TX, которые не покупали scooter)
- **3.** Преобразование данных (CAST, COALESCE, CASE для координат)

---

# ОБЩИЕ ЗАДАНИЯ

## Задание 2.1. Поиск покупателей авто (INNER JOIN)

### Текст задания

> Получить контактные данные всех клиентов, купивших автомобиль, для обзвона.  
> Использовать таблицы `sales`, `customers`, `products`.  
> Условия: `product_type = 'automobile'`, `phone IS NOT NULL`.  
> Вывести: `customer_id`, `first_name`, `last_name`, `phone`.

### SQL-запрос

```sql
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
```

### Пояснение логики

- Использован `INNER JOIN` (можно писать просто JOIN), так как нужны только те продажи, у которых есть и клиент, и продукт.
- Соединены три таблицы: `sales (центр)`, `customers (по customer_id)`, `products (по product_id)`.
- Условие `phone IS NOT NULL` отсекает клиентов без номера телефона.
- Условие `product_type = 'automobile'` оставляет только продажи автомобилей (не скутеров и т.д.).

## Задание 2.2. Вечеринка в Лос-Анджелесе (UNION)

### Текст задания
> Составить список приглашённых на мероприятие: клиенты И сотрудники из Лос-Анджелеса.
> Добавить поле guest_type ('Customer' или 'Employee').

### SQL-запрос

```sql
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
```

### Пояснение логики

- UNION объединяет результаты двух запросов, удаляя дубликаты (если один и тот же человек является и клиентом, и сотрудником).
- Первый запрос выбирает клиентов с `city = 'Los Angeles'`, добавляя метку `'Customer'`.
- Второй запрос выбирает сотрудников (`salespeople`), работающих в дилерских центрах (`dealerships`) с `city = 'Los Angeles'`, добавляя метку `'Employee'`.
- `ORDER BY last_name` сортирует итоговый список по фамилии.

## Задание 2.3. Создание витрины данных (Data Transformation)

### Текст задания

> Подготовить "плоскую" таблицу для аналитиков.
> Соединить sales, customers, products, dealerships (LEFT JOIN).
> Заменить NULL в dealership_id на -1 (COALESCE).
> Создать признак high_savings: 1, если (base_msrp - sales_amount) > 500, иначе 0.

### SQL-запрос

```sql
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
```

### Пояснение логики

- `LEFT JOIN` выбран, чтобы сохранить все продажи, даже если нет соответствующего клиента, продукта или дилера.
- `COALESCE(s.dealership_id, -1)` заменяет `NULL` на -1 — это стандартный приём для обозначения "нет дилера" в аналитических витринах.
- `CASE WHEN ... THEN 1 ELSE 0 END` создаёт бинарный признак `high_savings`. Экономия `> 500` означает, что клиент получил значительную скидку относительно рекомендованной цены (`base_msrp`).

# ИНДИВИДУАЛЬНЫЕ ЗАДАНИЯ

## Задание 1. Использование JOIN (соединение 2-3 таблиц)

### Текст задания

> Вывести список клиентов и дату их последней покупки.
> Использовать customers и sales.
> Результат: customer_id, first_name, last_name, last_purchase_date.
> Отсортировать по customer_id.

### SQL-запрос

```sql
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
```

### Пояснение логики

- Выбран `LEFT JOIN`, чтобы включить всех клиентов, даже если у них не было покупок (тогда `last_purchase_date` будет `NULL`).
- `MAX(sales_transaction_date)` – определяет дату самой последней покупки для каждого клиента.
- `GROUP BY` по идентификатору и имени клиента обязателен, так как используются агрегатная функция и обычные столбцы.
- Сортировка по `customer_id` упрощает чтение результата.

## Задание 2. Использование подзапросов или UNION

### Текст задания

> Найти клиентов из штата 'TX', которые ни разу не покупали товар с типом 'scooter'.
> Вывести: customer_id, first_name, last_name, email, phone, city, state.

### SQL-запрос (вариант с NOT EXISTS)

```sql
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
```

### Пояснение логики

- Использован `NOT EXISTS`, так как он работает эффективнее `NOT IN` при наличии `NULL` во вложенном запросе и лучше читается для проверки отсутствия связанных записей.
- Внутренний запрос ищет продажи скутеров для текущего клиента.
- Если таких продаж нет – клиент включается в результат.
- Фильтр по `state = 'TX'` применяется во внешнем запросе.

## Задание 3. Преобразование данных (CASE, COALESCE, CAST)

### Текст задания

> Преобразовать координаты клиентов (latitude, longitude) в целые числа.
> Добавить обработку NULL (заменить на 0).
> Создать категорию (CASE) по квадранту координат.

### SQL-запрос

```sql
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
```

### Пояснение логики

- CAST( ... AS INTEGER) – приводит вещественные координаты к целому типу (отбрасывает дробную часть).
- COALESCE( ... , 0) – заменяет NULL на 0, чтобы избежать ошибок при последующем анализе.
- CASE – создаёт категорию квадранта на основе знаков широты и долготы. Это пример feature engineering для географического анализа.
- Отдельная ветка WHEN latitude IS NULL OR longitude IS NULL обрабатывает отсутствие данных.

# Вывод

В ходе лабораторной работы были выполнены все 3 общих и 3 индивидуальных задания. Отработаны навыки:
* соединения таблиц через INNER JOIN и LEFT JOIN;
* объединения результатов через UNION;
* использования подзапросов с NOT EXISTS;
* преобразования и обогащения данных через CAST, COALESCE, CASE;
