-- V090__new_additional_views.sql
---------------------------------------------------------
-- Создание дополнительных представлений с использованием JOIN
-- Автор: Ullertyr
-- Содержит:
-- 1. Представление v_country_indicator (INNER JOIN)
-- 2. Представление v_continent_country (SELF JOIN)
-- 3. Представление v_check_country_01_05_2020_COVID (LEFT JOIN)
-- 4. Обновление v_average_humans_per_country (JOIN вместо подзапросов)

-- 1. Представление v_country_indicator (INNER JOIN)
CREATE OR REPLACE VIEW v_country_indicator AS
SELECT c.name AS country_name, i.name AS indicator_name, value, actual_date
FROM country_indicator ci
JOIN country c ON ci.c_id = c.pk_country
JOIN indicator i ON ci.i_id = i.pk_indicator
ORDER BY c.name, i.name, ci.actual_date DESC;

SELECT *
FROM v_country_indicator;

COMMENT ON VIEW v_country_indicator IS 'Связь стран и индикаторов с сортировкой по дате';
COMMENT ON COLUMN v_country_indicator.country_name IS 'Название страны';
COMMENT ON COLUMN v_country_indicator.indicator_name IS 'Название индикатора';
COMMENT ON COLUMN v_country_indicator.value IS 'Значение';
COMMENT ON COLUMN v_country_indicator.actual_date IS 'Дата актуальности';

-- 2. Иерархия континент-страна
CREATE OR REPLACE VIEW v_continent_country AS
SELECT c2.name AS continent_name, c.name AS country_name
FROM country c
JOIN country c2 ON c.par_id = c2.pk_country
WHERE c2.name IN (SELECT name FROM country c3 WHERE c3.par_id IS NULL)
ORDER BY c2.name, c.name;

SELECT *
FROM v_continent_country;

COMMENT ON VIEW v_continent_country IS 'Иерархия континентов и стран';
COMMENT ON COLUMN v_continent_country.continent_name IS 'Название континента';
COMMENT ON COLUMN v_continent_country.country_name IS 'Название страны';

-- 3 Представление v_check_country_01_05_2020_COVID (LEFT JOIN)

CREATE OR REPLACE VIEW v_check_country_01_05_2020_covid AS
SELECT c.name, ci.value
FROM country c
LEFT JOIN (
          SELECT c_id, value
          FROM country_indicator
          WHERE i_id = (
                       SELECT pk_indicator
                       FROM indicator
                       WHERE name = 'Infected humans COVID-19')
            AND actual_date = '2020-05-01') ci ON c.pk_country = ci.c_id
WHERE c_id IS NULL
ORDER BY c.pk_country;

SELECT *
FROM v_check_country_01_05_2020_covid;

COMMENT ON VIEW v_check_country_01_05_2020_covid IS 'Страны без данных о COVID-19 на 01.05.2020';
COMMENT ON COLUMN v_check_country_01_05_2020_covid.name IS 'Название страны/континента';
COMMENT ON COLUMN v_check_country_01_05_2020_covid.value IS 'Значение (только NULL)';

-- 4. Обновление v_average_humans_per_country (JOIN вместо подзапросов)
CREATE OR REPLACE VIEW v_average_humans_per_country AS
SELECT c.name AS country_name, ROUND(pop.value::numeric / NULLIF(l.value::numeric, 0), 3) AS density
FROM country c
LEFT JOIN (
          SELECT c_id, value
          FROM country_indicator
          WHERE i_id = (
                       SELECT pk_indicator
                       FROM indicator
                       WHERE name = 'Population of country')
            AND actual_date = '2019-05-01') pop ON c.pk_country = pop.c_id
LEFT JOIN (
          SELECT c_id, value
          FROM country_indicator
          WHERE i_id = (
                       SELECT pk_indicator
                       FROM indicator
                       WHERE name = 'Area of the land')
            AND actual_date = '2020-05-01') l ON c.pk_country = l.c_id
WHERE c.object_type_id =
      (
      SELECT pk_dictionary FROM dictionary WHERE dic_name = 'land' AND value = 'country')
ORDER BY c.name;

COMMENT ON VIEW v_average_humans_per_country IS 'Расчет плотности населения (население/площадь)';
COMMENT ON COLUMN v_average_humans_per_country.country_name IS 'Название страны';
COMMENT ON COLUMN v_average_humans_per_country.density IS 'Плотность (чел/км²), округлено до 3 знаков';




