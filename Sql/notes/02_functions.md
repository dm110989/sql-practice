# 📊 SQL: встроенные функции (числа, строки, даты)

---

## 📌 1. Числовые функции

```sql
ABS(x)
```
👉 модуль числа  
Пример:
```
ABS(-5) = 5
```

---

```sql
ROUND(x, n)
```
👉 округлить до n знаков  
Пример:
```
ROUND(10.567, 2) = 10.57
```

---

```sql
CEIL(x)
```
👉 округлить вверх  
```
CEIL(10.1) = 11
```

---

```sql
FLOOR(x)
```
👉 округлить вниз  
```
FLOOR(10.9) = 10
```

---

## 📌 2. Строковые функции

```sql
LOWER(text)
```
👉 нижний регистр  
```
LOWER('ABC') = 'abc'
```

---

```sql
UPPER(text)
```
👉 верхний регистр  
```
UPPER('abc') = 'ABC'
```

---

```sql
LENGTH(text)
```
👉 длина строки  
```
LENGTH('hello') = 5
```

---

```sql
SUBSTRING(text, a, b)
```
👉 взять часть строки  

- a — с какой позиции (с 1)  
- b — сколько символов  

```
SUBSTRING('abcdef', 1, 3) = 'abc'
```

---

```sql
CONCAT(a, b)
```
👉 склеить строки  
```
CONCAT('sql', '123') = 'sql123'
```

---

```sql
TRIM(text)
```
👉 убрать пробелы  
```
TRIM('  hello  ') = 'hello'
```

---

## 📌 3. Приведение типов

### PostgreSQL

```sql
value::type
```

Пример:

```sql
SELECT
  customer_zip_code::varchar
FROM customers;
```

---

### Стандартный SQL

```sql
CAST(value AS type)
```

Пример:

```sql
SELECT
  CAST(price AS numeric)
FROM orders;
```

---

## 📌 4. Текущая дата и время

```sql
NOW()
```
👉 дата + время  
```
2026-04-07 15:30:00
```

---

```sql
CURRENT_DATE
```
👉 только дата  
```
2026-04-07
```

---

## 📌 5. DATE_PART — достать часть даты

```sql
DATE_PART('year', created_at)
DATE_PART('month', created_at)
DATE_PART('day', created_at)
DATE_PART('hour', created_at)
DATE_PART('minute', created_at)
DATE_PART('second', created_at)
```

---

### День недели

```sql
DATE_PART('dow', created_at)
```
👉 0 = воскресенье, 6 = суббота  

```sql
DATE_PART('isodow', created_at)
```
👉 1 = понедельник, 7 = воскресенье  

---

### Дополнительно

```sql
DATE_PART('doy', created_at)      -- день года
DATE_PART('week', created_at)     -- неделя
DATE_PART('quarter', created_at)  -- квартал
DATE_PART('epoch', created_at)    -- секунды с 1970
```

---

## 📌 6. DATE_TRUNC — обрезать дату

```sql
DATE_TRUNC('year', created_at)
DATE_TRUNC('month', created_at)
DATE_TRUNC('day', created_at)
DATE_TRUNC('hour', created_at)
```

👉 обнуляет всё ниже указанной единицы  

Пример:

```
2024-05-10 12:34:56
→ DATE_TRUNC('month') = 2024-05-01 00:00:00
```

---

## 📊 Пример: группировка по дням

```sql
SELECT
  DATE_TRUNC('day', created_at) AS day_start,
  COUNT(*) AS orders_cnt
FROM orders
GROUP BY day_start
ORDER BY day_start;
```

---

## 📊 Пример: группировка по месяцам

```sql
SELECT
  DATE_TRUNC('month', created_at) AS month_start,
  COUNT(*) AS orders_cnt
FROM orders
GROUP BY month_start
ORDER BY month_start;
```

---

## Что запомнить

- ABS → модуль  
- ROUND → округление  
- CEIL / FLOOR → вверх / вниз  
- LOWER / UPPER → регистр  
- LENGTH → длина  
- SUBSTRING → часть строки  
- CONCAT → склейка  
- TRIM → убрать пробелы  
- CAST / :: → типы  
- NOW / CURRENT_DATE → дата  
- DATE_PART → достать часть  
- DATE_TRUNC → обрезать дату  