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
df.head()      # первые строки
df.tail()      # последние строки
df.shape       # (строки, столбцы)
df.columns     # названия колонок
df.info()      # типы и структура
df.describe()  # статистика
```

---

## Выбор данных

```python
df["name"]          # один столбец
df[["name", "age"]] # несколько столбцов

df.loc[0]           # по названию индекса
df.iloc[0]          # по позиции (как список)
```

---

## Фильтрация

```python
df[df["age"] > 25]  # строки, где age > 25
```

---

### Несколько условий

```python
df[(df["age"] > 20) & (df["salary"] > 120)]
# & = И, | = ИЛИ
# каждое условие в скобках
```

---

### query()

```python
min_age = 25
df.query("age > @min_age")
```

- `"age > @min_age"` — строка с условием  
- `age` — название колонки  
- `@min_age` — переменная из Python (берется из кода)

👉 Без `@` не сработает, потому что query ищет переменные внутри строки

Аналог:
```python
df[df["age"] > min_age]
```

---

## Сортировка

```python
df.sort_values("age")  # по возрастанию

df.sort_values(
    ["age", "salary"],
    ascending=[True, False]
)
# сначала age ↑, потом salary ↓
```

---

## Добавление столбца

```python
df["bonus"] = df["salary"] * 0.1
# создаем новый столбец на основе другого
```

---

## Работа с NaN

```python
df.isna()        # где пропуски (True/False)
df.dropna()      # удалить строки с NaN
df.fillna(0)     # заменить NaN на 0
```

```python
df.fillna(df.mean())
# заполнить средним по колонке
```

```python
df.dropna(subset=["age"])
# удалить только если age = NaN
```

---

## Преобразование типов

```python
df["age"] = df["age"].astype(float)
# привести к float
```

```python
df["date"] = pd.to_datetime(df["date"])
# строку → дата
```

```python
df["num"] = pd.to_numeric(df["num"], errors="coerce")
# ошибки → NaN
```

```python
df["cat"] = df["name"].astype("category")
# экономит память
```

---

## Работа с датами

```python
df["date"] = pd.to_datetime(df["date"])
```

```python
df["year"] = df["date"].dt.year
df["month"] = df["date"].dt.month
df["weekday"] = df["date"].dt.day_name()
```

---

## Группировка (groupby)

```python
df.groupby("name")["salary"].sum()
# сумма зарплат по каждому имени
```

---

### Несколько агрегатов

```python
df.groupby("name")["salary"].agg(["sum", "mean"])
# сразу несколько функций
```

---

### transform()

```python
df["salary_mean"] = df.groupby("name")["salary"].transform("mean")
```

👉 отличие:
- `groupby().mean()` → уменьшает таблицу  
- `transform()` → оставляет размер таблицы  

---

## Pivot и Melt

```python
df.pivot(index="name", columns="month", values="salary")
# строки → столбцы
```

```python
df.melt(id_vars="name", var_name="metric", value_name="value")
# столбцы → строки
```

---

## Объединение таблиц (merge)

```python
pd.merge(df1, df2, on="id")
# объединение по ключу
```

```python
pd.merge(df1, df2, on="id", how="left")
# все из df1 + совпадения из df2
```

---

## Полезные методы

```python
df["name"].unique()
# уникальные значения
```

```python
df["name"].value_counts()
# сколько раз встречается каждое значение
```

```python
df.reset_index(drop=True)
# сбросить индекс
```

```python
df.sort_index()
# сортировка по индексу
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
# делает snake_case
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
- query() — фильтр как SQL  
- value_counts() — распределение  
- groupby() — агрегация  
- merge() — объединение  
- pivot / melt — изменение формы  
- fillna / dropna — пропуски  
- astype / to_datetime — типы  