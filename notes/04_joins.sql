-- =========================================
-- 04_joins.sql
-- ТЕМА: JOIN — ОБЪЕДИНЕНИЕ ТАБЛИЦ
-- =========================================


-- =========================================
-- 1. ВИДЫ JOIN
-- =========================================

-- INNER JOIN → только строки, у которых есть совпадение в обеих таблицах
SELECT
  c.customer_id,
  c.customer_name,
  o.order_id,
  o.price
FROM customers c
INNER JOIN orders o
  ON c.customer_id = o.customer_id;

-- LEFT JOIN → все строки из левой таблицы + совпадения из правой
--             если совпадения нет — поля правой таблицы будут NULL
SELECT
  c.customer_id,
  c.customer_name,
  o.order_id
FROM customers c
LEFT JOIN orders o
  ON c.customer_id = o.customer_id;

-- RIGHT JOIN → все строки из правой таблицы + совпадения из левой
--              на практике используется редко (заменяется LEFT JOIN со сменой таблиц)
SELECT
  c.customer_id,
  c.customer_name,
  o.order_id
FROM customers c
RIGHT JOIN orders o
  ON c.customer_id = o.customer_id;

-- FULL OUTER JOIN → все строки из обеих таблиц
--                  NULL там, где нет совпадения с другой стороны
SELECT
  c.customer_id,
  c.customer_name,
  o.order_id
FROM customers c
FULL OUTER JOIN orders o
  ON c.customer_id = o.customer_id;


-- =========================================
-- 2. JOIN НА ПРАКТИКЕ
-- =========================================

-- FROM = основная таблица
-- JOIN = что присоединяем
-- ON   = по какому ключу соединяем

-- пример: один JOIN
SELECT
  o.order_id,
  o.price,
  c.customer_name,
  c.customer_city
FROM orders o
JOIN customers c
  ON o.customer_id = c.customer_id;

-- пример: несколько JOIN подряд
SELECT
  o.order_id,
  c.customer_name,
  p.product_brand,
  oi.price AS item_price
FROM orders o
JOIN customers c
  ON o.customer_id = c.customer_id
JOIN order_items oi
  ON o.order_id = oi.order_id
JOIN products p
  ON oi.product_id = p.product_id;


-- =========================================
-- 3. ГРАНУЛЯРНОСТЬ И ДУБЛИ ПРИ JOIN
-- =========================================

-- гранулярность = что означает одна строка в таблице

-- orders      → 1 строка = 1 заказ
-- order_items → 1 строка = 1 товар в заказе

-- если заказ order_id = 10 содержит 3 товара,
-- то после JOIN orders + order_items
-- order_id = 10 появится 3 раза

-- это не ошибка, а следствие разной гранулярности!

-- если нужен итог на уровне заказа:
-- сначала сагрегируй order_items, потом JOIN

-- пример: сумма по заказам через агрегацию перед JOIN
SELECT
  o.order_id,
  c.customer_name,
  oi.total_price
FROM orders o
JOIN customers c
  ON o.customer_id = c.customer_id
JOIN (
  SELECT
    order_id,
    SUM(price) AS total_price
  FROM order_items
  GROUP BY order_id
) oi
  ON o.order_id = oi.order_id;
