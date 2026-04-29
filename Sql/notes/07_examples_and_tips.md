# 📊 SQL: примеры и практические советы

---

## 📌 1. Мини-примеры (частые задачи)

### 1. Выбрать нужные столбцы

```sql
SELECT
  order_id,
  price
FROM orders;
```

---

### 2. Отфильтровать дорогие заказы

```sql
SELECT
  order_id,
  price
FROM orders
WHERE price > 1000;
```

---

### 3. Отсортировать

```sql
SELECT
  order_id,
  price
FROM orders
WHERE price > 1000
ORDER BY price DESC;
```

---

### 4. Заменить NULL

```sql
SELECT
  order_id,
  COALESCE(customer_city, 'неизвестно') AS city_final
FROM orders;
```

---

### 5. CASE

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

---

### 6. Достать месяц

```sql
SELECT
  order_id,
  created_at,
  DATE_PART('month', created_at) AS order_month
FROM orders;
```

---

### 7. GROUP BY

```sql
SELECT
  customer_city,
  COUNT(*) AS orders_cnt
FROM orders
GROUP BY customer_city;
```

---

### 8. HAVING

```sql
SELECT
  customer_city,
  COUNT(*) AS orders_cnt
FROM orders
GROUP BY customer_city
HAVING COUNT(*) > 10;
```

---

### 9. JOIN

```sql
SELECT
  o.order_id,
  o.price,
  c.customer_name
FROM orders o
JOIN customers c
  ON o.customer_id = c.customer_id;
```

---

### 10. EXISTS

```sql
SELECT *
FROM customers c
WHERE EXISTS (
  SELECT 1
  FROM orders o
  WHERE o.customer_id = c.customer_id
);
```

---

### 11. Подзапрос в SELECT

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

---

### 12. Подзапрос в JOIN

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

---

### 13. CTE

```sql
WITH orders_per_customer AS (
  SELECT
    customer_id,
    COUNT(*) AS orders_cnt
  FROM orders
  GROUP BY customer_id
)
SELECT
  c.customer_id,
  c.customer_name,
  opc.orders_cnt
FROM customers c
LEFT JOIN orders_per_customer opc
  ON c.customer_id = opc.customer_id;
```

---

### 14. Ранжирование

```sql
SELECT
  customer_id,
  order_id,
  price,
  ROW_NUMBER() OVER (
    PARTITION BY customer_id
    ORDER BY price DESC
  ) AS rn
FROM orders;
```

---

### 15. LAG

```sql
SELECT
  customer_id,
  order_id,
  created_at,
  price,
  LAG(price) OVER (
    PARTITION BY customer_id
    ORDER BY created_at
  ) AS prev_price
FROM orders;
```

---

## 📌 2. Частые ошибки

### WHERE vs HAVING

```
WHERE  → до GROUP BY  
HAVING → после GROUP BY  
```

---

### COUNT(*) vs COUNT(column)

```
COUNT(*)      → все строки  
COUNT(column) → без NULL  
```

---

### LEFT vs INNER JOIN

```
INNER → только совпадения  
LEFT  → всё слева + NULL  
```

---

### IN vs EXISTS

```
IN     → проверка по списку  
EXISTS → проверка наличия  
```

---

### Подзапрос SELECT vs JOIN

```
SELECT → одно значение  
JOIN   → таблица  
```

---

### GROUP BY vs WINDOW

```
GROUP BY → схлопывает строки  
WINDOW   → добавляет значения  
```

---

### Дубли после JOIN

👉 это часто нормально  

Причина:

```
разная гранулярность
```

---

### ROW_NUMBER vs RANK vs DENSE_RANK

```
ROW_NUMBER  → 1,2,3,4  
RANK        → 1,2,2,4  
DENSE_RANK  → 1,2,2,3  
```

---

## 📌 3. Как решать задачи

```
простая выборка → SELECT + WHERE  

агрегат → GROUP BY  

фильтр по агрегату → HAVING  

объединение → JOIN  

сравнение с агрегатом → подзапрос  

проверка наличия → EXISTS  

промежуточный шаг → CTE  

расчёт без потери строк → WINDOW  

топ-N → ROW_NUMBER + фильтр  

дубли после JOIN → проверь гранулярность  
```

---

## 📌 4. Памятка по подзапросам

```
SELECT → одно значение  

WHERE  → значение / список / EXISTS  

FROM   → временная таблица  

JOIN   → таблица для соединения  
```

---

## Что запомнить

- SQL = конструктор из блоков  
- WHERE ≠ HAVING  
- JOIN может дублировать строки  
- EXISTS — мощнее IN  
- WINDOW — для сложных задач  