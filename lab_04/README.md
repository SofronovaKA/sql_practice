# Лабораторная работа 4. Оконные функции для анализа данных

**Вариант:** 17 

**Выполнила:** Софронова Кира 

**Группа:** ЦИБ-241

---

## Описание работы

Цель работы — освоить оконные функции SQL для решения аналитических задач: нумерация строк, расчет разниц между значениями (LAG), скользящие окна с агрегацией.

---

# Индивидуальные задания

## Задание 1. Нумерация писем для каждого клиента

### Условие
Пропулировать письма (emails) для каждого клиента по дате отправки.

### Решение
```sql
SELECT 
    customer_id,
    email_id,
    sent_date,
    email_subject,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY sent_date) AS email_rank
FROM emails
ORDER BY customer_id, sent_date
LIMIT 10;
```

### Результат выполнения  

![Скриншот](./lab_04/images_lab_04/task_1.jpg)

## Задание 2. Разница в датах открытия дилерских центров внутри штата

### Условие 

Вывести разницу в датах открытия (date_opened) дилерских центров внутри одного штата (используя LAG).

### Решение

```sql
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
LIMI 10;
```

### Результат выполнения

![Скриншот](./lab_04/images_lab_04/task_2.jpg)

## Задание 3. Максимальная цена продажи в скользящем окне

### Условие
Рассчитать максимальную цену продажи в скользящем окне (текущая и 4 предыдущих) для каждого продукта.

### Решение
```sql
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
```

### Результат выполнения

![Скриншот](./lab_04/images_lab_04/task_3.jpg)

# Вывод
В ходе выполнения лабораторной работы были освоены следующие оконные функции SQL:

* `ROW_NUMBER()` — для нумерации строк в группе;
* `LAG()` — для доступа к предыдущему значению;
* `MAX()` в оконном контексте — для скользящего максимума;
* `RANK()` — для ранжирования;
* `COUNT()` с `OVER()` — для накопительных итогов;
* `AVG()` с `ROWS BETWEEN` — для скользящего среднего.

Все запросы протестированы в pgAdmin.
