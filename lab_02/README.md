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
