-- =========================================
-- Задача 2.8: Напишите SQL-запрос, который выведет идентификатор клиента, почтовый индекс клиента с типом данных INTEGER, 
            -- дату добавления клиента в систему с типом данных VARCHAR. 
            -- Результат запроса должен быть отсортирован по возрастанию поля customer_zip_code.
-- =========================================
-- Тема: INTEGER, VARCHAR
-- Условие: Поля в результирующей таблице: customer_id, customer_zip_code, created_at.
SELECT
customer_id,
customer_zip_code :: INTEGER,
created_at :: VARCHAR
FROM
customers
ORDER BY customer_zip_code ASC