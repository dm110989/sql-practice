-- =========================================
-- 01_basics.sql
-- ТЕМА: БАЗОВЫЙ СИНТАКСИС, ПСЕВДОНИМЫ, СОРТИРОВКА, ФИЛЬТРАЦИЯ
-- =========================================


-- =========================================
-- 1. БАЗОВЫЙ СИНТАКСИС
-- =========================================

-- выбрать все столбцы
SELECT *
FROM orders;

-- выбрать нужные столбцы
SELECT
  order_id,
  customer_id,
  price
FROM orders;

-- убрать дубликаты
SELECT DISTINCT customer_city
FROM orders;

-- ограничить количество строк
SELECT *
FROM orders
LIMIT 10;


-- =========================================
-- 2. ПСЕВДОНИМЫ (ALIASES)
-- =========================================

-- переименовать столбец
SELECT
  price AS total_price
FROM orders;

-- короткое имя таблицы
SELECT
  o.order_id,
  o.price
FROM orders AS o;

-- алиасы таблиц часто используют в JOIN
SELECT
  o.order_id,
  c.customer_id
FROM orders o
JOIN customers c
  ON o.customer_id = c.customer_id;


-- =========================================
-- 3. СОРТИРОВКА
-- =========================================

-- по возрастанию
SELECT
  order_id,
  price
FROM orders
ORDER BY price ASC;

-- по убыванию
SELECT
  order_id,
  price
FROM orders
ORDER BY price DESC;

-- по нескольким полям
SELECT
  order_id,
  customer_id,
  price
FROM orders
ORDER BY price DESC, order_id ASC;


-- =========================================
-- 4. ФИЛЬТРАЦИЯ: WHERE
-- =========================================

-- простое условие
SELECT *
FROM orders
WHERE price > 1000;

-- строка
SELECT *
FROM customers
WHERE customer_city = 'Москва';

-- дата
SELECT *
FROM orders
WHERE created_at >= '2024-01-01';

-- несколько условий
SELECT *
FROM orders
WHERE order_status = 'paid'
  AND price > 1000;

SELECT *
FROM customers
WHERE customer_city = 'Москва'
   OR customer_city = 'Казань';

-- неравенство: исключить строки с определённым значением
SELECT *
FROM orders
WHERE order_status <> 'canceled';


-- =========================================
-- 5. ОПЕРАТОРЫ В WHERE
-- =========================================

-- входит в список
SELECT *
FROM customers
WHERE customer_city IN ('Москва', 'Казань');

-- диапазон (включает оба края)
SELECT *
FROM orders
WHERE price BETWEEN 100 AND 500;

-- поиск по шаблону (% = любое количество символов)
SELECT *
FROM customers
WHERE name LIKE 'A%';

-- поиск по шаблону с вхождением в строку
SELECT *
FROM customers
WHERE name LIKE '%abc%';

-- поиск без учёта регистра (только PostgreSQL)
SELECT *
FROM customers
WHERE name ILIKE '%иван%';


-- =========================================
-- 6. NULL
-- =========================================

-- значение отсутствует
SELECT *
FROM customers
WHERE customer_city IS NULL;

-- значение заполнено
SELECT *
FROM customers
WHERE customer_city IS NOT NULL;

-- если значение NULL, подставить другое
SELECT
  customer_id,
  COALESCE(customer_city, 'неизвестно') AS city_final
FROM customers;

-- пример:
-- customer_city: NULL, 'Москва'
-- result:    'неизвестно', 'Москва'

-- если два значения равны — вернуть NULL
-- применяется, например, для защиты от деления на 0
SELECT
  NULLIF(a, b)
FROM some_table;

-- пример:
-- a,b: 0,0
-- result: NULL

-- важно:
-- NULL нельзя сравнивать через = NULL
-- правильно: IS NULL / IS NOT NULL


-- =========================================
-- 7. ЛОГИКА: CASE WHEN
-- =========================================

-- синтаксис
CASE
  WHEN условие THEN значение
  WHEN условие THEN значение
  ELSE значение
END

-- пример: разбить цену на категории
SELECT
  order_id,
  price,
  CASE
    WHEN price > 1000 THEN 'дорого'
    ELSE 'дёшево'
  END AS price_category
FROM orders;

-- пример:
-- price: 1500, 700
-- result: 'дорого', 'дёшево'
