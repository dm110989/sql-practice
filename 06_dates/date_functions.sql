-- =========================================
-- Задача 2.7
-- Сделайте выгрузку клиентов нашего маркетплейса
-- =========================================
-- Тема: DATE_PART
-- Условие: В выгрузке должен быть:
        -- Идентификатор клиента
        -- Город
        -- День регистрации
        -- Месяц регистрации 
        -- Год регистрации
        -- Разница в днях между текущей датой и датой регистрации клиента в системе. Назовите этот столбец register_days_ago.
SELECT 
customer_id,
customer_city,
DATE_PART('day', created_at) AS day_created_at,
DATE_PART('month', created_at) AS month_created_at,
DATE_PART('year', created_at) AS year_created_at,
DATE_PART('day', NOW() - created_at) AS register_days_ago
FROM
customers

-- =========================================
-- Задача 2.16
-- Напишите SQL-запрос, который для каждого заказа выведет следующие данные
-- =========================================
-- Тема: CAST, DATE_PART 
-- Условие: Идентификатор заказа
          -- Дату создания заказа без времени. Назовите order_created_day 
          -- Дату фактической доставки клиента без времени. Назовите order_delivered_customer_day
          -- Дату ожидаемой доставки клиента без времени. Назовите order_estimated_delivery_day 
          -- Количество полных дней между ожидаемой датой доставки и фактической. Назовите delivery_delay_days
          -- Отсортируйте заказы по количеству дней задержки (по возрастанию, так как задержка у нас обозначается отрицательными числами), 
          -- а также по возрастанию order_id.
SELECT
order_id,
CAST(order_created_time AS DATE) AS order_created_day,
CAST(order_delivered_customer_time AS DATE) AS order_delivered_customer_day,
CAST(order_estimated_delivery_time AS DATE) AS order_estimated_delivery_day,
DATE_PART('day', order_estimated_delivery_time - order_delivered_customer_time) AS delivery_delay_days
FROM
orders
ORDER BY delivery_delay_days, order_id