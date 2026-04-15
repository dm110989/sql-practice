-- =========================================
-- 06_window_functions.sql
-- ТЕМА: ОКОННЫЕ ФУНКЦИИ (WINDOW FUNCTIONS)
-- =========================================


-- =========================================
-- 1. ВВЕДЕНИЕ
-- =========================================

-- Оконные функции НЕ схлопывают строки
-- Результат добавляется как новый столбец к каждой строке

-- Когда использовать:
-- - нужно посчитать что-то по группе, но не терять строки
-- - нужен топ-N внутри группы
-- - нужен накопительный итог
-- - нужно сравнить строку с предыдущей или следующей

-- Всегда используются с OVER()


-- =========================================
-- 2. СИНТАКСИС
-- =========================================

-- function() OVER (
--   PARTITION BY ...   ← делит строки на группы (необязательно)
--   ORDER BY ...       ← задаёт порядок внутри группы (необязательно)
--   ROWS BETWEEN ...   ← задаёт рамку окна (необязательно)
-- )


-- =========================================
-- 3. АГРЕГАТНЫЕ ФУНКЦИИ В ОКНЕ
-- =========================================

-- SUM — сумма по всем строкам окна
SUM(price) OVER ()

-- AVG — среднее по группе клиента
AVG(price) OVER (PARTITION BY customer_id)

-- COUNT — количество строк в группе
COUNT(*) OVER (PARTITION BY customer_id)

-- MIN / MAX по всей таблице
MIN(price) OVER ()
MAX(price) OVER ()

-- пример:
-- prices: 100, 200, 300
-- SUM OVER () = 600 в каждой строке (строки не схлопываются)


-- =========================================
-- 4. РАНЖИРОВАНИЕ
-- =========================================

-- Все функции ранжирования:
-- - не уменьшают количество строк
-- - требуют ORDER BY для корректного результата

-- ROW_NUMBER → уникальный порядковый номер (даже при одинаковых значениях)
ROW_NUMBER() OVER (
  ORDER BY price DESC
)
-- price: 100, 90, 90, 80
-- result: 1, 2, 3, 4

-- RANK → одинаковые значения получают одинаковый ранг, затем пропуск
RANK() OVER (
  ORDER BY price DESC
)
-- price: 100, 90, 90, 80
-- result: 1, 2, 2, 4

-- DENSE_RANK → одинаковые значения получают одинаковый ранг, без пропусков
DENSE_RANK() OVER (
  ORDER BY price DESC
)
-- price: 100, 90, 90, 80
-- result: 1, 2, 2, 3

-- NTILE(n) → делит строки на n равных групп
NTILE(4) OVER (
  ORDER BY price
)
-- 8 строк → result: 1,1,2,2,3,3,4,4

-- Когда что использовать:
-- ROW_NUMBER  → жёсткий топ-N (без дублей)
-- RANK        → рейтинг с пропусками (как в спорте: 1,2,2,4)
-- DENSE_RANK  → рейтинг без пропусков (1,2,2,3)


-- =========================================
-- 5. СМЕЩЕНИЕ: LAG И LEAD
-- =========================================

-- LAG — значение из предыдущей строки
LAG(price) OVER (
  ORDER BY created_at
)
-- price: 100, 120, 90
-- LAG:   NULL, 100, 120

-- LEAD — значение из следующей строки
LEAD(price) OVER (
  ORDER BY created_at
)
-- price: 100, 120, 90
-- LEAD:  120, 90, NULL

-- LAG/LEAD с шагом (второй аргумент — сколько строк смещаться)
LAG(price, 2) OVER (ORDER BY created_at)   -- значение 2 строки назад
LEAD(price, 2) OVER (ORDER BY created_at)  -- значение 2 строки вперёд

-- LAG/LEAD с PARTITION BY (сброс при смене группы)
LAG(price) OVER (
  PARTITION BY customer_id
  ORDER BY created_at
)

-- практический пример:
-- регистрации по дням с предыдущим и следующим значением
WITH daily_registrations AS (
  SELECT
    created_at::DATE AS reg_date,
    COUNT(*) AS registrations
  FROM customers
  GROUP BY created_at::DATE
)
SELECT
  reg_date,
  registrations,
  LAG(registrations)    OVER (ORDER BY reg_date) AS prev_day,
  LEAD(registrations)   OVER (ORDER BY reg_date) AS next_day,
  LAG(registrations, 2) OVER (ORDER BY reg_date) AS two_days_ago
FROM daily_registrations
ORDER BY reg_date;


-- =========================================
-- 6. ФУНКЦИИ ЗНАЧЕНИЙ (FIRST_VALUE, LAST_VALUE, NTH_VALUE)
-- =========================================

-- ⚠️ ВАЖНО: эти функции зависят от оконного фрейма
-- если фрейм не указан явно, результат может быть неожиданным

-- FIRST_VALUE — первое значение в окне
FIRST_VALUE(price) OVER (
  PARTITION BY customer_id
  ORDER BY price
)
-- price: 50, 100, 200
-- result: 50, 50, 50

-- LAST_VALUE — последнее значение в окне
-- ⚠️ без явного фрейма вернёт значение текущей строки (не последней!)
-- правильно — расширить фрейм:
LAST_VALUE(price) OVER (
  PARTITION BY customer_id
  ORDER BY price
  ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
)
-- price: 50, 100, 200
-- result: 200, 200, 200

-- NTH_VALUE — n-ое значение в окне
NTH_VALUE(price, 2) OVER (
  PARTITION BY customer_id
  ORDER BY price
  ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
)
-- price: 50, 100, 200
-- result: 100, 100, 100

-- пример использования NTH_VALUE:
SELECT
  customer_id,
  price,
  NTH_VALUE(price, 2) OVER (
    PARTITION BY customer_id
    ORDER BY price
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS second_price
FROM orders;


-- =========================================
-- 7. СТАТИСТИЧЕСКИЕ ФУНКЦИИ
-- =========================================

-- PERCENT_RANK — относительный ранг от 0 до 1
PERCENT_RANK() OVER (ORDER BY price)
-- 4 строки → result: 0, 0.33, 0.66, 1

-- CUME_DIST — доля строк, значение которых ≤ текущему
CUME_DIST() OVER (ORDER BY price)
-- 4 строки → result: 0.25, 0.5, 0.75, 1


-- =========================================
-- 8. НАСТРОЙКА ОКНА: PARTITION BY И ORDER BY
-- =========================================

-- PARTITION BY — делит строки на независимые группы
OVER (PARTITION BY customer_id)
-- customer_id: 1,1,2,2 → 2 отдельные группы, счёт в каждой с 1

-- ORDER BY — задаёт порядок внутри окна
OVER (ORDER BY created_at)
-- расчёт идёт от старых строк к новым

-- комбинация: ранг внутри каждого клиента
ROW_NUMBER() OVER (
  PARTITION BY customer_id
  ORDER BY price DESC
)


-- =========================================
-- 9. ОКОННЫЙ ФРЕЙМ: ROWS BETWEEN
-- =========================================

-- ROWS BETWEEN задаёт, какие строки участвуют в расчёте
-- считается по позиции строки (не по значению)

-- от первой до текущей строки
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

-- N строк ДО текущей
ROWS BETWEEN 3 PRECEDING AND CURRENT ROW

-- только текущая строка
ROWS BETWEEN CURRENT ROW AND CURRENT ROW

-- соседние строки (предыдущая + текущая + следующая)
ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING

-- N строк ПОСЛЕ текущей
ROWS BETWEEN CURRENT ROW AND 3 FOLLOWING

-- от текущей до последней
ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING

-- вся таблица (или весь раздел PARTITION)
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING

-- пример:
-- rows: 10,20,30,40
-- ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
-- windows: (10), (10,20), (20,30), (30,40)


-- =========================================
-- 10. ОКОННЫЙ ФРЕЙМ: RANGE BETWEEN
-- =========================================

-- RANGE работает по значению ORDER BY, а не по позиции строки

-- от первой строки до строк с текущим значением
RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

-- от строк с текущим значением до конца
RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING

-- вся таблица
RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING

-- ROWS = по строкам | RANGE = по значениям
-- пример:
-- price: 100, 100, 200
-- RANGE CURRENT ROW объединит обе строки с 100


-- =========================================
-- 11. ФРЕЙМ ПО УМОЛЧАНИЮ
-- =========================================

-- если ORDER BY есть, но ROWS/RANGE не указаны:
-- PostgreSQL применяет RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

-- из-за этого:
-- SUM → даёт накопительный эффект (нарастающий итог)
-- LAST_VALUE → возвращает значение текущей строки (а не последней!)
-- NTH_VALUE → может работать неожиданно

-- чтобы захватить все строки раздела явно — используй:
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING


-- =========================================
-- 12. БАЗОВЫЕ ПАТТЕРНЫ
-- =========================================

-- накопительная сумма
SUM(price) OVER (
  ORDER BY created_at
  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
)
-- price: 100, 200, 50
-- result: 100, 300, 350

-- топ-1 в группе
ROW_NUMBER() OVER (
  PARTITION BY customer_id
  ORDER BY price DESC
)
-- prices in group: 500, 300, 100
-- result: 1, 2, 3

-- разница с предыдущим значением
price - LAG(price) OVER (ORDER BY created_at)
-- price: 100, 120, 90
-- result: NULL, 20, -30


-- =========================================
-- 13. ФИЛЬТРАЦИЯ ПО ОКОННЫМ ФУНКЦИЯМ
-- =========================================

-- нельзя фильтровать напрямую в WHERE:
-- ❌ WHERE ROW_NUMBER() OVER (...) = 1

-- правильно: сначала считаем в подзапросе/CTE, потом фильтруем снаружи
SELECT *
FROM (
  SELECT
    customer_id,
    order_id,
    price,
    ROW_NUMBER() OVER (
      PARTITION BY customer_id
      ORDER BY price DESC
    ) AS rn
  FROM orders
) t
WHERE rn = 1;

-- пример: самый дорогой заказ каждого клиента


-- =========================================
-- 14. ТОП-N ВНУТРИ ГРУППЫ
-- =========================================

SELECT *
FROM (
  SELECT
    product_category_name,
    product_id,
    product_height_cm,
    ROW_NUMBER() OVER (
      PARTITION BY product_category_name
      ORDER BY product_height_cm DESC
    ) AS rn
  FROM products
) t
WHERE rn <= 5;

-- пример: топ-5 самых высоких товаров в каждой категории


-- =========================================
-- 15. GROUP BY vs WINDOW FUNCTIONS
-- =========================================

-- GROUP BY:
-- схлопывает строки
-- 3 заказа клиента → 1 строка на клиента

-- WINDOW FUNCTIONS:
-- не схлопывают строки
-- 3 заказа клиента → остаются 3 строки,
-- но можно добавить AVG / SUM / RANK поверх них
