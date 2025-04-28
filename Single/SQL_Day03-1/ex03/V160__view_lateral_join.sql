-- V160__view_lateral_join.sql
---------------------------------------------------------
-- Создание представления с использованием LATERAL JOIN
-- Автор: Ullertyr
-- Содержит:
-- 1. Генерацию чисел Фибоначчи до 2000
-- 2. Фильтрацию стран через словарь
-- 3. Соединение LATERAL для выборки только стран

CREATE OR REPLACE VIEW v_fibonacci_country_lateral AS
WITH
    RECURSIVE
    fibanacci AS (SELECT 1 AS n, 1 AS curr_fib, 0 AS prev_fib
                  UNION ALL
                  SELECT n + 1, prev_fib + curr_fib, curr_fib
                  FROM fibanacci
                  WHERE prev_fib + curr_fib <= 2000)
SELECT f.curr_fib AS fibonacci, c.pk_country AS country_id, c.name AS country_name
FROM fibanacci f
LEFT JOIN LATERAL (SELECT pk_country, name
                   FROM country
                   WHERE pk_country = f.curr_fib
                     AND object_type_id = (SELECT pk_dictionary
                                           FROM dictionary
                                           WHERE dic_name = 'land'
                                             AND value = 'country')) c ON TRUE
ORDER BY f.curr_fib;

select * from v_fibonacci_country_lateral;