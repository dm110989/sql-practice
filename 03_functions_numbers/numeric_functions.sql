-- =========================================
-- Задача 6 
-- Для каждого товара нужно вывести следующие данные 
-- Тема: AS
-- =========================================

-- Условие: Идентификатор продукта.
-- Длину (переименовать в length_cm), ширину (переименовать в width_cm), высоту (переименовать в height_cm).
-- Объём товара в кубических метрах. Объём — это произведение длины, ширины и высоты. Для перевода в кубические метры нужно разделить объём на 1 000 000. Назвать volume_m3.
-- Поля в результирующей таблице: product_id, length_cm, width_cm, height_cm,volume_m3

SELECT
product_id,
product_length_cm AS length_cm,
product_width_cm AS width_cm,
product_height_cm AS height_cm,
product_length_cm * product_width_cm * product_height_cm / 1000000.0 AS volume_m3
FROM products;

-- =========================================
-- Задача 7 
-- Вывести: 
-- Идентификатор продукта
-- Длину (переименовать в length_cm), ширину (переименовать в width_cm), высоту (переименовать в height_cm)
-- Объём товара в кубических метрах, теперь округлённый до одного знака после запятой. Назвать round_volume_m3
-- Новая колонка: Вес в килограммах, округлённый вверх. Назвать product_weight_kg
-- Тема: ROUND, CEIL
-- =========================================

-- Условие:

SELECT
product_id,
product_length_cm AS length_cm,
product_width_cm AS width_cm,
product_height_cm AS height_cm,
ROUND(product_length_cm * product_width_cm * product_height_cm / 1000000.0, 1) AS round_volume_m3,
CEIL(product_weight_g / 1000.0) AS product_weight_kg

FROM products

-- =========================================
-- Задача 8 
-- Вывести: 
-- Идентификатор продукта.
-- Длину (переименовать в length_cm), ширину (переименовать в width_cm), высоту (переименовать в height_cm).
-- Объём товара в кубических метрах, округлённый до одного знака после запятой. Назвать round_volume_m3.
-- Вес в килограммах, округлённый вверх. Назвать product_weight_kg.
-- Модуль разницы между длиной и шириной, чтобы оценить «вытянутость» продукта. Переведите модуль разницы в метры. Назвать abs_diff.
-- =========================================
-- Тема: ROUND, ABS
-- Условие: Поля в результирующей таблице: product_id, length_cm, width_cm, height_cm, round_volume_m3, product_weight_kg, abs_diff

SELECT
  product_id,
  product_length_cm AS length_cm,
  product_width_cm AS width_cm,
  product_height_cm AS height_cm,
  ROUND(product_length_cm * product_width_cm * product_height_cm / 1000000.0, 1) AS round_volume_m3,
  CEIL(product_weight_g / 1000.0) AS product_weight_kg,
  ABS((product_length_cm - product_width_cm)/100.0) AS abs_diff
FROM
  products