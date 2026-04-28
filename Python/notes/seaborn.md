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

## Основные типы графиков

```python
sns.displot()        # распределение (гистограмма)
sns.scatterplot()    # зависимость
sns.boxplot()        # разброс
sns.countplot()      # категории (количество)
sns.pairplot()       # все связи
```

---

### **📉 sns.displot() — распределение**

```python
sns.displot(data=df, x="flipper_length_mm", bins=20)
```

Основные параметры:

- x — данные  
- bins — количество столбиков  
- hue — разбивка по категории  

👉 показывает распределение значений  
👉 fig-level функция (создает отдельную фигуру)

---

### **📍 sns.scatterplot() — зависимость**

```python
sns.scatterplot(
    data=df,
    x="flipper_length_mm",
    y="bill_length_mm",
    hue="species",
    s=50
)
```

Основные параметры:

- x, y — данные  
- hue — цвет по категории  
- s — размер точек  

👉 показывает зависимость между переменными  

---

### **📊 sns.boxplot() — разброс**

```python
sns.boxplot(
    data=df,
    x="species",
    y="flipper_length_mm"
)
```

Основные параметры:

- x — категория  
- y — значения  

👉 показывает:
- медиану  
- разброс  
- квартиль (25% / 75%)  
- выбросы  

---

### **📊 sns.countplot() — количество по категориям**

```python
sns.countplot(data=df, x="species")
```

Основные параметры:

- x — категория  
- hue — разбивка по второй категории  
- order — порядок категорий  

👉 считает количество значений  
👉 аналог value_counts() в виде графика  
👉 не требует агрегации  

---

### **📊 sns.pairplot() — все зависимости**

```python
sns.pairplot(df, hue="species")
```

👉 показывает:
- все зависимости между переменными  
- распределения по диагонали  

---

## Разделение на графики

```python
sns.displot(
    data=df,
    x="flipper_length_mm",
    col="species"
)
```

- col — отдельный график для каждой категории  

---

## Общие параметры (matplotlib)

```python
plt.title("Заголовок")
plt.xlabel("X")
plt.ylabel("Y")
plt.grid()
plt.tight_layout()
```

---

## Что запомнить

- displot → распределение  
- scatterplot → зависимость  
- boxplot → разброс  
- countplot → категории  
- pairplot → всё сразу  
- hue → цвет по категории  
- col → разбивка на графики  