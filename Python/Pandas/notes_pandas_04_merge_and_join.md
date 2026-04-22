# Pandas: merge и join

## merge()

Используется для объединения таблиц (аналог JOIN в SQL)

---

## Пример данных

```python
import pandas as pd

users = pd.DataFrame({
    "user_id": [1, 2],
    "name": ["Иван", "Петр"]
})

orders = pd.DataFrame({
    "user_id": [1, 1, 2],
    "price": [100, 200, 300]
})
```

---

## INNER JOIN

```python
result = pd.merge(users, orders, on="user_id")
print(result)
```

Результат:
```
   user_id  name  price
0        1  Иван    100
1        1  Иван    200
2        2  Петр    300
```

---

## LEFT JOIN

```python
result = pd.merge(users, orders, on="user_id", how="left")
print(result)
```

---

## RIGHT JOIN

```python
result = pd.merge(users, orders, on="user_id", how="right")
print(result)
```

---

## FULL JOIN

```python
result = pd.merge(users, orders, on="user_id", how="outer")
print(result)
```

---

## Соединение по разным колонкам

```python
pd.merge(df1, df2, left_on="id1", right_on="id2")
```

---

## join()

Более простой способ, если соединяем по индексу

```python
df1.join(df2)
```

---

## Добавление суффиксов

Если есть одинаковые названия столбцов

```python
pd.merge(df1, df2, on="id", suffixes=("_left", "_right"))
```

---

## Частые ошибки

❌ Забывают указать ключ

```python
pd.merge(df1, df2)  # ошибка или неожиданный результат
```

❌ Путают типы join

- inner — только совпадения  
- left — все из левой таблицы  
- right — все из правой  
- outer — всё  

---

## Что запомнить

- merge() — основной способ объединения  
- on — по какому столбцу соединяем  
- how — тип соединения  
- left / right / inner / outer — как в SQL  