# Pandas: DataFrame и Series

## Что такое pandas

pandas — это библиотека для работы с таблицами (как Excel, но в Python).

---

## Подключение

```python
import pandas as pd
```

---

## Series

Series — это один столбец данных.

```python
import pandas as pd

s = pd.Series([10, 20, 30])
print(s)
```

Результат:
```
0    10
1    20
2    30
dtype: int64
```

---

## DataFrame

DataFrame — это таблица (строки + столбцы).

```python
import pandas as pd

data = {
    "name": ["Иван", "Петр"],
    "age": [25, 30]
}

df = pd.DataFrame(data)
print(df)
```

Результат:
```
   name  age
0  Иван   25
1  Петр   30
```

---

## Просмотр данных

### head()

Первые строки:

```python
print(df.head())
```

---

### tail()

Последние строки:

```python
print(df.tail())
```

---

### shape

Размер таблицы:

```python
print(df.shape)
```

Результат:
```
(2, 2)
```

(2 строки, 2 столбца)

---

### columns

Названия столбцов:

```python
print(df.columns)
```

Результат:
```
Index(['name', 'age'], dtype='object')
```

---

### info()

Информация о таблице:

```python
print(df.info())
```

Пример результата:
```
<class 'pandas.core.frame.DataFrame'>
RangeIndex: 2 entries, 0 to 1
Data columns (total 2 columns):
 name    2 non-null object
 age     2 non-null int64
```

---

## Доступ к столбцу

```python
print(df["name"])
```

Результат:
```
0    Иван
1    Петр
Name: name, dtype: object
```

---

## Добавление столбца

```python
df["salary"] = [100000, 120000]
print(df)
```

Результат:
```
   name  age  salary
0  Иван   25  100000
1  Петр   30  120000
```

---

## Что запомнить

- pandas — для работы с таблицами  
- Series — один столбец  
- DataFrame — таблица  
- head() / tail() — просмотр данных  
- shape — размер  
- columns — названия столбцов  
- df["col"] — доступ к столбцу  