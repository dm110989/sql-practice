# 📊 SQL: JOIN — объединение таблиц

---

## 📌 1. Виды JOIN

### INNER JOIN

```sql
SELECT
  c.customer_id,
  c.customer_name,
  o.order_id,
  o.price
FROM customers c
INNER JOIN orders o
  ON c.customer_id = o.customer_id;
```

👉 только строки с совпадением в обеих таблицах  

---

### LEFT JOIN

```sql
SELECT
  c.customer_id,
  c.customer_name,
  o.order_id
FROM customers c
LEFT JOIN orders o
  ON c.customer_id = o.customer_id;
```

👉 все строки из левой таблицы  
👉 если совпадения нет → `NULL`  

---

### RIGHT JOIN

```sql
SELECT
  c.customer_id,
  c.customer_name,
  o.order_id
FROM customers c
RIGHT JOIN orders o
  ON c.customer_id = o.customer_id;
```

👉 все строки из правой таблицы  

💡 используется редко  
👉 обычно заменяют LEFT JOIN (меняя таблицы местами)

---

### FULL OUTER JOIN

```sql
SELECT
  c.customer_id,
  c.customer_name,
  o.order_id
FROM customers c
FULL OUTER JOIN orders o
  ON c.customer_id = o.customer_id;
```

👉 все строки из обеих таблиц  
👉 нет совпадения → `NULL`  

---

## 📌 2. Как читать JOIN

```text
FROM → основная таблица  
JOIN → что присоединяем  
ON   → по какому ключу  
```

---

### Пример

```sql
SELECT
  o.order_id,
  o.price,
  c.customer_name,
  c.customer_city
FROM orders o
JOIN customers c
  ON o.customer_id = c.customer_id;
```

---

### Несколько JOIN

```sql
SELECT
  o.order_id,
  c.customer_name,
  p.product_brand,
  oi.price AS item_price
FROM orders o
JOIN customers c
  ON o.customer_id = c.customer_id
JOIN order_items oi
  ON o.order_id = oi.order_id
JOIN products p
  ON oi.product_id = p.product_id;
```

---

## 📌 3. Гранулярность и дубли

👉 гранулярность = что означает 1 строка  

```text
orders      → 1 строка = 1 заказ
order_items → 1 строка = 1 товар
```

---

### Важно

Если:

```
order_id = 10 → 3 товара
```

После JOIN:

```
order_id = 10 → 3 строки
```

👉 это НОРМАЛЬНО  

---

## 📌 Как избежать дублей

👉 агрегируй до JOIN

---

### Пример

```sql
SELECT
  o.order_id,
  c.customer_name,
  oi.total_price
FROM orders o
JOIN customers c
  ON o.customer_id = c.customer_id
JOIN (
  SELECT
    order_id,
    SUM(price) AS total_price
  FROM order_items
  GROUP BY order_id
) oi
  ON o.order_id = oi.order_id;
```

👉 сначала считаем → потом JOIN  

---

## Что запомнить

- INNER → только совпадения  
- LEFT → всё слева  
- RIGHT → всё справа  
- FULL → всё  
- JOIN может дублировать строки  
- причина дублей → разная гранулярность  
- решение → агрегировать перед JOIN  