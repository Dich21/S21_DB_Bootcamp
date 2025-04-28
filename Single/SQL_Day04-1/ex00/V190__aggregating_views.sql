-- V190__aggregating_views.sql
---------------------------------------------------------
-- Создание агрегированных представлений
-- Автор: Ullertyr
-- Содержит:
-- 1. Группировка стран по континентам
-- 2. Фильтрация континентов с >50 стран
-- 3. Поиск дубликатов названий стран
-- 4. Уникальные даты показателей

-- 1. Группировка по континентам
CREATE OR REPLACE VIEW v_country_groupped AS
SELECT continent_name, COUNT(country_name) AS cnt
FROM v_continent_country
GROUP BY continent_name
ORDER BY 1;

COMMENT ON VIEW v_country_groupped IS 'Количество стран по континентам';
COMMENT ON COLUMN v_country_groupped.continent_name IS 'Название континента';
COMMENT ON COLUMN v_country_groupped.cnt IS 'Количество стран';

-- 2. Континенты с более чем 50 странами
CREATE OR REPLACE VIEW v_country_groupped_having_50 AS
SELECT continent_name, COUNT(*) AS cnt
FROM v_continent_country
GROUP BY continent_name
HAVING COUNT(*) > 50;

COMMENT ON VIEW v_country_groupped_having_50 IS 'Континенты с >50 стран';
COMMENT ON COLUMN v_country_groupped_having_50.continent_name IS 'Название континента';
COMMENT ON COLUMN v_country_groupped_having_50.cnt IS 'Количество стран';

-- 3. Дубликаты названий стран
CREATE VIEW v_country_name_duplicates AS
SELECT name
FROM country
GROUP BY name
HAVING COUNT(*) > 1;

COMMENT ON VIEW v_country_name_duplicates IS 'Дубликаты названий стран';
COMMENT ON COLUMN v_country_name_duplicates.name IS 'Название страны';

CREATE OR REPLACE VIEW v_unique_actual_dates AS
SELECT DISTINCT actual_date
FROM country_indicator
ORDER BY 1;

COMMENT ON VIEW v_unique_actual_dates IS 'Уникальные даты показателей';
COMMENT ON COLUMN v_unique_actual_dates.actual_date IS 'Дата измерения';
