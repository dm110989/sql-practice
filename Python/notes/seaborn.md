# 📊 Seaborn (красивые графики)

Seaborn — библиотека для статистической визуализации (поверх matplotlib)

---

## Подключение

```python
import seaborn as sns
import pandas as pd
```

---

## Данные (пример)

```python
df = sns.load_dataset("penguins")
```

---

## Гистограмма (распределение)

```python
sns.displot(data=df, x="flipper_length_mm")
```


::contentReference[oaicite:0]{index=0}


👉 показывает распределение значений

---

## С группировкой (цвет)

```python
sns.displot(data=df, x="flipper_length_mm", hue="species")
```


::contentReference[oaicite:1]{index=1}


👉 сравнение групп

---

## Scatter (зависимость)

```python
sns.scatterplot(
    data=df,
    x="flipper_length_mm",
    y="bill_length_mm"
)
```


::contentReference[oaicite:2]{index=2}


👉 показывает зависимость

---

## Scatter с цветом

```python
sns.scatterplot(
    data=df,
    x="flipper_length_mm",
    y="bill_length_mm",
    hue="species"
)
```


::contentReference[oaicite:3]{index=3}


👉 разные группы разными цветами

---

## Boxplot (ящик с усами)

```python
sns.boxplot(
    data=df,
    x="species",
    y="flipper_length_mm"
)
```


::contentReference[oaicite:4]{index=4}


👉 показывает:
- медиану  
- разброс  
- выбросы  

---

## Pairplot (все зависимости)

```python
sns.pairplot(df, hue="species")
```


::contentReference[oaicite:5]{index=5}


👉 все связи между переменными

---

## Разделение на графики

```python
sns.displot(
    data=df,
    x="flipper_length_mm",
    col="species"
)
```


::contentReference[oaicite:6]{index=6}


👉 отдельный график для каждой категории

---

## Что запомнить

- displot — распределение  
- scatterplot — зависимость  
- boxplot — разброс  
- pairplot — всё сразу  
- hue — цвет по категории  
- col — разбивка на графики  