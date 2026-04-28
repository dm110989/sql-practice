# 📊 Seaborn (красивые графики)

Seaborn — библиотека для статистической визуализации (поверх matplotlib)

---

## Подключение

```python
import seaborn as sns
```

---

## Данные

```python
import pandas as pd

df = pd.read_csv("file.csv")
```

---

## Гистограмма

```python
sns.displot(data=df, x="age")
```

---

## С группировкой

```python
sns.displot(data=df, x="age", hue="gender")
```

---

## Scatter (точечный график)

```python
sns.scatterplot(
    data=df,
    x="age",
    y="salary"
)
```

---

## С цветами по категории

```python
sns.scatterplot(
    data=df,
    x="age",
    y="salary",
    hue="gender"
)
```

---

## Boxplot (ящик с усами)

```python
sns.boxplot(
    data=df,
    x="gender",
    y="salary"
)
```

---

## Catplot (универсальный)

```python
sns.catplot(
    data=df,
    x="day",
    y="total",
    kind="box"
)
```

---

## Pairplot (все зависимости)

```python
sns.pairplot(df)
```

---

## Разделение на графики

```python
sns.displot(
    data=df,
    x="age",
    col="gender"
)
```

---

## Что запомнить

- displot — распределение  
- scatterplot — зависимость  
- boxplot — распределение по группам  
- pairplot — всё сразу  
- hue — цвет по категории  
- col — разбивка на графики  