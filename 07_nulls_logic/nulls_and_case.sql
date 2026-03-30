-- =========================================
-- Задача 2.6
-- Напишите SQL-запрос, который выведет все продукты, добавив колонку category с их типом.
-- Приведите название бренда к нижнему регистру.
-- =========================================
-- Тема: CASE, LIKE
-- Условие: Фото — если в названии есть «фото».
--          Техно — если есть «техно» или «квант».
--          Энерго — если есть «энерго».
--          Другое — если ничего не подошло.
--          Обязательно приведите product_brand к нижнему регистру. 
--          Условия в CASE должны идти в том же порядке (если товар подходит под несколько категорий, он попадёт в первую из них).
SELECT 
product_id,
LOWER(product_brand) AS product_brand,
CASE 
WHEN LOWER(product_brand)  LIKE '%фото%' THEN 'Фото' 
WHEN LOWER(product_brand)  LIKE '%квант%' OR LOWER(product_brand) LIKE '%техно%' THEN 'Техно'
WHEN LOWER(product_brand)  LIKE '%энерго%' THEN 'Энерго' 
ELSE 'Другое'
END AS category
FROM products

-- =========================================
-- Задача 2.9
-- Напишите SQL-запрос, который выведет все ID клиентов, где значение customer_city равно NULL. 
-- =========================================
-- Тема: NULL
-- Условие: Поля в результирующей таблице: customer_id.
SELECT
customer_id
FROM customers
WHERE customer_city IS NULL

-- =========================================
-- Задача 2.10
-- Напишите SQL-запрос, который выведет ID клиента, 
              -- его ZIP-код, город, 
              -- а также поле destination, которое принимает значение customer_city либо customer_zip_code, 
              -- если customer_city не заполнен. 
              -- COALESCE ZIP-код необходимо будет привести к строковому типу.
-- =========================================
-- Тема: COALESCE
-- Условие: Поля в результирующей таблице: customer_id, customer_zip_code, customer_city, destination.
SELECT
    customer_id,
    customer_zip_code,
    customer_city,
    COALESCE(customer_city, customer_zip_code::varchar) AS destination
FROM customers

-- =========================================
-- Задача 2.13
-- «Ребят, выгрузите, пожалуйста, все заказы наших пользователей, 
              -- которые были созданы в период с 15 января 2024 года (включительно) до 3 марта 2024 года (не включительно). 
              -- Мы хотим посмотреть, были ли они доставлены вовремя. Сделайте какой-то столбец, например status_order
-- =========================================
-- Тема: COALESCE, 
-- Условие: «вовремя» (если заказ был доставлен клиенту раньше рассчитанных даты и времени доставки или в те же день и время);
          -- «опоздал» (если заказ был доставлен строго позже рассчитанных даты и времени);
          -- «остальные случаи».
          -- Если дата доставки клиенту (order_delivered_customer_time) пустая, то заполните её датой «2050-01-01».
SELECT
  order_id,
  CASE
    WHEN order_delivered_customer_time <= order_estimated_delivery_time THEN 'вовремя'
    WHEN order_delivered_customer_time > order_estimated_delivery_time THEN 'опоздал'
    ELSE 'остальные случаи'
  END AS status_order, 
  COALESCE(order_delivered_customer_time, '2050-01-01') AS order_delivered_customer_time
FROM
  orders
WHERE
  order_created_time BETWEEN '2024-01-15' AND '2024-03-03'

-- =========================================
-- Задача 2.15
-- Напишите SQL-запрос, который выведет из таблицы customers всех клиентов
-- =========================================
-- Тема: CASE 
-- Условие: Выделите дополнительный столбец — группу региона (region_group) на основе следующей группировки:
        -- «Столица» для «Москва» и «Санкт-Петербург», «Другие» для остальных, 
        -- а также название города в верхнем регистре city_upper.
SELECT
  customer_id,
  UPPER(customer_city) AS city_upper,
  CASE
    WHEN customer_city IN ('Москва', 'Санкт-Петербург') THEN 'Столица'
    ELSE 'Другие'
  END AS region_group
FROM
  customers