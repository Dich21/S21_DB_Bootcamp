-- V170__change_content.sql
---------------------------------------------------------
-- Изменение данных по требованию Alien Support Team
-- Автор: Ullertyr
-- Содержит:
-- 1. Удаление данных о безработице за январь и ноябрь 2019
-- 2. Обновление данных для азиатских стран

-- 1. Удаление записей "Unemployment rate" за январь и ноябрь 2019
DELETE
FROM country_indicator
WHERE i_id = (SELECT pk_indicator
              FROM indicator
              WHERE name = 'Unemployment rate')
  AND EXTRACT(YEAR FROM actual_date) = 2019
  AND EXTRACT(MONTH FROM actual_date) IN (1, 11);


-- 2. Обновление значений для стран Азии
UPDATE country_indicator ci
SET value = ci.value::numeric + 100
FROM country c
WHERE ci.c_id = c.pk_country
AND par_id = (SELECT pk_country
              FROM country
              WHERE name = 'Asia'
              AND c.object_type_id = (SELECT pk_dictionary
                                      FROM dictionary
                                      WHERE dic_name = 'land' AND value = 'continent'));

COMMENT ON COLUMN country_indicator.value IS 'Обновлено: значение увеличено на 100 для стран Азии';