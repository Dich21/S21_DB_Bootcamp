-- V180__regenerate_content.sql
---------------------------------------------------------
-- Полное восстановление данных country_indicator
-- Автор: Ullertyr
-- Содержит:
-- 1. Очистка таблицы
-- 2. Генерация данных через рекурсивные CTE

-- 1. Полная очистка данных
TRUNCATE TABLE country_indicator;

-- 2. Население страны (2019, 1-е число каждого месяца)
INSERT INTO country_indicator (c_id, i_id, value, actual_date)
WITH
    RECURSIVE
    months AS (SELECT '2019-01-01'::date AS month_date
               UNION ALL
               SELECT (month_date + INTERVAL '1 month')::date
               FROM months
               WHERE month_date < '2019-12-01'::date)
SELECT c.pk_country AS c_id,
       (SELECT pk_indicator FROM indicator WHERE name = 'Population of country') AS i_id,
       FLOOR(RANDOM() * 1000001) AS value,
       month_date AS actual_date
FROM country c, months m
WHERE c.object_type_id IN (SELECT pk_dictionary
                           FROM dictionary
                           WHERE dic_name = 'land' AND value IN ('country', 'territory'));

-- 3. Уровень безработицы (2019, 1-е число каждого месяца)
INSERT INTO country_indicator (c_id, i_id, value, actual_date)
WITH
    RECURSIVE
    months AS (SELECT '2019-01-01'::date AS month_date
               UNION ALL
               SELECT (month_date + INTERVAL '1 month')::date
               FROM months
               WHERE month_date < '2019-12-01'::date)
SELECT c.pk_country AS c_id,
       (SELECT pk_indicator FROM indicator WHERE name = 'Unemployment rate') AS i_id,
       FLOOR(RANDOM() * 101) AS value,
       month_date AS actual_date
FROM country c, months m
WHERE c.object_type_id IN (SELECT pk_dictionary
                           FROM dictionary
                           WHERE dic_name = 'land' AND value IN ('country', 'territory'));

-- 4. Зараженные COVID-19 (май-август 2020)
INSERT INTO country_indicator (c_id, i_id, value, actual_date)
WITH
    RECURSIVE
    days AS (SELECT '2020-05-01'::date AS day_date
             UNION ALL
             SELECT (day_date + INTERVAL '1 day')::date
             FROM days
             WHERE day_date < '2020-08-01'::date)
SELECT c.pk_country AS c_id,
       (SELECT pk_indicator FROM indicator WHERE name = 'Infected humans COVID-19'),
       FLOOR(RANDOM() * 51),
       d.day_date
FROM country c, days d
WHERE c.object_type_id IN
      (SELECT pk_dictionary FROM dictionary WHERE dic_name = 'land' AND value IN ('country', 'territory'));

-- 5. Площадь территории (1 мая 2020)
INSERT INTO country_indicator (c_id, i_id, value, actual_date)
SELECT c.pk_country,
       (SELECT pk_indicator FROM indicator WHERE name = 'Area of the land'),
       FLOOR(RANDOM() * 9990001) + 10000,
       '2020-05-01'::date
FROM country c
WHERE c.object_type_id IN
      (SELECT pk_dictionary FROM dictionary WHERE dic_name = 'land' AND value IN ('country', 'territory'));

COMMENT ON TABLE country_indicator IS 'Данные восстановлены после саботажа';



