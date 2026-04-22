# Pandas: пропущенные значения (NaN)

## Что такое NaN

NaN — это пропущенное значение (пустая ячейка).

---

## Пример

```python
import pandas as pd

data = {
    "name": ["Иван", "Петр", "Анна"],
    "age": [25, None, 30]
}

df = pd.DataFrame(data)
print(df)
```

Результат:
```
   name   age
0  Иван  25.0
1  Петр   NaN
2  Анна  30.0
```

---

## Проверка на NaN

```python
print(df.isna())
```

Результат:
```
    name    age
0  False  False
1  False   True
2  False  False
```

---

## notna()

```python
print(df.notna())
```

---

## Фильтрация строк с NaN

```python
print(df[df["age"].isna()])
```

Результат:
```
   name  age
1  Петр  NaN
```

---

## Удаление строк с NaN

```python
print(df.dropna())
```

Результат:
```
   name   age
0  Иван  25.0
2  Анна  30.0
```

---

## Удаление по конкретному столбцу

```python
print(df.dropna(subset=["age"]))
```

---

## Заполнение значений

```python
df["age"] = df["age"].fillna(0)
print(df)
```

Результат:
```
   name   age
0  Иван  25.0
1  Петр   0.0
2  Анна  30.0
```

---

## Заполнение средним

```python
mean_age = df["age"].mean()
df["age"] = df["age"].fillna(mean_age)
```

---

## Частые ошибки

❌ Проверяют через ==

```python
df["age"] == None  # неправильно
```

✔ Нужно:

```python
df["age"].isna()
```

---

## Что запомнить

- NaN — пропущенные данные  
- isna() — найти NaN  
- dropna() — удалить строки  
- fillna() — заполнить значения  
- mean() — часто используют для заполнения  