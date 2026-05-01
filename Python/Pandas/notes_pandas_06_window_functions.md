# 📊 Pandas — Оконные функции и интерактивные графики

---

## 🔹 rolling() — скользящее окно

👉 считаем метрики по последним N значениям

### 📌 Скользящее среднее
```python
df['ma_3'] = df['value'].rolling(3).mean()
```

### 📌 Простой пример
```python
df = pd.DataFrame({'value': [1, 2, 3, 4, 5]})
df['ma_2'] = df['value'].rolling(2).mean()
```

```
value  ma_2
1      NaN
2      1.5
3      2.5
4      3.5
5      4.5
```

👉 первые значения = NaN (не хватает данных)

---

### 📌 Убираем NaN
```python
df['ma_2'] = df['value'].rolling(2, min_periods=1).mean()
```

---

### 📌 Центрированное окно
```python
df['ma_center'] = df['value'].rolling(3, center=True).mean()
```

👉 учитывает значения до и после

---

### 📌 Другие функции
```python
df['sum'] = df['value'].rolling(3).sum()
df['median'] = df['value'].rolling(3).median()
df['max'] = df['value'].rolling(3).max()
```

---

### 📌 Когда использовать
- временные ряды
- сглаживание шума
- поиск трендов

---

## 🔹 ewm() — экспоненциальное сглаживание

👉 новые значения важнее старых

```python
df['ema'] = df['value'].ewm(span=3).mean()
```

👉 чем меньше span → тем быстрее реакция

---

### 📌 Когда использовать
- когда данные резко меняются
- финансы, метрики продукта

---

## 🔹 seaborn / matplotlib — оформление графиков

### 📌 Базовая настройка
```python
import seaborn as sns

sns.set(
    font_scale=1.5,
    style="whitegrid",
    rc={'figure.figsize': (12, 6)}
)
```

---

### 📌 Подписи
```python
ax = df.plot()

ax.set_title("График")
ax.set_xlabel("Дата")
ax.set_ylabel("Значение")
```

---

### 📌 Проценты на оси
```python
ax.set_yticklabels(['{:.0%}'.format(x) for x in ax.get_yticks()])
```

---

### 📌 Поворот текста
```python
ax.set_xticklabels(ax.get_xticklabels(), rotation=45)
```

---

### 📌 Убрать рамку
```python
sns.despine()
```

---

## 🔹 pd.cut() — разбивка на категории

👉 превращаем числа в сегменты

### 📌 Пример
```python
df['segment'] = pd.cut(
    df['value'],
    bins=[0, 10, 50, 100],
    labels=['low', 'mid', 'high']
)
```

---

### 📌 Без labels
```python
pd.cut(df['value'], bins=3)
```

---

### 📌 Когда использовать
- сегментация пользователей
- группировка метрик

---

## 🔹 Plotly — интерактивные графики

```python
import plotly.express as px
```

---

### 📌 Линия
```python
px.line(df, x="date", y="value")
```

---

### 📌 Барчарт
```python
px.bar(df, x="category", y="value")
```

---

### 📌 Гистограмма
```python
px.histogram(df, x="value")
```

---

### 📌 Когда использовать
- презентации
- дашборды
- исследование данных

⚠️ иногда не работает в ноутбуке

---

## 🔹 zip() — перебор нескольких списков

### ❌ Плохо
```python
for i in range(len(a)):
    print(a[i], b[i])
```

### ✅ Хорошо
```python
for x, y in zip(a, b):
    print(x, y)
```

---

## 💡 Быстрый итог

| Инструмент | Зачем |
|----------|------|
| rolling | сглаживание |
| ewm | быстрые изменения |
| pd.cut | сегменты |
| seaborn | красивые графики |
| plotly | интерактив |
| zip | удобные циклы |
