# SQL Cheat Sheet — Навигация по файлам

Шпаргалка разбита на тематические файлы для быстрого поиска.

---

## 📁 Файлы

| Файл | Темы |
|------|------|
| `01_basics.sql` | SELECT, DISTINCT, LIMIT, псевдонимы (AS), ORDER BY, WHERE, IN, BETWEEN, LIKE, NULL, COALESCE, NULLIF, CASE WHEN |
| `02_functions.sql` | ABS, ROUND, CEIL, FLOOR, LOWER, UPPER, LENGTH, SUBSTRING, CONCAT, TRIM, приведение типов (::, CAST), NOW, CURRENT_DATE, DATE_PART, DATE_TRUNC |
| `03_aggregation.sql` | COUNT, SUM, AVG, MIN, MAX, FILTER, GROUP BY, HAVING, порядок выполнения SQL |
| `04_joins.sql` | INNER JOIN, LEFT JOIN, RIGHT JOIN, FULL OUTER JOIN, гранулярность таблиц, дубли |
| `05_subqueries_cte.sql` | Подзапросы в WHERE / SELECT / FROM / JOIN, EXISTS, NOT EXISTS, IN vs EXISTS, CTE (WITH), UNION, UNION ALL, INTERSECT, EXCEPT |
| `06_window_functions.sql` | ROW_NUMBER, RANK, DENSE_RANK, NTILE, LAG, LEAD, FIRST_VALUE, LAST_VALUE, NTH_VALUE, PERCENT_RANK, CUME_DIST, PARTITION BY, ROWS BETWEEN, RANGE BETWEEN, фильтрация по оконным функциям, топ-N в группе |
| `07_examples_and_tips.sql` | 15 мини-примеров, типичные ошибки новичков, практическое руководство по выбору инструмента |

---

## 🔍 Быстрый поиск по задаче

| Задача | Файл |
|--------|------|
| Убрать дубликаты | `01_basics.sql` |
| Заменить NULL значение | `01_basics.sql` |
| Работа с текстом / датой | `02_functions.sql` |
| Группировка и подсчёт | `03_aggregation.sql` |
| Фильтр по агрегату | `03_aggregation.sql` (HAVING) |
| Объединить таблицы | `04_joins.sql` |
| Найти строки без пары | `04_joins.sql` (LEFT JOIN + IS NULL) или `05_subqueries_cte.sql` (NOT EXISTS) |
| Подзапрос / CTE | `05_subqueries_cte.sql` |
| Ранжирование строк | `06_window_functions.sql` |
| Накопительная сумма | `06_window_functions.sql` |
| Сравнить с предыдущим значением | `06_window_functions.sql` (LAG) |
| Топ-N в группе | `06_window_functions.sql` |
| Типичные ошибки | `07_examples_and_tips.sql` |
