# Условия и циклы

## Условия (if / elif / else)

Условия позволяют выполнять код в зависимости от значения.

### Базовый синтаксис

```python
age = 18

if age >= 18:
    print("Совершеннолетний")
else:
    print("Несовершеннолетний")
```

### Несколько условий

```python
age = 20

if age < 18:
    print("Меньше 18")
elif age < 65:
    print("Рабочий возраст")
else:
    print("Пенсионный возраст")
```

---

## Операторы сравнения

```python
==   # равно
!=   # не равно
>    # больше
<    # меньше
>=   # больше или равно
<=   # меньше или равно
```

---

## Логические операторы

```python
and  # и
or   # или
not  # не
```

### Пример

```python
age = 25
salary = 100000

if age > 18 and salary > 50000:
    print("Подходит")
```

---

## Проверка вхождения

```python
"apple" in ["apple", "banana"]   # True
"a" in "cat"                     # True
```

---

## Цикл for

Используется для перебора элементов.

```python
numbers = [1, 2, 3]

for num in numbers:
    print(num)
```

---

## range()

```python
for i in range(5):
    print(i)
```

Результат:

```
0 1 2 3 4
```

---

## enumerate()

Позволяет получить индекс и значение.

```python
data = ["a", "b", "c"]

for i, value in enumerate(data):
    print(i, value)
```

---

## Цикл по словарю

```python
users = {
    1: "Иван",
    2: "Петр"
}

for user_id, name in users.items():
    print(user_id, name)
```

---

## break

Прерывает цикл.

```python
for i in range(10):
    if i == 5:
        break
    print(i)
```

---

## continue

Пропускает текущую итерацию.

```python
for i in range(5):
    if i == 2:
        continue
    print(i)
```

---

## Вложенные циклы

```python
for i in range(2):
    for j in range(2):
        print(i, j)
```

---

## Частые ошибки

❌ Забывают двоеточие

```python
if x == 5   # ошибка
```

❌ Путают = и ==

```python
if x = 5    # ошибка
```

❌ Неправильные отступы

```python
if True:
print("Ошибка")  # должно быть с отступом
```

---

## Что запомнить

* if — для условий
* for — для перебора
* enumerate() — когда нужен индекс
* .items() — для словарей
* break — остановка цикла
* continue — пропуск итерации
