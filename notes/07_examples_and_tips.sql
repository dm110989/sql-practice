-- =========================================
-- 07_examples_and_tips.sql
-- ТЕМА: МИНИ-ПРИМЕРЫ, ТИПИЧНЫЕ ОШИБКИ, ПРАКТИЧЕСКОЕ РУКОВОДСТВО
-- =========================================


-- =========================================
-- 1. МИНИ-ПРИМЕРЫ (15 частых задач)
-- =========================================

-- 1. Просто выбрать нужные столбцы
SELECT
  order_id,
  price
FROM orders;

-- 2. Отфильтровать дорогие заказы
SELECT
  order_id,
  price
FROM orders
WHERE price > 1000;

-- 3. Отсортировать дорогие заказы
SELECT
  order_id,
  price
FROM orders
WHERE price > 1000
ORDER BY price DESC;

-- 4. Подставить значение вместо NULL
SELECT
  order_id,
  COALESCE(customer_city, 'неизвестно') AS city_final
FROM orders;

-- 5. Категория через CASE
SELECT
  order_id,
  price,
  CASE
    WHEN price > 1000 THEN 'дорого'
    ELSE 'дёшево'
  END AS price_category
FROM orders;

-- 6. Достать месяц из даты
SELECT
  order_id,
  created_at,
  DATE_PART('month', created_at) AS order_month
FROM orders;

-- 7. Посчитать количество заказов по городам
SELECT
  customer_city,
  COUNT(*) AS orders_cnt
FROM orders
GROUP BY customer_city;

-- 8. Оставить только города, где заказов больше 10
SELECT
  customer_city,
  COUNT(*) AS orders_cnt
FROM orders
GROUP BY customer_city
HAVING COUNT(*) > 10;

-- 9. Присоединить клиентов к заказам
SELECT
  o.order_id,
  o.price,
  c.customer_name
FROM orders o
JOIN customers c
  ON o.customer_id = c.customer_id;

-- 10. Найти клиентов, у которых есть заказы
SELECT *
FROM customers c
WHERE EXISTS (
  SELECT 1
  FROM orders o
  WHERE o.customer_id = c.customer_id
);

-- 11. Для каждого клиента показать число заказов (подзапрос в SELECT)
SELECT
  c.customer_id,
  c.customer_name,
  (
    SELECT COUNT(*)
    FROM orders o
    WHERE o.customer_id = c.customer_id
  ) AS orders_cnt
FROM customers c;

-- 12. Присоединить посчитанное количество заказов (подзапрос в JOIN)
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

-- 13. То же самое, но через CTE (читается лучше)
WITH orders_per_customer AS (
  SELECT
    customer_id,
    COUNT(*) AS orders_cnt
  FROM orders
  GROUP BY customer_id
)
SELECT
  c.customer_id,
  c.customer_name,
  opc.orders_cnt
FROM customers c
LEFT JOIN orders_per_customer opc
  ON c.customer_id = opc.customer_id;

-- 14. Ранг заказов по цене внутри клиента
SELECT
  customer_id,
  order_id,
  price,
  ROW_NUMBER() OVER (
    PARTITION BY customer_id
    ORDER BY price DESC
  ) AS rn
FROM orders;

-- 15. Предыдущее значение через LAG
SELECT
  customer_id,
  order_id,
  created_at,
  price,
  LAG(price) OVER (
    PARTITION BY customer_id
    ORDER BY created_at
  ) AS prev_price
FROM orders;


-- =========================================
-- 2. ЧТО ЧАСТО ПУТАЮТ НОВИЧКИ
-- =========================================

-- 1) WHERE vs HAVING
-- WHERE  → фильтр строк ДО группировки
-- HAVING → фильтр групп ПОСЛЕ GROUP BY

-- 2) COUNT(*) vs COUNT(column)
-- COUNT(*)      → считает все строки (включая NULL)
-- COUNT(column) → не считает строки, где column IS NULL

-- 3) LEFT JOIN vs INNER JOIN
-- INNER JOIN → только строки с совпадением в обеих таблицах
-- LEFT JOIN  → все строки левой таблицы + совпадения справа (NULL если нет)

-- 4) IN vs EXISTS
-- IN     → проверяет по списку значений
-- EXISTS → проверяет факт наличия хотя бы одной строки

-- 5) Подзапрос в SELECT vs подзапрос в JOIN
-- SELECT-подзапрос → ровно одно значение на строку
-- JOIN-подзапрос   → таблица, к которой присоединяемся

-- 6) GROUP BY vs оконные функции
-- GROUP BY → уменьшает количество строк (схлопывает)
-- WINDOW   → добавляет результат поверх каждой строки

-- 7) JOIN и «дубли»
-- дубли после JOIN — часто не ошибка, а следствие разной гранулярности таблиц
-- проверь, что означает 1 строка в каждой из таблиц

-- 8) ROW_NUMBER vs RANK vs DENSE_RANK
-- ROW_NUMBER  → всегда уникальный номер (1,2,3,4)
-- RANK        → при ничьей — пропуск (1,2,2,4)
-- DENSE_RANK  → при ничьей — без пропуска (1,2,2,3)


-- =========================================
-- 3. КАК РЕШАТЬ ЗАДАЧИ НА ПРАКТИКЕ
-- =========================================

-- нужна просто выборка?
-- → SELECT ... FROM ... WHERE ...

-- нужно посчитать агрегат?
-- → SELECT ..., COUNT/SUM/AVG FROM ... GROUP BY ...

-- нужно отфильтровать по агрегату?
-- → ... HAVING ...

-- нужно объединить таблицы?
-- → ... JOIN ... ON ...

-- нужно сравнить строку с агрегатом по всей таблице?
-- → WHERE x > (SELECT AVG(...) FROM ...)

-- нужно проверить наличие связанных строк?
-- → WHERE EXISTS (SELECT 1 FROM ... WHERE ...)

-- нужна промежуточная таблица?
-- → подзапрос в FROM или CTE

-- нужно посчитать что-то поверх каждой строки, не теряя строки?
-- → оконные функции (OVER)

-- нужно взять топ-N внутри группы?
-- → ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ...) + фильтр снаружи

-- появились «дубли» после JOIN?
-- → проверь гранулярность таблиц и при необходимости агрегируй перед JOIN


-- =========================================
-- 4. КОРОТКАЯ ПАМЯТКА ПО ПОДЗАПРОСАМ
-- =========================================

-- ПОДЗАПРОС В SELECT → одно значение на строку
-- ПОДЗАПРОС В WHERE  → одно значение, список (IN), или EXISTS
-- ПОДЗАПРОС В FROM   → временная таблица (нужен псевдоним)
-- ПОДЗАПРОС В JOIN   → таблица для присоединения (обычно с агрегатом)
