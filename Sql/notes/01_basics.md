# 📊 SQL: базовый синтаксис, псевдонимы, сортировка, фильтрация

---

## 📌 1. Базовый синтаксис

### Выбрать все столбцы

```sql
SELECT *
FROM orders;
```

---

### Выбрать нужные столбцы

```sql
SELECT
  order_id,
  customer_id,
  price
FROM orders;
```

---

### Убрать дубликаты

```sql
SELECT DISTINCT customer_city
FROM orders;
```

---

### Ограничить количество строк

```sql
SELECT *
FROM orders
LIMIT 10;
```

---

## 📌 2. Псевдонимы aliases

### Переименовать столбец

```sql
SELECT
  price AS total_price
FROM orders;
```

---

### Короткое имя таблицы

```sql
SELECT
  o.order_id,
  o.price
FROM orders AS o;
```

---

### Алиасы таблиц часто используют в JOIN

```sql
SELECT
  o.order_id,
  c.customer_id
FROM orders o
JOIN customers c
  ON o.customer_id = c.customer_id;
```

---

## 📌 3. Сортировка

### По возрастанию

```sql
SELECT
  order_id,
  price
FROM orders
ORDER BY price ASC;
```

---

### По убыванию

```sql
SELECT
  order_id,
  price
FROM orders
ORDER BY price DESC;
```

---

### По нескольким полям

```sql
SELECT
  order_id,
  customer_id,
  price
FROM orders
ORDER BY price DESC, order_id ASC;
```

---

## 📌 4. Фильтрация WHERE

### Простое условие

```sql
SELECT *
FROM orders
WHERE price > 1000;
```

---

### Фильтрация по строке

```sql
SELECT *
FROM customers
WHERE customer_city = 'Москва';
```

---

### Фильтрация по дате

```sql
SELECT *
FROM orders
WHERE created_at >= '2024-01-01';
```

---

### Несколько условий через AND

```sql
SELECT *
FROM orders
WHERE order_status = 'paid'
  AND price > 1000;
```

---

### Несколько условий через OR

```sql
SELECT *
FROM customers
WHERE customer_city = 'Москва'
   OR customer_city = 'Казань';
```

---

### Неравенство

```sql
SELECT *
FROM orders
WHERE order_status <> 'canceled';
```

👉 исключить строки с определённым значением

---

## 📌 5. Операторы в WHERE

### IN

```sql
SELECT *
FROM customers
WHERE customer_city IN ('Москва', 'Казань');
```

👉 значение входит в список

---

### BETWEEN

```sql
SELECT *
FROM orders
WHERE price BETWEEN 100 AND 500;
```

👉 диапазон, включает оба края

---

### LIKE

```sql
SELECT *
FROM customers
WHERE name LIKE 'A%';
```

👉 `%` означает любое количество символов

---

### LIKE с вхождением в строку

```sql
SELECT *
FROM customers
WHERE name LIKE '%abc%';
```

---

### ILIKE

```sql
SELECT *
FROM customers
WHERE name ILIKE '%иван%';
```

👉 поиск без учёта регистра, PostgreSQL

---

## 📌 6. NULL

### Значение отсутствует

```sql
SELECT *
FROM customers
WHERE customer_city IS NULL;
```

---

### Значение заполнено

```sql
SELECT *
FROM customers
WHERE customer_city IS NOT NULL;
```

---

### COALESCE

```sql
SELECT
  customer_id,
  COALESCE(customer_city, 'неизвестно') AS city_final
FROM customers;
```

👉 если значение `NULL`, подставить другое

Пример:

```text
customer_city: NULL, 'Москва'
result:        'неизвестно', 'Москва'
```

---

### NULLIF

```sql
SELECT
  NULLIF(a, b)
FROM some_table;
```

👉 если два значения равны — вернуть `NULL`

Пример:

```text
a, b:   0, 0
result: NULL
```

Часто используют для защиты от деления на 0.

---

### Важно

```sql
WHERE customer_city = NULL
```

❌ так нельзя

Правильно:

```sql
WHERE customer_city IS NULL
```

или:

```sql
WHERE customer_city IS NOT NULL
```

---

## 📌 7. Логика CASE WHEN

### Синтаксис

```sql
CASE
  WHEN условие THEN значение
  WHEN условие THEN значение
  ELSE значение
END
```

---

### Пример: разбить цену на категории

```sql
SELECT
  order_id,
  price,
  CASE
    WHEN price > 1000 THEN 'дорого'
    ELSE 'дёшево'
  END AS price_category
FROM orders;
```

Пример:

```text
price:  1500, 700
result: 'дорого', 'дёшево'
```

---

## Что запомнить

- `SELECT` — выбрать данные
- `FROM` — из какой таблицы
- `DISTINCT` — убрать дубликаты
- `LIMIT` — ограничить строки
- `AS` — псевдоним
- `ORDER BY` — сортировка
- `WHERE` — фильтрация
- `IN` — входит в список
- `BETWEEN` — диапазон
- `LIKE` / `ILIKE` — поиск по шаблону
- `IS NULL` — проверка на пустое значение
- `COALESCE` — заменить `NULL`
- `NULLIF` — вернуть `NULL`, если значения равны
- `CASE WHEN` — условная логика