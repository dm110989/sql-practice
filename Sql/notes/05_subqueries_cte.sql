-- =========================================
-- 05_subqueries_cte.sql
-- ТЕМА: ПОДЗАПРОСЫ, EXISTS, CTE, UNION
-- =========================================


-- =========================================
-- 1. ПОДЗАПРОСЫ (SUBQUERIES) — ВВЕДЕНИЕ
-- =========================================

-- Подзапрос = SELECT внутри другого запроса
--
-- Может стоять:
-- 1) в WHERE  → возвращает одно значение или список
-- 2) в SELECT → должен вернуть ровно одно значение на строку
-- 3) в FROM   → возвращает временную таблицу (нужен псевдоним)
-- 4) в JOIN   → возвращает таблицу, к которой присоединяемся


-- =========================================
-- 2. ПОДЗАПРОС В WHERE: ОДНО ЗНАЧЕНИЕ
-- =========================================

-- найти заказы дороже средней цены
SELECT
  order_id,
  price
FROM orders
WHERE price > (
  SELECT AVG(price)
  FROM orders
);

-- сначала выполняется внутренний запрос → даёт одно число
-- потом внешний запрос сравнивает каждую строку с этим числом

-- пример:
-- AVG(price) = 500
-- price: 300, 700
-- result: 700


-- =========================================
-- 3. ПОДЗАПРОС В WHERE: СПИСОК ЧЕРЕЗ IN
-- =========================================

-- найти клиентов, у которых есть заказы
SELECT *
FROM customers
WHERE customer_id IN (
  SELECT customer_id
  FROM orders
);

-- IN проверяет: входит ли значение в список, который вернул подзапрос

-- пример:
-- список из подзапроса: 1, 2, 5
-- customer_id = 2 → подходит


-- =========================================
-- 4. EXISTS
-- =========================================

-- EXISTS проверяет: есть ли хотя бы одна строка в подзапросе
-- внутри принято писать SELECT 1 — само значение неважно

-- найти клиентов, у которых есть заказы
SELECT *
FROM customers c
WHERE EXISTS (
  SELECT 1
  FROM orders o
  WHERE o.customer_id = c.customer_id
);

-- найти товары, которые покупались
SELECT *
FROM products p
WHERE EXISTS (
  SELECT 1
  FROM order_items oi
  WHERE oi.product_id = p.product_id
);

-- пример с условием по городу
SELECT
  p.product_id,
  p.product_brand,
  oi.price
FROM products p
JOIN order_items oi
  ON p.product_id = oi.product_id
WHERE EXISTS (
  SELECT 1
  FROM orders o
  JOIN customers c
    ON o.customer_id = c.customer_id
  WHERE o.order_id = oi.order_id
    AND c.customer_city = 'Самара'
);

-- важно: EXISTS требует полноценный SELECT внутри
-- ❌ EXISTS (p.product_id = oi.product_id)  -- не работает
-- ✔  EXISTS (SELECT 1 FROM ... WHERE ...)   -- правильно


-- =========================================
-- 5. NOT EXISTS
-- =========================================

-- найти клиентов без заказов
SELECT *
FROM customers c
WHERE NOT EXISTS (
  SELECT 1
  FROM orders o
  WHERE o.customer_id = c.customer_id
);

-- NOT EXISTS = нет ни одной строки в подзапросе


-- =========================================
-- 6. EXISTS vs IN
-- =========================================

-- IN → проверяет значение по списку
SELECT *
FROM order_items oi
WHERE oi.order_id IN (
  SELECT o.order_id
  FROM orders o
);

-- EXISTS → проверяет факт наличия строки
SELECT *
FROM customers c
WHERE EXISTS (
  SELECT 1
  FROM orders o
  WHERE o.customer_id = c.customer_id
);

-- кратко:
-- IN     → "значение входит в список"
-- EXISTS → "хотя бы одна строка существует"

-- EXISTS предпочтительнее при больших подзапросах:
-- он останавливается при нахождении первой строки
-- IN сначала строит весь список, потом проверяет


-- =========================================
-- 7. ПОДЗАПРОС В SELECT (коррелированный)
-- =========================================

-- для каждого клиента показать количество его заказов
SELECT
  c.customer_id,
  c.customer_name,
  (
    SELECT COUNT(*)
    FROM orders o
    WHERE o.customer_id = c.customer_id
  ) AS orders_cnt
FROM customers c;

-- подзапрос зависит от строки внешнего запроса → коррелированный
-- подзапрос в SELECT должен вернуть строго одно значение
-- если вернёт несколько строк → ошибка

-- удобен и нагляден, но иногда JOIN + GROUP BY читается лучше

-- пример:
-- customer_id = 10 → orders_cnt = 3


-- =========================================
-- 8. ПОДЗАПРОС В FROM
-- =========================================

-- сначала считаем заказы по городам,
-- потом работаем с результатом как с таблицей
SELECT
  city_stats.customer_city,
  city_stats.orders_cnt
FROM (
  SELECT
    customer_city,
    COUNT(*) AS orders_cnt
  FROM orders
  GROUP BY customer_city
) AS city_stats
WHERE city_stats.orders_cnt > 10;

-- подзапрос в FROM создаёт временный набор строк
-- псевдоним (AS city_stats) обязателен


-- =========================================
-- 9. ПОДЗАПРОС В JOIN
-- =========================================

-- присоединить к клиентам количество их заказов
SELECT
  c.customer_id,
  c.customer_name,
  s.orders_cnt
FROM customers c
LEFT JOIN (
  SELECT
    customer_id,
    COUNT(*) AS orders_cnt
  FROM orders
  GROUP BY customer_id
) AS s
  ON c.customer_id = s.customer_id;

-- частый шаблон:
-- 1) внутри — считаем агрегат
-- 2) снаружи — присоединяем через JOIN


-- =========================================
-- 10. КОГДА ИСПОЛЬЗОВАТЬ КАЖДЫЙ ПОДХОД
-- =========================================

-- подзапрос в SELECT  → нужно одно значение на строку (удобно, но медленнее)
-- JOIN + агрегат      → нужно присоединить заранее посчитанную таблицу
-- EXISTS              → нужно проверить наличие строк
-- IN                  → нужно проверить значение по списку
-- CTE                 → запрос лучше разбить на шаги для читаемости


-- =========================================
-- 11. WITH (CTE — Common Table Expression)
-- =========================================

-- CTE = временная именованная таблица внутри запроса
-- более читаемая альтернатива подзапросу в FROM

WITH city_stats AS (
  SELECT
    customer_city,
    COUNT(*) AS cnt
  FROM orders
  GROUP BY customer_city
)
SELECT
  customer_city,
  cnt
FROM city_stats;

-- пример: несколько шагов
WITH orders_per_customer AS (
  SELECT
    customer_id,
    COUNT(*) AS orders_cnt,
    AVG(price) AS avg_price
  FROM orders
  GROUP BY customer_id
)
SELECT
  customer_id,
  orders_cnt,
  avg_price
FROM orders_per_customer
WHERE orders_cnt >= 3;

-- шаг 1: считаем агрегаты по клиенту
-- шаг 2: фильтруем результат


-- =========================================
-- 12. UNION / UNION ALL / INTERSECT / EXCEPT
-- =========================================

-- UNION → объединить результаты, убрать дубли
SELECT customer_id FROM customer_actions
UNION
SELECT customer_id FROM customers;

-- UNION ALL → объединить результаты, дубли сохранить
-- быстрее UNION, если дубли не важны
SELECT customer_id FROM customer_actions
UNION ALL
SELECT customer_id FROM customers;

-- INTERSECT → оставить только общие строки (есть в обоих)
SELECT customer_id FROM customer_actions
INTERSECT
SELECT customer_id FROM customers;

-- EXCEPT → строки из первого SELECT, которых нет во втором
SELECT customer_id FROM customer_actions
EXCEPT
SELECT customer_id FROM customers;

-- важно:
-- количество столбцов должно совпадать
-- порядок столбцов должен совпадать
-- типы данных должны быть совместимы

-- пример:
-- A: 1,2,3 | B: 3,4
-- UNION     = 1,2,3,4
-- UNION ALL = 1,2,3,3,4
-- INTERSECT = 3
-- EXCEPT    = 1,2
