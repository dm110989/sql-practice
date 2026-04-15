-- Тема: CTE + агрегаты + фильтрация по бизнес-условиям
-- Уровень: Medium
--
-- Задача:
-- Найти пользователей из Санкт-Петербурга и Москвы,
-- зарегистрированных после 1 марта 2024 года,
-- у которых:
--   1) более 5 доставленных заказов
--   2) средний чек (по заказам) > 20000
--
-- Вывести информацию о пользователях и их метрики

WITH delivered_orders AS (
    -- Считаем агрегаты по доставленным заказам для каждого пользователя
    SELECT
        o.customer_id,                                  -- id пользователя
        COUNT(DISTINCT o.order_id) AS total_orders,     -- количество доставленных заказов
        SUM(oi.price) AS total_price,                   -- суммарная стоимость всех заказов
        SUM(oi.price)::numeric / COUNT(DISTINCT o.order_id) AS avg_order_price  -- средний чек
    FROM orders o
    -- Подтягиваем стоимость заказов (разбивка по позициям)
    LEFT JOIN order_items oi
        ON o.order_id = oi.order_id
    -- Учитываем только доставленные заказы
    WHERE o.order_status = 'Delivered'
    -- Группировка по пользователю
    GROUP BY o.customer_id
)

SELECT
    c.customer_id,         -- id пользователя
    c.customer_city,       -- город
    c.created_at,          -- дата регистрации
    d.total_orders,        -- количество заказов
    d.avg_order_price      -- средний чек
FROM customers c
-- Соединяем пользователей с их агрегированными заказами
INNER JOIN delivered_orders d
    ON c.customer_id = d.customer_id
WHERE
    -- Фильтр по городам
    c.customer_city IN ('Санкт-Петербург', 'Москва')
    -- Фильтр по количеству заказов
    AND d.total_orders > 5
    -- Фильтр по среднему чеку
    AND d.avg_order_price > 20000
    -- Фильтр по дате регистрации
    AND c.created_at > '2024-03-01'
-- Сортировка по количеству заказов (по убыванию)
ORDER BY d.total_orders DESC;