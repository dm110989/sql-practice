-- =========================================
-- Задача 9
-- Вывести: 
-- Идентификатор продукта
-- Полное название продукта в формате: product_brand - product_category_name. Например, SAMSUNG - ЭЛЕКТРОНИКА. Назвать product_full_name
-- Артикул для товара, который состоит из названия бренда в верхнем регистре + длины названия категории 
-- (например, для Nike и одежда → NIKE6, где 6 — длина слова «одежда»). Назвать product_number
-- =========================================
-- Тема: CONCAT
-- Условие: Поля в результирующей таблице: product_id, product_full_name, product_number
SELECT
product_id,
CONCAT(product_brand, ' - ' , product_category_name) AS product_full_name,
CONCAT(UPPER(product_brand), LENGTH(product_category_name)) AS product_number

FROM
  products

-- =========================================
-- Задача 10
-- Вывести: 
-- Полное название продукта в формате: product_brand - product_category_name. Например, МирГрупп - Бытовая техника. Назвать product_full_name_clean
-- Давай сделаем артикул для товара, пусть он будет состоять из первых 3 символов бренда product_brand + 
-- длины названия категории из поля product_category_name 
-- (например для product_id = 1, МирГрупп → Мир15, где 15 — длина product_category_name «Бытовая техника»). Назвать product_number
-- Основная категория товара. Давайте при помощи функции SPLIT_PART возьмём 1 фрагмент строки из product_category_name, разделённой по пробелу  ' '. 
-- Назвать main_category.
-- =========================================
-- Тема: SPLIT_PART, SUBSTRING
-- Условие: Поля в результирующей таблице: product_id, product_full_name_clean, product_number, main_category
SELECT
product_id,
CONCAT(product_brand, ' - ', product_category_name) AS product_full_name_clean,
CONCAT(SUBSTRING(product_brand, 1, 3), LENGTH(product_category_name)) AS product_number,
SPLIT_PART(product_category_name, ' ',1) AS main_category
FROM products

-- =========================================
-- Задача 2.5
-- Напишите SQL запрос, который выведет все продукты, где в названии бренда есть строка 'фото'. 
-- Приведите название бренда к нижнему регистру.
-- =========================================
-- Тема: WHERE, LIKE
-- Условие: Поля в результирующей таблице: product_id, product_brand.
SELECT 
product_id,
LOWER(product_brand) AS product_brand
FROM
products
WHERE LOWER(product_brand) LIKE '%фото%'