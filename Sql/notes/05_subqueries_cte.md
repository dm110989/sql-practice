# 📊 SQL: подзапросы, EXISTS, CTE, UNION

---

## 📌 1. Подзапросы (Subqueries)

👉 подзапрос = `SELECT` внутри другого запроса  

Может использоваться:

- в `WHERE` → одно значение или список  
- в `SELECT` → одно значение на строку  
- в `FROM` → временная таблица  
- в `JOIN` → таблица для соединения  

---

## 📌 2. Подзапрос в WHERE (одно значение)

```sql
SELECT
  order_id,
  price
FROM orders
WHERE price > (
  SELECT AVG(price)
  FROM orders
);
```

👉 сначала считается подзапрос → потом сравнение  

Пример:

```
AVG = 500
price: 300, 700
result: 700
```

---

## 📌 3. Подзапрос в WHERE (IN)

```sql
SELECT *
FROM customers
WHERE customer_id IN (
  SELECT customer_id
  FROM orders
);
```

👉 проверяет: входит ли значение в список  

---

## 📌 4. EXISTS

```sql
SELECT *
FROM customers c
WHERE EXISTS (
  SELECT 1
  FROM orders o
  WHERE o.customer_id = c.customer_id
);
```

👉 проверяет: есть ли хотя бы одна строка  

---

### Пример

```sql
SELECT *
FROM products p
WHERE EXISTS (
  SELECT 1
  FROM order_items oi
  WHERE oi.product_id = p.product_id
);
```

---

### Важно

```sql
EXISTS (SELECT 1 FROM ...)
```

❌ так нельзя:

```sql
EXISTS (p.product_id = oi.product_id)
```

---

## 📌 5. NOT EXISTS

```sql
SELECT *
FROM customers c
WHERE NOT EXISTS (
  SELECT 1
  FROM orders o
  WHERE o.customer_id = c.customer_id
);
```

👉 нет ни одной строки  

---

## 📌 6. EXISTS vs IN

```sql
-- IN
WHERE id IN (SELECT id FROM table)

-- EXISTS
WHERE EXISTS (SELECT 1 FROM table WHERE ...)
```

Разница:

- IN → проверяет значение по списку  
- EXISTS → проверяет наличие строки  

👉 EXISTS быстрее на больших данных  

---

## 📌 7. Подзапрос в SELECT

```sql
SELECT
  c.customer_id,
  c.customer_name,
  (
    SELECT COUNT(*)
    FROM orders o
    WHERE o.customer_id = c.customer_id
  ) AS orders_cnt
FROM customers c;
```

👉 возвращает одно значение на строку  

👉 коррелированный подзапрос (зависит от строки)

---

## 📌 8. Подзапрос в FROM

```sql
SELECT
  city_stats.customer_city,
  city_stats.orders_cnt
FROM (
  SELECT
    customer_city,
    COUNT(*) AS orders_cnt
  FROM orders
  GROUP BY customer_city
) AS city_stats
WHERE city_stats.orders_cnt > 10;
```

👉 создаёт временную таблицу  

👉 псевдоним обязателен  

---

## 📌 9. Подзапрос в JOIN

```sql
SELECT
  c.customer_id,
  c.customer_name,
  s.orders_cnt
FROM customers c
LEFT JOIN (
  SELECT
    customer_id,
    COUNT(*) AS orders_cnt
  FROM orders
  GROUP BY customer_id
) AS s
  ON c.customer_id = s.customer_id;
```

👉 сначала считаем → потом JOIN  

---

## 📌 10. Когда что использовать

- SELECT → одно значение  
- JOIN → присоединить таблицу  
- EXISTS → проверить наличие  
- IN → проверить список  
- CTE → разбить на шаги  

---

## 📌 11. WITH (CTE)

```sql
WITH city_stats AS (
  SELECT
    customer_city,
    COUNT(*) AS cnt
  FROM orders
  GROUP BY customer_city
)
SELECT
  customer_city,
  cnt
FROM city_stats;
```

👉 временная именованная таблица  

---

### Пример с шагами

```sql
WITH orders_per_customer AS (
  SELECT
    customer_id,
    COUNT(*) AS orders_cnt,
    AVG(price) AS avg_price
  FROM orders
  GROUP BY customer_id
)
SELECT
  customer_id,
  orders_cnt,
  avg_price
FROM orders_per_customer
WHERE orders_cnt >= 3;
```

👉 сначала считаем → потом фильтруем  

---

## 📌 12. UNION / INTERSECT / EXCEPT

### UNION

```sql
SELECT customer_id FROM customer_actions
UNION
SELECT customer_id FROM customers;
```

👉 объединяет без дублей  

---

### UNION ALL

```sql
UNION ALL
```

👉 быстрее, сохраняет дубли  

---

### INTERSECT

```sql
INTERSECT
```

👉 только общие строки  

---

### EXCEPT

```sql
EXCEPT
```

👉 строки из первого, которых нет во втором  

---

### Важно

- одинаковое количество столбцов  
- одинаковый порядок  
- совместимые типы  

---

### Пример

```
A: 1,2,3
B: 3,4

UNION     → 1,2,3,4
UNION ALL → 1,2,3,3,4
INTERSECT → 3
EXCEPT    → 1,2
```

---

## Что запомнить

- подзапрос = SELECT внутри SELECT  
- EXISTS → проверка наличия  
- IN → проверка списка  
- CTE → разбить запрос на шаги  
- UNION → объединение  