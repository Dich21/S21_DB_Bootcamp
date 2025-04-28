-- V010__data_model_generate.sql
---------------------------------------------------------
-- Генерация тестовых данных для модели EAV
-- Автор: Ullertyr
-- Содержит:
-- 1. Вставку исторических данных по населению (2019)
-- 2. Вставку данных по безработице (2019)
-- 3. Вставку ежедневных данных COVID-19 (май-август 2020)
-- 4. Использование generate_series() для временных диапазонов
-- 5. Динамическое получение ID через подзапросы

-- Вставка исторических данных по населению
WITH max_val as (
    SELECT COALESCE(MAX(pk_country_indicator), 0) AS max_id
  FROM country_indicator
)
INSERT INTO country_indicator(pk_country_indicator, c_id, i_id, value, actual_date)
SELECT
    max_val.max_id + row_number() OVER(ORDER BY c.pk_country),
    c.pk_country,
    (SELECT pk_indicator FROM indicator WHERE name = 'Population of country'),
    floor(random()*1000000),
    dates.date
FROM country c, generate_series('2019-01-01'::timestamp,
            CURRENT_DATE::timestamp, '1 month'::interval) as dates(date), max_val
WHERE object_type = 'country';

-- Вставка данных по безработице
WITH max_val as (
    SELECT COALESCE(MAX(pk_country_indicator), 0) AS max_id
  FROM country_indicator
)
INSERT INTO country_indicator(pk_country_indicator, c_id, i_id, value, actual_date)
SELECT
    max_val.max_id + row_number() OVER(ORDER BY c.pk_country),
    c.pk_country,
    (SELECT pk_indicator FROM indicator WHERE name = 'Unemployment rate'),
    floor(random()*100),
    dates.date
FROM country c, generate_series('2019-01-01'::timestamp,
            CURRENT_DATE::timestamp, '1 month'::interval) as dates(date), max_val
WHERE object_type = 'country';

-- Вставка ежедневных данных COVID-19
WITH max_val as (
    SELECT COALESCE(MAX(pk_country_indicator), 0) AS max_id
  FROM country_indicator
)
INSERT INTO country_indicator(pk_country_indicator, c_id, i_id, value, actual_date)
SELECT
    max_val.max_id + row_number() OVER(ORDER BY c.pk_country),
    c.pk_country,
    (SELECT pk_indicator FROM indicator WHERE name = 'Infected humans COVID-19'),
    floor(random()*50),
    dates.date
FROM country c, generate_series('2020-05-01'::timestamp,
            '2020-08-31'::timestamp, '1 day'::interval) as dates(date), max_val
WHERE object_type = 'country';



