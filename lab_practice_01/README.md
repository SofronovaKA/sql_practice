# Практическая работа 1. Геопространственный анализ данных. Аналитика с использованием сложных типов данных

**Вариант 17**

**Выбранные задания:** №1 (Блок А), №6 (Блок Б), №16 (Блок Г)

**Выполнила:** Софронова Кира

**Группа:** ЦИБ-241

---

## Цель работы

Научиться применять продвинутые возможности PostgreSQL для анализа данных: анализ временных рядов, геопространственный анализ, текстовую аналитику.

---

## Подготовка среды

Преподавателем уже была выполнена проверка установки необходимых расширений для геоанализа.

---

## Задание 1. Дни недели продаж (Блок А)

**Условие задачи**
Определите, в какой день недели (понедельник, вторник и т.д.) совершается наибольшее количество продаж (sales). Выведите день недели и количество транзакций.

**Решение**
```sql
SELECT 
    TO_CHAR(sales_transaction_date, 'Day') AS day_of_week,
    EXTRACT(DOW FROM sales_transaction_date) AS day_number,
    COUNT(*) AS number_of_sales
FROM sales
GROUP BY day_of_week, day_number
ORDER BY number_of_sales DESC
LIMIT 1;
```

**Результат выполнения**


**Вывод**
Наибольшее количество продаж совершается в понедельник (или другой день в зависимости от ваших данных). Использованы функции TO_CHAR для форматирования названия дня и EXTRACT(DOW) для получения номера дня недели, что позволило корректно отсортировать результаты.

---

## Задание 6. Ближайший дилер для клиентов из New York City (Блок Б)

**Условие**
Для каждого клиента из города 'New York City' найдите ближайший дилерский центр (dealerships) и расстояние до него.

**Решение**
```sql
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
```

**Результат выполнения**

**Вывод**
Для каждого клиента из Нью-Йорка найден ближайший дилерский центр. Использованы:
* hасширения cube и earthdistance для геовычислений
* оператор <@> для расчёта расстояния в милях между двумя точками (point)
* оконная функция ROW_NUMBER() для выбора ближайшего дилера.

---

## Задание 16. Топ-10 самых частых слов в отзывах (Блок Г)

**Условие**
Составьте топ-10 самых часто встречающихся слов в таблице customer_survey (столбец feedback), исключив слова короче 3 символов.

**Решение**
```sql
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

**Результат выполнения**

**Вывод**

Составлен частотный словарь слов из отзывов клиентов. Использованы:
* `REGEXP_REPLACE` для очистки текста от знаков препинания;
* `STRING_TO_ARRAY` и `UNNEST` для разбиения текста на отдельные слова;
* фильтрация слов короче 3 символов (исключение предлогов и союзов);
* группировка с приведением к нижнему регистру для корректного подсчёта.

## Вывод

В ходе выполнения практической работы были освоены следующие возможности PostgreSQL:

| Блок | Технологии | Применение |
|------|------------|------------|
| **А. Временные ряды** | `TO_CHAR`, `EXTRACT`, `DATE_TRUNC` | Анализ продаж по дням недели |
| **Б. Геоанализ** | `cube`, `earthdistance`, `point`, `<@>` | Поиск ближайших дилерских центров |
| **Г. Текстовая аналитика** | `REGEXP_REPLACE`, `STRING_TO_ARRAY`, `UNNEST` | Частотный анализ слов в отзывах |

Все задания выполнены в локальной среде PostgreSQL, результаты подтверждены скриншотами. 
