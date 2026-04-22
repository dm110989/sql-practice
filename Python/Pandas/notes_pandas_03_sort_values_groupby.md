# Pandas: сортировка и groupby

## Сортировка данных

### По одному столбцу

```python
print(df.sort_values("age"))
```

Результат:
```
   name  age
0  Иван   25
1  Петр   30
```

---

### По убыванию

```python
print(df.sort_values("age", ascending=False))
```

Результат:
```
   name  age
1  Петр   30
0  Иван   25
```

---

### По нескольким столбцам

```python
print(df.sort_values(["age", "name"]))
```

---

## groupby()

Позволяет группировать данные (как GROUP BY в SQL)

---

### Простой пример

```python
data = {
    "name": ["Иван", "Петр", "Иван"],
    "salary": [100, 200, 150]
}

df = pd.DataFrame(data)

print(df.groupby("name")["salary"].sum())
```

Результат:
```
name
Иван    250
Петр    200
Name: salary, dtype: int64
```

---

### Несколько агрегатов

```python
print(df.groupby("name")["salary"].agg(["sum", "mean"]))
```

Результат:
```
       sum   mean
name             
Иван   250  125.0
Петр   200  200.0
```

---

### groupby по нескольким колонкам

```python
data = {
    "city": ["Москва", "Москва", "СПб"],
    "name": ["Иван", "Петр", "Иван"],
    "salary": [100, 200, 150]
}

df = pd.DataFrame(data)

print(df.groupby(["city", "name"])["salary"].sum())
```

Результат:
```
city    name
Москва  Иван    100
        Петр    200
СПб     Иван    150
Name: salary, dtype: int64
```

---

## reset_index()

Превращает индекс обратно в столбец

```python
result = df.groupby("name")["salary"].sum().reset_index()
print(result)
```

Результат:
```
   name  salary
0  Иван     250
1  Петр     200
```

---

## sort_values + groupby

```python
result = df.groupby("name")["salary"].sum().reset_index()
print(result.sort_values("salary", ascending=False))
```

Результат:
```
   name  salary
0  Иван     250
1  Петр     200
```

---

## Частые ошибки

❌ Забывают указать колонку после groupby

```python
df.groupby("name").sum()  # может дать лишние данные
```

❌ Забывают reset_index()

```python
df.groupby("name")["salary"].sum()  # неудобный вывод
```

---

## Что запомнить

- sort_values() — сортировка  
- groupby() — группировка  
- agg() — несколько агрегатов  
- sum(), mean() — основные функции  
- reset_index() — вернуть таблицу  