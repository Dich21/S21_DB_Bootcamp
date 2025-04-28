-- V200__new_aggregating_views.sql
---------------------------------------------------------
-- Агрегация данных по безработице и COVID-19
-- Автор: Ullertyr

-- 1. Статистика по безработице
CREATE OR REPLACE VIEW v_country_indicator_unemployment_rate AS
SELECT c.name AS name,
       MAX(ci.value) AS maximum,
       MIN(ci.value) AS minimum,
       ROUND(AVG(ci.value), 2) AS average,
       COUNT(*) AS amount,
       (MAX(ci.value) - MIN(ci.value)) AS range
FROM country_indicator ci
JOIN country c ON ci.c_id = c.pk_country
WHERE i_id = (SELECT pk_indicator FROM indicator WHERE name = 'Unemployment rate')
GROUP BY c.name
ORDER BY c.name;

COMMENT ON VIEW v_country_indicator_unemployment_rate IS 'Статистика по безработице';
COMMENT ON COLUMN v_country_indicator_unemployment_rate.name IS 'Название страны';
COMMENT ON COLUMN v_country_indicator_unemployment_rate.maximum IS 'Максимальное значение';
COMMENT ON COLUMN v_country_indicator_unemployment_rate.minimum IS 'Минимальное значение';

-- 2. Топ-10 стран по COVID-19
CREATE OR REPLACE VIEW v_country_indicator_infected_humans_covid AS
SELECT c.name AS name,
       MAX(ci.value) AS maximum,
       MIN(ci.value) AS minimum,
       ROUND(AVG(ci.value), 2) AS average,
       COUNT(*) AS amount,
       SUM(ci.value) AS total
FROM country_indicator ci
JOIN country c on ci.c_id = c.pk_country
WHERE ci.i_id = (SELECT pk_indicator FROM indicator WHERE name = 'Infected humans COVID-19')
GROUP BY c.name
ORDER BY total DESC
LIMIT 10;

COMMENT ON VIEW v_country_indicator_infected_humans_covid IS 'Топ-10 стран по COVID-19';
COMMENT ON COLUMN v_country_indicator_infected_humans_covid.total IS 'Суммарное количество зараженных';