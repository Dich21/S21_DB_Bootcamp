-- V300__create_materialized_view.sql
---------------------------------------------------------
-- Создание материализованного представления для COVID-19 данных
-- Автор: Ullertyr

CREATE MATERIALIZED VIEW mv_country_indicator_infected_humans_covid AS
SELECT c.name AS name,
       MAX(ci.value) AS maximum,
       MIN(ci.value) AS minimum,
       ROUND(AVG(ci.value), 2) AS average,
       COUNT(*) AS amount,
       SUM(ci.value) AS total
FROM country_indicator ci
JOIN country c ON ci.c_id = c.pk_country
WHERE ci.i_id = (SELECT pk_indicator FROM indicator WHERE name = 'Infected humans COVID-19')
GROUP BY c.name
ORDER BY total DESC
WITH NO DATA;

COMMENT ON MATERIALIZED VIEW mv_country_indicator_infected_humans_covid
    IS 'Топ стран по COVID-19 (материализованное представление)';
COMMENT ON COLUMN mv_country_indicator_infected_humans_covid.name IS 'Название страны';
COMMENT ON COLUMN mv_country_indicator_infected_humans_covid.total IS 'Суммарное количество зараженных';