# Pandas: шпаргалка с примерами

## Подключение

```python
import pandas as pd
```

---

## Создание DataFrame

```python
data = {
    "name": ["Иван", "Петр", "Анна"],
    "age": [25, 30, 22],
    "salary": [100, 200, 150]
}

df = pd.DataFrame(data)
print(df)
```

Результат:
```
   name  age  salary
0  Иван   25     100
1  Петр   30     200
2  Анна   22     150
```

---

## Просмотр данных

```python
df.head()
df.tail()
df.shape
df.columns
df.info()
```

---

## Выбор данных

### Один столбец

```python
print(df["name"])
```

Результат:
```
0    Иван
1    Петр
2    Анна
```

---

### Несколько столбцов

```python
print(df[["name", "age"]])
```

---

### По индексу

```python
print(df.loc[0])
print(df.iloc[0])
```

---

## Фильтрация

```python
print(df[df["age"] > 25])
```

Результат:
```
   name  age  salary
1  Петр   30     200
```

---

### Несколько условий

```python
print(df[(df["age"] > 20) & (df["salary"] > 120)])
```

---

## Сортировка

```python
print(df.sort_values("age"))
```

---

## Добавление столбца

```python
df["bonus"] = df["salary"] * 0.1
print(df)
```

---

## Работа с NaN

```python
df["age"] = [25, None, 22]

print(df.isna())
print(df.dropna())
print(df.fillna(0))
```

---

## Группировка (groupby)

```python
print(df.groupby("name")["salary"].sum())
```

---

### Несколько агрегатов

```python
print(df.groupby("name")["salary"].agg(["sum", "mean"]))
```

---

## Объединение таблиц (merge)

```python
df1 = pd.DataFrame({
    "id": [1, 2],
    "name": ["Иван", "Петр"]
})

df2 = pd.DataFrame({
    "id": [1, 2],
    "salary": [100, 200]
})

result = pd.merge(df1, df2, on="id")
print(result)
```

Результат:
```
   id  name  salary
0   1  Иван     100
1   2  Петр     200
```

---

## Полезные методы

```python
df["name"].unique()
df["name"].value_counts()
df["age"] = df["age"].astype(float)
df.reset_index()
```

---

## Что запомнить

- df["col"] — выбор столбца  
- df[условие] — фильтрация  
- sort_values() — сортировка  
- groupby() — агрегация  
- merge() — объединение  
- fillna() / dropna() — работа с NaN  