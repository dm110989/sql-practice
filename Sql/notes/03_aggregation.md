# 📊 SQL: агрегации, GROUP BY, HAVING

---

## 📌 1. Агрегатные функции

```sql
COUNT(*)                -- все строки (включая NULL)
COUNT(column)           -- только НЕ NULL
COUNT(DISTINCT column)  -- уникальные НЕ NULL
SUM(x)                  -- сумма
AVG(x)                  -- среднее
MIN(x)                  -- минимум
MAX(x)                  -- максимум
```

👉 агрегаты «схлопывают» строки в одну  

---

### Пример

```sql
SELECT
  COUNT(*) AS orders_cnt,
  COUNT(DISTINCT customer_id) AS customers_cnt,
  SUM(price) AS total_sum,
  AVG(price) AS avg_price,
  MIN(price) AS min_price,
  MAX(price) AS max_price
FROM orders;
```

Пример:

```
price: 100, 200, 300
SUM = 600
AVG = 200
MIN = 100
MAX = 300
```

---

## 📌 2. FILTER (PostgreSQL)

```sql
COUNT(*) FILTER (WHERE условие)
```

👉 считать агрегат только по части строк  

---

### Пример

```sql
SELECT
  COUNT(*) AS total_orders,
  COUNT(*) FILTER (WHERE order_status = 'Delivered') AS delivered_orders
FROM orders;
```

---

```sql
SELECT
  SUM(price) FILTER (WHERE order_status = 'Delivered') AS delivered_sum
FROM orders;
```

Пример:

```
status: Delivered, Pending, Delivered
result: 2
```

---

## 📌 3. GROUP BY

👉 группирует строки  

---

### По одному столбцу

```sql
SELECT
  customer_city,
  COUNT(*) AS orders_cnt
FROM orders
GROUP BY customer_city;
```

---

### По нескольким столбцам

```sql
SELECT
  customer_city,
  order_status,
  COUNT(*) AS orders_cnt
FROM orders
GROUP BY customer_city, order_status;
```

---

Пример:

```
city: Москва, Москва, Казань
result:
Москва = 2
Казань = 1
```

---

## 📌 4. HAVING

👉 фильтрует группы после GROUP BY  

---

### Пример

```sql
SELECT
  customer_city,
  COUNT(*) AS orders_cnt
FROM orders
GROUP BY customer_city
HAVING COUNT(*) > 10;
```

---

```sql
SELECT
  customer_city,
  AVG(price) AS avg_price
FROM orders
GROUP BY customer_city
HAVING AVG(price) > 1000;
```

Пример:

```
Москва = 1200
Казань = 800

result: Москва
```

---

## 📌 WHERE vs HAVING

```text
WHERE  → фильтрует строки ДО группировки
HAVING → фильтрует группы ПОСЛЕ GROUP BY
```

---

## 📌 5. Порядок выполнения SQL

```text
FROM
JOIN
ON
WHERE
GROUP BY
HAVING
WINDOW
SELECT
ORDER BY
LIMIT
```

---

## Важно

- порядок выполнения ≠ порядок написания  

---

### Следствие

```text
нельзя использовать alias из SELECT в WHERE / HAVING
```

```sql
-- ❌
WHERE total_price > 1000
```

```sql
-- ✅
ORDER BY total_price
```

---

## Что запомнить

- COUNT / SUM / AVG → агрегаты  
- GROUP BY → группировка  
- HAVING → фильтр групп  
- FILTER → условие внутри агрегата  
- WHERE ≠ HAVING  
- SQL выполняется не сверху вниз  