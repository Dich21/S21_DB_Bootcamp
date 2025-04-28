-- V150__view_getting_fibonacci_countries.sql
---------------------------------------------------------
-- Создание представления для связи чисел Фибоначчи и стран
-- Автор: Ullertyr
-- Содержит:
-- 1. Генерация последовательности Фибоначчи до 2000
-- 2. Соединение с таблицей country через LEFT JOIN

CREATE OR REPLACE VIEW v_fibonacci_country AS
WITH RECURSIVE
    fibanacci AS (SELECT 1 AS n, 1 AS curr_fib, 0 AS prev_fib
                  UNION ALL
                  SELECT n + 1, prev_fib + curr_fib, curr_fib
                  FROM fibanacci
                  WHERE prev_fib + curr_fib <= 2000)
SELECT f.curr_fib as fibonacci, pk_country AS country_id, name AS country_name
FROM fibanacci f
LEFT JOIN country c ON f.curr_fib = c.pk_country
ORDER BY f.curr_fib;

COMMENT ON VIEW v_fibonacci_country IS 'Связь чисел Фибоначчи с ID стран';
COMMENT ON COLUMN v_fibonacci_country.fibonacci IS 'Число Фибоначчи';
COMMENT ON COLUMN v_fibonacci_country.country_id IS 'ID страны (если совпадает с числом)';
COMMENT ON COLUMN v_fibonacci_country.country_name IS 'Название страны';

select * from v_fibonacci_country;