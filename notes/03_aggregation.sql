-- =========================================
-- 03_aggregation.sql
-- ТЕМА: АГРЕГАЦИИ, GROUP BY, HAVING, ПОРЯДОК ВЫПОЛНЕНИЯ
-- =========================================


-- =========================================
-- 1. АГРЕГАТНЫЕ ФУНКЦИИ
-- =========================================

COUNT(*)                -- количество всех строк (включая NULL)
COUNT(column)           -- количество строк, где column IS NOT NULL
COUNT(DISTINCT column)  -- количество уникальных НЕ NULL значений
SUM(x)                  -- сумма значений
AVG(x)                  -- среднее арифметическое
MIN(x)                  -- минимальное значение
MAX(x)                  -- максимальное значение

-- важно:
-- агрегатные функции «схлопывают» строки в одну

-- пример:
SELECT
  COUNT(*) AS orders_cnt,
  COUNT(DISTINCT customer_id) AS customers_cnt,
  SUM(price) AS total_sum,
  AVG(price) AS avg_price,
  MIN(price) AS min_price,
  MAX(price) AS max_price
FROM orders;

-- пример:
-- price: 100, 200, 300
-- SUM = 600 | AVG = 200 | MIN = 100 | MAX = 300


-- =========================================
-- 2. FILTER В АГРЕГАТАХ (только PostgreSQL)
-- =========================================

-- позволяет считать агрегат только по строкам, удовлетворяющим условию
-- альтернатива CASE WHEN внутри агрегата

FILTER (WHERE условие)

-- пример: все заказы и только доставленные
SELECT
  COUNT(*) AS total_orders,
  COUNT(*) FILTER (WHERE order_status = 'Delivered') AS delivered_orders
FROM orders;

-- пример: сумма только по доставленным
SELECT
  SUM(price) FILTER (WHERE order_status = 'Delivered') AS delivered_sum
FROM orders;

-- пример:
-- status: Delivered, Pending, Delivered
-- delivered_orders = 2


-- =========================================
-- 3. GROUP BY
-- =========================================

-- группирует строки с одинаковым значением столбца
-- агрегаты считаются внутри каждой группы

-- сгруппировать по одному столбцу
SELECT
  customer_city,
  COUNT(*) AS orders_cnt
FROM orders
GROUP BY customer_city;

-- сгруппировать по нескольким столбцам
SELECT
  customer_city,
  order_status,
  COUNT(*) AS orders_cnt
FROM orders
GROUP BY customer_city, order_status;

-- пример:
-- city: Москва, Москва, Казань
-- Москва = 2, Казань = 1


-- =========================================
-- 4. HAVING
-- =========================================

-- HAVING фильтрует уже посчитанные группы
-- WHERE фильтрует строки ДО группировки
-- HAVING фильтрует группы ПОСЛЕ GROUP BY

-- города, где заказов больше 10
SELECT
  customer_city,
  COUNT(*) AS orders_cnt
FROM orders
GROUP BY customer_city
HAVING COUNT(*) > 10;

-- города со средней ценой выше 1000
SELECT
  customer_city,
  AVG(price) AS avg_price
FROM orders
GROUP BY customer_city
HAVING AVG(price) > 1000;

-- пример:
-- city avg: Москва=1200, Казань=800
-- result: Москва


-- =========================================
-- 5. ПОРЯДОК ВЫПОЛНЕНИЯ SQL-ЗАПРОСА
-- =========================================

-- Важно: порядок написания и порядок выполнения отличаются!

-- FROM      → выбрать основную таблицу
-- JOIN      → присоединить другие таблицы
-- ON        → условие соединения
-- WHERE     → отфильтровать строки
-- GROUP BY  → сгруппировать строки
-- HAVING    → отфильтровать группы
-- WINDOW    → посчитать оконные функции
-- SELECT    → сформировать итоговые столбцы
-- ORDER BY  → отсортировать результат
-- LIMIT     → ограничить количество строк

-- из этого следует:
-- алиасы из SELECT нельзя использовать в WHERE и HAVING
-- (они ещё не вычислены на тех шагах)
-- но можно использовать в ORDER BY
