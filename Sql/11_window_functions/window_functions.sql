Для каждого клиента рассчитайте нарастающую сумму его трат от заказа к заказу cumulative_spend.
Для начала нужно посчитать общую стоимость каждого заказа order_total_price, так как в одном заказе может быть несколько товаров.
Результирующую таблицу отсортируйте по возрастанию customer_id и order_created_time.
Поля в результирующей таблице: customer_id, order_id, order_created_time, order_total_price, cumulative_spend

WITH order_total_price AS (
SELECT
order_id,
SUM(price) AS order_total_price
FROM order_items
GROUP BY order_id)

SELECT
c.customer_id,
o.order_id,
o.order_created_time,
ot.order_total_price,
SUM(ot.order_total_price) OVER (PARTITION BY c.customer_id ORDER BY o.order_id) AS cumulative_spend
FROM customers c

JOIN orders o USING(customer_id)

JOIN order_total_price ot ON ot.order_id = o.order_id

ORDER BY c.customer_id, o.order_created_time


=====================================================================================================================================

Напишите SQL-запрос, который для каждого проданного товара (из таблицы order_items) покажет:
Его цену (price).
Категорию товара (product_category_name).
Среднюю цену всех товаров в этой категории (avg_category_price).
Отсортируйте по возрастанию price.
Поля в результирующей таблице: price, product_category_name, avg_category_price.

SELECT 
oi.price,
p.product_category_name,
AVG(price) OVER(PARTITION BY p.product_category_name) AS avg_category_price
FROM order_items oi
JOIN products p USING(product_id)
ORDER BY oi.price 

======================================================================================================================================

Для каждого клиента рассчитайте нарастающую сумму его трат от заказа к заказу cumulative_spend.
Для начала нужно посчитать общую стоимость каждого заказа order_total_price, так как в одном заказе может быть несколько товаров.
Результирующую таблицу отсортируйте по возрастанию customer_id и order_created_time.
Поля в результирующей таблице: customer_id, order_id, order_created_time, order_total_price, cumulative_spend

WITH order_total_price AS (
SELECT
order_id,
SUM(price) AS order_total_price
FROM order_items
GROUP BY order_id)
SELECT
c.customer_id,
o.order_id,
o.order_created_time,
ot.order_total_price,
SUM(ot.order_total_price) OVER (PARTITION BY c.customer_id ORDER BY o.order_id) AS cumulative_spend
FROM customers c
JOIN orders o USING(customer_id)
JOIN order_total_price ot ON ot.order_id = o.order_id
ORDER BY c.customer_id, o.order_created_time


=====================================================================================================================================

Выведите для каждой категории товаров топ-5 самых высоких (product_height_cm) товарных позиций. Чтобы увидеть разницу в функциях, 
добавьте в результат три колонки с рангами, посчитанными с помощью ROW_NUMBER(), RANK() и DENSE_RANK().
Результат отсортируйте по убыванию результата ROW_NUMBER(), а затем по возрастанию product_id.
Поля в результирующей таблице: product_category_name, product_id, product_height_cm, row_num, rank_num, dense_rank_num.

WITH ranked AS (
SELECT 
product_category_name,
product_id,
product_height_cm,
ROW_NUMBER() OVER (PARTITION BY product_category_name ORDER BY product_height_cm DESC) AS row_num,
RANK() OVER (PARTITION BY product_category_name ORDER BY product_height_cm DESC) AS rank_num,
DENSE_RANK() OVER (PARTITION BY product_category_name ORDER BY product_height_cm DESC) AS dense_rank_num
FROM products) 
SELECT 
product_category_name,
product_id,
product_height_cm,
row_num,
rank_num,
dense_rank_num
FROM ranked
WHERE dense_rank_num <=5
ORDER BY row_num DESC, product_id

=====================================================================================================================================
Рассчитайте для каждого дня общую выручку daily_revenue и скользящее среднее выручки за 3 дня (текущий день и два предыдущих) moving_avg_3d_revenue. 
Отсортируйте результат по возрастанию даты.

SELECT
o.order_created_time::date AS order_date,
SUM(oi.price) AS daily_revenue,
AVG(SUM(oi.price)) OVER (ORDER BY o.order_created_time::date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_3d_revenue
FROM orders o
JOIN order_items oi USING(order_id)
GROUP BY order_created_time::date
ORDER BY order_date

=====================================================================================================================================
Для каждой категории товаров и для каждого месяца рассчитайте выручку за этот месяц monthly_revenue
и суммарную выручку за все предыдущие месяцы total_revenue_before_this_month.
У вас могут получаться пропущенные значения в выручке — замените их на 0 с помощью COALESCE().
При вычислении месяца округлите дату до месяца и уберите время — полученное поле назовите category_month.
Результат отсортируйте по возрастанию product_category_name, category_month.

WITH group_name AS (
SELECT
DATE_TRUNC('month', order_created_time)::date AS category_month,
product_category_name,
SUM(oi.price) AS price
FROM orders o
JOIN order_items oi USING (order_id)
JOIN products p ON p.product_id = oi.product_id
GROUp BY category_month,product_category_name
)
SELECT
category_month,
product_category_name,
gn.price AS monthly_revenue,
COALESCE(SUM(gn.price) OVER (PARTITION BY product_category_name ORDER BY category_month ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING ), '0') AS total_revenue_before_this_month
FROM group_name gn

=======================================================================================================================================
-- Рассчитайте среднее время между первым и вторым заказом для всех клиентов, 
-- которые сделали больше одного заказа. 
-- Этот показатель поможет нам понять, сколько в среднем времени нужно нашему новому клиенту, чтобы созреть для повторной покупки.
-- Поля в результирующей таблице: avg_time_between_1st_and_2nd_order.
--
--
WITH rn AS (
SELECT 
customer_id,
order_id,
ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_created_time) AS order_rank,  -- ранжируем заказы в пределах клиента
order_created_time,
LEAD (order_created_time) OVER(PARTITION BY customer_id ORDER BY order_created_time) AS second_order   --Для каждого заказа показываем дату следующего заказа этого же клиента
FRom orders)

SELECT 
AVG (second_order - order_created_time) AS avg_time_between_1st_and_2nd_order -- Считаем среднее значение 
FROM rn
WHERE order_rank = 1 AND second_order IS NOT NULL

==========================================================================================================================================
-- Найдите всех клиентов, чей первый заказ был в категории «Автомобили». Отсортируйте их по убыванию customer_id.
--

WITH t1 AS (
SELECT
o.customer_id,
o.order_id,
o.order_created_time,
p.product_category_name,
DENSE_RANK() OVER(PARTITION BY customer_id ORDER BY order_created_time) AS rank
FROM orders o
JOIN order_items oi USING(order_id)
JOIN products p ON oi.product_id = p.product_id)

SELECT DISTINCT
t1.customer_id
FROM t1
WHERE t1.product_category_name = 'Автомобили' AND t1.rank = 1
ORDER BY t1.customer_id DESC

==============================================================================================================================================
-- Необходимо найти три самых дорогих товара в каждой товарной категории. 
-- Если у нескольких товаров одинаковая цена, они должны иметь одинаковый ранг. 
-- Результат должен быть отсортирован в алфавитном порядке категории и по возрастанию ранга.
-- Поля в результирующей таблице: product_category_name, product_id, price, price_rank.
--
WITH t1 AS
(
SELECT
p.product_category_name,
p.product_id,
oi.price,
DENSE_RANK() OVER (PARTITION BY p.product_category_name ORDER BY oi.price DESC) AS price_rank
FROM products p
JOIN order_items oi USING(product_id)
)

SELECT
product_category_name,
product_id,
price,
price_rank
FROM t1
WHERE price_rank <=3

--============================================================================================================
--
Для каждого товара в заказе необходимо рассчитать, насколько его цена отличается от средней цены всех товаров в его категории avg_category_price,
а также от средней цены всех товаров того же бренда avg_brand_price.
Это поможет выявлять премиальные или, наоборот, бюджетные товары. 
Отличия назовите, соответственно, category_price_delta и brand_price_delta.

SELECT DISTINCT
    oi.product_id,
    p.product_category_name,
    p.product_brand,
    oi.price,
    AVG(oi.price) OVER (PARTITION BY p.product_category_name) AS avg_category_price,
    AVG(oi.price) OVER (PARTITION BY p.product_brand) AS avg_brand_price,
    oi.price - AVG(oi.price) OVER (PARTITION BY p.product_category_name) AS category_price_delta,
    oi.price - AVG(oi.price) OVER (PARTITION BY p.product_brand) AS brand_price_delta
FROM order_items oi
JOIN products p USING(product_id)
ORDER BY
    oi.product_id,
    p.product_category_name,
    oi.price,
    category_price_delta;

--=======================================================================================================================
-- Команда по ассортименту хочет выявить клиентов, которые покупают товары из наибольшего числа различных категорий. 
-- Такие клиенты — «исследователи», они наиболее открыты к новым продуктам. 
-- Также интересно найти тех, кто сфокусирован только на одной-двух категориях — это «специалисты».
-- Напишите SQL-запрос, который посчитает для каждого клиента количество уникальных категорий, в которых он делал покупки, 
-- и присвоит ему ранг на основе этого разнообразия. Отсортируйте по возрастанию этого ранга и возрастанию customer_id.
-- Поля в результирующей таблице: customer_id — идентификатор клиента, distinct_categories_count — количество уникальных категорий, 
-- diversity_rank — ранг клиента по убыванию разнообразия.
--
SELECT
t1.customer_id,
t1.distinct_categories_count,
DENSE_RANK() OVER (ORDER BY distinct_categories_count DESC) AS diversity_rank
FROM 
(
SELECT 
o.customer_id,
COUNT(DISTINCT p.product_category_name) AS distinct_categories_count
FROM orders o
JOIN order_items oi USING(order_id)
JOIN products p ON oi.product_id = p.product_id
GROUP BY o.customer_id) t1
ORDER BY diversity_rank, t1.customer_id

--======================================================================================================================
-- =========================================
-- ЗАДАЧА: Разбивка событий на сессии
-- Логика: новая сессия если пауза > 30 минут
-- =========================================

WITH events_with_lag AS (
    SELECT
        customer_id,
        event_timestamp,

        -- берём время предыдущего события этого клиента
        -- пример:
        -- time: 10:00, 10:10, 11:00
        -- lag:  NULL, 10:00, 10:10
        LAG(event_timestamp) OVER (
            PARTITION BY customer_id
            ORDER BY event_timestamp
        ) AS prev_event_time

    FROM customer_actions
),

session_boundaries AS (
    SELECT
        customer_id,
        event_timestamp,

        -- определяем начало новой сессии
        -- 1 = новая сессия
        -- 0 = продолжаем текущую

        -- новая сессия если:
        -- 1. это первое событие (prev = NULL)
        -- 2. разрыв > 30 минут

        -- пример:
        -- prev: NULL, 10:00, 10:10
        -- curr: 10:00, 10:10, 11:00
        -- diff:  -,   10m,   50m
        -- flag:  1,   0,     1

        CASE
            WHEN prev_event_time IS NULL
                 OR (event_timestamp - prev_event_time) > INTERVAL '30 minutes'
                THEN 1
            ELSE 0
        END AS is_new_session

    FROM events_with_lag 
),

sessions AS (
    SELECT
        customer_id,
        event_timestamp,

        -- нумеруем сессии через накопительную сумму
        -- каждый раз когда is_new_session = 1 → увеличиваем номер

        -- пример:
        -- flag:   1, 0, 0, 1, 0
        -- result: 1, 1, 1, 2, 2

        SUM(is_new_session) OVER (
            PARTITION BY customer_id
            ORDER BY event_timestamp

            -- от начала до текущей строки
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS session_num

    FROM session_boundaries
)

SELECT
    customer_id,
    event_timestamp,

    -- формируем id сессии
    -- пример:
    -- customer_id = 10, session_num = 2 → "10_2"
    CONCAT(customer_id, '_', session_num) AS session_id

FROM sessions

-- сортировка для читаемости результата
ORDER BY customer_id, event_timestamp;


