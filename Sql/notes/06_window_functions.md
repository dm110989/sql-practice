# 📊 Оконные функции (Window Functions)

---

## 📌 1. Введение

Оконные функции:

- НЕ схлопывают строки  
- добавляют результат как новый столбец  

Когда использовать:

- посчитать по группе, но не терять строки  
- топ-N внутри группы  
- накопительный итог  
- сравнение с предыдущей/следующей строкой  

👉 всегда используются с `OVER()`

---

## 📌 2. Синтаксис

```sql
function() OVER (
  PARTITION BY ...
  ORDER BY ...
  ROWS BETWEEN ...
)
```

- PARTITION BY — делит на группы  
- ORDER BY — порядок  
- ROWS BETWEEN — рамка окна  

---

## 📌 3. Агрегатные функции

```sql
SUM(price) OVER ()
AVG(price) OVER (PARTITION BY customer_id)
COUNT(*) OVER (PARTITION BY customer_id)
MIN(price) OVER ()
MAX(price) OVER ()
```

Пример:

```
prices: 100, 200, 300
SUM OVER () = 600 в каждой строке
```

---

## 📌 4. Ранжирование

```sql
ROW_NUMBER() OVER (ORDER BY price DESC)
RANK() OVER (ORDER BY price DESC)
DENSE_RANK() OVER (ORDER BY price DESC)
NTILE(4) OVER (ORDER BY price)
```

Разница:

- ROW_NUMBER → всегда уникальный  
- RANK → с пропусками (1,2,2,4)  
- DENSE_RANK → без пропусков (1,2,2,3)  

---

## 📌 5. LAG / LEAD

```sql
LAG(price) OVER (ORDER BY created_at)
LEAD(price) OVER (ORDER BY created_at)
```

Пример:

```
price: 100, 120, 90
LAG:   NULL, 100, 120
LEAD:  120, 90, NULL
```

С шагом:

```sql
LAG(price, 2) OVER (ORDER BY created_at)
```

С группировкой:

```sql
LAG(price) OVER (
  PARTITION BY customer_id
  ORDER BY created_at
)
```

---

## 📌 6. Value функции

```sql
FIRST_VALUE(price) OVER (...)
LAST_VALUE(price) OVER (...)
NTH_VALUE(price, 2) OVER (...)
```

⚠️ Важно:

```sql
LAST_VALUE требует frame
```

Правильно:

```sql
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
```

---

## 📌 7. Статистика

```sql
PERCENT_RANK() OVER (ORDER BY price)
CUME_DIST() OVER (ORDER BY price)
```

---

## 📌 8. PARTITION и ORDER

```sql
OVER (PARTITION BY customer_id)
OVER (ORDER BY created_at)
```

Комбинация:

```sql
ROW_NUMBER() OVER (
  PARTITION BY customer_id
  ORDER BY price DESC
)
```

---

## 📌 9. ROWS BETWEEN

```sql
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
ROWS BETWEEN CURRENT ROW AND CURRENT ROW
ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
```

Пример:

```
rows: 10,20,30,40
→ (10), (10,20), (20,30), (30,40)
```

---

## 📌 10. RANGE BETWEEN

- работает по значениям  
- не по строкам  

Пример:

```
price: 100, 100, 200
→ объединяет одинаковые значения
```

---

## 📌 11. Frame по умолчанию

Если есть ORDER BY:

```sql
RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
```

Следствия:

- SUM → накопительный итог  
- LAST_VALUE → текущее значение  

👉 лучше явно указывать frame

---

## 📌 12. Паттерны

Накопительная сумма:

```sql
SUM(price) OVER (
  ORDER BY created_at
  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
)
```

Топ-1:

```sql
ROW_NUMBER() OVER (
  PARTITION BY customer_id
  ORDER BY price DESC
)
```

Разница:

```sql
price - LAG(price) OVER (ORDER BY created_at)
```

---

## 📌 13. Фильтрация

❌ нельзя:

```sql
WHERE ROW_NUMBER() OVER (...) = 1
```

✅ правильно:

```sql
SELECT *
FROM (
  SELECT *,
         ROW_NUMBER() OVER (...) AS rn
  FROM orders
) t
WHERE rn = 1
```

---

## 📌 14. Топ-N

```sql
SELECT *
FROM (
  SELECT *,
         ROW_NUMBER() OVER (...) AS rn
  FROM products
) t
WHERE rn <= 5
```

---

## 📌 15. GROUP BY vs WINDOW

GROUP BY:

- схлопывает строки  

WINDOW:

- не схлопывает  
- добавляет расчёты поверх строк  