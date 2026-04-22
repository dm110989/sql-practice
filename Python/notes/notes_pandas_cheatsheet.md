# Pandas: расширенная шпаргалка

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
```

---

## Просмотр данных

```python
df.head()
df.tail()
df.shape
df.columns
df.info()
df.describe()
```

---

## Выбор данных

### Один столбец

```python
df["name"]
```

---

### Несколько столбцов

```python
df[["name", "age"]]
```

---

### По индексу

```python
df.loc[0]
df.iloc[0]
```

---

## Фильтрация

```python
df[df["age"] > 25]
```

---

### Несколько условий

```python
df[(df["age"] > 20) & (df["salary"] > 120)]
```

---

### query()

```python
min_age = 25
df.query("age > @min_age")
```

---

## Сортировка

```python
df.sort_values("age")
df.sort_values(["age", "salary"], ascending=[True, False])
```

---

## Добавление столбца

```python
df["bonus"] = df["salary"] * 0.1
```

---

## Работа с NaN

```python
df.isna()
df.dropna()
df.fillna(0)
df.fillna(df.mean())
df.dropna(subset=["age"])
```

---

## Преобразование типов

```python
df["age"] = df["age"].astype(float)
df["date"] = pd.to_datetime(df["date"])
df["num"] = pd.to_numeric(df["num"], errors="coerce")
df["cat"] = df["name"].astype("category")
```

---

## Работа с датами

```python
df["date"] = pd.to_datetime(df["date"])

df["year"] = df["date"].dt.year
df["month"] = df["date"].dt.month
df["weekday"] = df["date"].dt.day_name()
```

---

## Группировка (groupby)

```python
df.groupby("name")["salary"].sum()
```

---

### Несколько агрегатов

```python
df.groupby("name")["salary"].agg(["sum", "mean"])
```

---

### transform()

```python
df["salary_mean"] = df.groupby("name")["salary"].transform("mean")
```

---

## Pivot и Melt

### pivot()

```python
df.pivot(index="name", columns="month", values="salary")
```

---

### melt()

```python
df.melt(id_vars="name", var_name="metric", value_name="value")
```

---

## Объединение таблиц (merge)

```python
pd.merge(df1, df2, on="id")
```

---

### Типы join

```python
pd.merge(df1, df2, on="id", how="left")
pd.merge(df1, df2, on="id", how="right")
pd.merge(df1, df2, on="id", how="outer")
pd.merge(df1, df2, on="id", how="inner")
```

---

## Полезные методы

```python
df["name"].unique()
df["name"].value_counts()
df.reset_index(drop=True)
df.sort_index()
```

---

## Очистка колонок

```python
df.columns = (
    df.columns
    .str.strip()
    .str.lower()
    .str.replace(" ", "_")
)
```

---

## Настройки отображения

```python
pd.set_option("display.max_rows", 100)
pd.set_option("display.max_columns", None)
```

---

## Что запомнить

- df["col"] — выбор столбца  
- df[условие] — фильтрация  
- query() — удобная фильтрация  
- value_counts() — частоты  
- sort_values() — сортировка  
- groupby() — агрегация  
- merge() — объединение  
- pivot() / melt() — преобразование  
- fillna() / dropna() — пропуски  
- astype() / to_datetime() — типы  