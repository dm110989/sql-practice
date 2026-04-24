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

`DataFrame` — это таблица: строки + столбцы.

---

## Просмотр данных

```python
df.head()      # первые строки
df.tail()      # последние строки
df.shape       # размер: (строки, столбцы)
df.columns     # названия колонок
df.info()      # типы данных и пропуски
df.describe()  # статистика по числовым колонкам
```

---

## Выбор данных

```python
df["name"]           # один столбец
df[["name", "age"]]  # несколько столбцов
```

```python
df.loc[0]   # строка по названию индекса
df.iloc[0]  # строка по позиции
```

---

## Фильтрация

```python
df[df["age"] > 25]
# строки, где age больше 25
```

---

### Несколько условий

```python
df[(df["age"] > 20) & (df["salary"] > 120)]
```

Что важно:

- `&` — И
- `|` — ИЛИ
- каждое условие пишется в скобках

---

### query()

```python
min_age = 25
df.query("age > @min_age")
```

Что значит:

- `age` — название колонки
- `@min_age` — переменная из Python
- `@` нужен, чтобы pandas понял: переменная находится вне строки

Аналог без `query()`:

```python
df[df["age"] > min_age]
```

---

## Сортировка

```python
df.sort_values("age")
# сортировка по возрастанию
```

```python
df.sort_values("age", ascending=False)
# сортировка по убыванию
```

```python
df.sort_values(
    ["age", "salary"],
    ascending=[True, False]
)
# сначала age по возрастанию,
# потом salary по убыванию
```

---

## Добавление столбца

```python
df["bonus"] = df["salary"] * 0.1
```

Создаем новый столбец `bonus` на основе `salary`.

---

## Переименование колонок

### Переименовать один столбец

```python
df = df.rename(columns={"name": "user_name"})
```

---

### Переименовать несколько столбцов

```python
df = df.rename(columns={
    "name": "user_name",
    "age": "user_age"
})
```

---

### Полностью заменить все названия

```python
df.columns = ["user_name", "user_age", "salary"]
```

Важно: количество новых названий должно совпадать с количеством колонок.

---

## Очистка названий колонок

Часто в данных из Excel/CSV есть пробелы, большие буквы и неудобные названия.

```python
df.columns = (
    df.columns
    .str.strip()              # убрать пробелы по краям
    .str.lower()              # привести к нижнему регистру
    .str.replace(" ", "_")    # заменить пробелы на _
)
```

Пример:

```text
" User Name " → "user_name"
```

---

## Работа с NaN

`NaN` — это пропущенное значение.

```python
df.isna()
# показать пропуски True/False
```

```python
df.dropna()
# удалить строки с пропусками
```

```python
df.fillna(0)
# заменить пропуски на 0
```

```python
df.dropna(subset=["age"])
# удалить строки, где age = NaN
```

```python
df["age"] = df["age"].fillna(df["age"].mean())
# заполнить пропуски средним age
```

---

## Преобразование типов

```python
df["age"] = df["age"].astype(float)
# привести age к float
```

```python
df["num"] = pd.to_numeric(df["num"], errors="coerce")
# преобразовать в число
# ошибки превратить в NaN
```

```python
df["cat"] = df["name"].astype("category")
# категориальный тип
```

---

## Работа с датами

```python
df["date"] = pd.to_datetime(df["date"])
# строку превратить в дату
```

```python
df["year"] = df["date"].dt.year
df["month"] = df["date"].dt.month
df["weekday"] = df["date"].dt.day_name()
```

---

## Агрегации

Агрегации уменьшают данные: считают сумму, среднее, минимум, максимум и т.д.

```python
df["salary"].sum()    # сумма
df["salary"].mean()   # среднее
df["salary"].count()  # количество без NaN
df["salary"].min()    # минимум
df["salary"].max()    # максимум
```

---

### round()

```python
df["salary"].mean().round(2)
```

Округление до 2 знаков после запятой.

Пример:

```python
round(3.14159, 2)
```

Результат:

```text
3.14
```

---

### value_counts()

```python
df["name"].value_counts()
```

Показывает, сколько раз встречается каждое значение.

---

### nunique()

```python
df["name"].nunique()
```

Количество уникальных значений.

---

## Группировка groupby()

`groupby()` — как `GROUP BY` в SQL.

```python
df.groupby("name")["salary"].sum()
# сумма salary по каждому имени
```

```python
df.groupby("name")["salary"].mean()
# средняя salary по каждому имени
```

---

### Несколько агрегатов сразу

```python
df.groupby("name")["salary"].agg(["sum", "mean", "count"])
```

Результат:

```text
       sum   mean  count
name
Иван   250  125.0      2
Петр   200  200.0      1
```

---

### transform()

```python
df["salary_mean"] = df.groupby("name")["salary"].transform("mean")
```

Разница:

- `agg()` уменьшает таблицу
- `transform()` сохраняет размер таблицы

---

## Pivot и Melt

### pivot()

`pivot()` делает таблицу шире: значения одного столбца становятся новыми колонками.

```python
df.pivot(index="name", columns="month", values="salary")
```

Что значит:

- `index` — что будет строками
- `columns` — что станет новыми колонками
- `values` — какие значения будут внутри таблицы

---

### Пример pivot()

```python
data = {
    "name": ["Иван", "Иван", "Петр"],
    "month": ["Jan", "Feb", "Jan"],
    "salary": [100, 150, 200]
}

df = pd.DataFrame(data)

print(df.pivot(index="name", columns="month", values="salary"))
```

Результат:

```text
month   Feb   Jan
name
Иван    150   100
Петр    NaN   200
```

---

### melt()

`melt()` делает обратное: широкую таблицу превращает в длинную.

```python
df.melt(id_vars="name", var_name="month", value_name="salary")
```

Что значит:

- `id_vars` — что оставить как есть
- `var_name` — название нового столбца с бывшими колонками
- `value_name` — название нового столбца со значениями

---

## Объединение таблиц merge()

`merge()` — как `JOIN` в SQL.

```python
pd.merge(df1, df2, on="id")
# соединить по колонке id
```

```python
pd.merge(df1, df2, on="id", how="left")
# left join: все строки из df1 + совпадения из df2
```

```python
pd.merge(df1, df2, on="id", how="inner")
# inner join: только совпадения
```

```python
pd.merge(df1, df2, on="id", how="outer")
# outer join: все строки из обеих таблиц
```

---

## Полезные методы

```python
df["name"].unique()
# уникальные значения
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

## Настройки отображения

```python
pd.set_option("display.max_rows", 100)
pd.set_option("display.max_columns", None)
```

---

## Что запомнить

- `df["col"]` — выбрать столбец
- `df[условие]` — фильтрация
- `query()` — удобный фильтр
- `rename()` — переименование колонок
- `columns.str` — массовая очистка названий
- `fillna()` / `dropna()` — работа с пропусками
- `astype()` / `to_datetime()` — преобразование типов
- `sum()` / `mean()` / `count()` — агрегации
- `value_counts()` — частоты значений
- `groupby()` — группировка
- `merge()` — объединение таблиц
- `pivot()` / `melt()` — изменение формы таблицы
