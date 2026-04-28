# 📊 Matplotlib (база)

Matplotlib — библиотека для построения графиков

---

## Подключение

```python
import matplotlib.pyplot as plt
```

---

## Простой график

```python
x = [1, 2, 3, 4]
y = [2, 3, 4, 5]

plt.plot(x, y)
plt.show()
```

---

## Заголовок и подписи

```python
plt.plot(x, y)

plt.title("График")
plt.xlabel("Ось X")
plt.ylabel("Ось Y")

plt.show()
```

---

## Сетка

```python
plt.grid()
```

---

## Цвет и стиль

```python
plt.plot(x, y, 'r--')  
```

- r — красный  
- -- — пунктир  

---

## Маркеры

```python
plt.plot(x, y, 'bo-')
```

- b — синий  
- o — точки  

---

## Легенда

```python
plt.plot(x, y, label="Линия")

plt.legend()
```

---

## Несколько графиков

```python
plt.plot(x, y, label="1")
plt.plot(x, [i**2 for i in x], label="2")

plt.legend()
plt.show()
```

---

## Границы осей

```python
plt.axis([0, 5, 0, 10])
```

---

## Несколько графиков (subplots)

```python
fig, axs = plt.subplots(2, 2)

axs[0, 0].plot(x, y)
axs[0, 1].plot(x, y)
```

---

## Основные типы графиков

```python
plt.plot()      # линия
plt.scatter()   # точки
plt.bar()       # столбцы
plt.hist()      # гистограмма
```

---

## Что запомнить

- plt.plot() — линия  
- plt.title() — заголовок  
- plt.xlabel() / ylabel() — подписи  
- plt.legend() — легенда  
- plt.grid() — сетка  
- plt.subplots() — несколько графиков  