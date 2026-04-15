-- =========================================
-- Задача 2.1
-- Напишите SQL-запрос, который выведет все столбцы в таблице products. 
-- Верните продукты только из категории «Одежда», отсортировав результаты запроса по весу по убыванию.
-- =========================================
-- Тема: WHERE, LIKE
-- Условие: Поля в результирующей таблице: product_id, product_brand, product_category_name, 
--          product_height_cm, product_length_cm, product_width_cm, product_weight_g.
SELECT 
product_id,
product_brand,
product_category_name,
product_height_cm,
product_length_cm,
product_width_cm,
product_weight_g
FROM
products
WHERE LOWER(product_category_name) LIKE '%одежда%'
ORDER BY product_weight_g DESC

-- =========================================
-- Задача 2.2
-- Напишите SQL-запрос, который выведет всех клиентов, зарегистрировавшихся после 1 февраля 2024 года включительно.
-- =========================================
-- Тема: WHERE
-- Условие: Поля в результирующей таблице: customer_id, customer_zip_code, customer_city, created_at.
SELECT 
customer_id,
customer_zip_code,
customer_city,
created_at
FROM
customers
WHERE created_at >= '2024-02-01'

-- =========================================
-- Задача 2.3
-- Нам нужна выгрузка ID клиентов. 
-- Подойдут клиенты из Питера или Москвы (Москва, Санкт-Петербург), которые были зарегистрированы в январе.
-- =========================================
-- Тема: WHERE
-- Условие: Поля в результирующей таблице: customer_id.
SELECT customer_id
FROM customers
WHERE (customer_city IN ('Санкт-Петербург', 'Москва')) AND DATE_PART('month', created_at) = 1

-- =========================================
-- Задача 2.4
-- Напишите SQL-запрос, который выведет все продукты, относящиеся к категориям «Электроника», «Одежда» и «Сад». 
-- =========================================
-- Тема: WHERE, IN
-- Условие: Поля в результирующей таблице: product_id, product_brand, product_category_name
SELECT
product_id,
product_brand,
product_category_name
FROM products
WHERE product_category_name IN ('Электроника', 'Одежда', 'Сад' )

-- =========================================
-- Задача 2.11
-- Напишите SQL-запрос, который выведет из таблицы customers город клиента 229.
-- =========================================
-- Тема: WHERE
-- Условие: Поле в результирующей таблице: customer_city.
SELECT
customer_city
FROM customers
WHERE customer_id = 229

-- =========================================
-- Задача 2.12
-- Напишите SQL-запрос, который выведет из таблицы orders заказы, созданные после 4 января 2024 года (не включительно).
              -- Статус заказа не должен быть Returned. 
              -- Ожидаемая дата доставки order_estimated_delivery_time между 5 и 10 днями от даты создания. 
              -- Фактическая дата доставки клиенту (order_delivered_customer_time) не NULL.
-- =========================================
-- Тема: WHERE, INTERVAL
-- Условие: Отсортируйте по убыванию даты создания заказа.
SELECT
  order_id,
  order_status,
  order_created_time
FROM
  orders
WHERE
  order_created_time > '2024-01-05'
  AND order_status <> 'Returned'
  AND order_estimated_delivery_time BETWEEN order_created_time + INTERVAL '5 days'
  AND order_created_time + INTERVAL '10 days'
  AND order_delivered_customer_time IS NOT NULL
Order by order_created_time DESC

-- =========================================
-- Задача 2.14
-- Напишите SQL-запрос, который выведет из таблицы products все продукты, 
              -- бренд которых содержит слово «фото» в любом регистре и части названия. 
              -- Отфильтруйте вес товара (product_weight_g) больше 500 г.
-- =========================================
-- Тема: COALESCE, 
-- Условие: Поля в результирующей таблице: product_id, product_brand, product_category_name.
SELECT 
product_id,
product_brand,
product_category_name
FROM products
WHERE LOWER (product_brand) LIKE '%фото%' AND product_weight_g > 500