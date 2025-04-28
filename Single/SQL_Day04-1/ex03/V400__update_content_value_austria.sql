-- V400__update_content_value_austria.sql
---------------------------------------------------------
-- UPSERT данных для Австрии и обновление материализованного представления
-- Автор: Ullertyr

INSERT INTO country_indicator (c_id, i_id, value, actual_date)
SELECT (SELECT pk_country FROM country WHERE name = 'Austria'),
       (SELECT pk_indicator FROM indicator WHERE name = 'Infected humans COVID-19'),
       31415926,
       '2020-05-01'::date
ON CONFLICT (c_id, i_id, actual_date)
    DO UPDATE SET value = excluded.value;

-- 2. Обновление материализованного представления
REFRESH MATERIALIZED VIEW mv_country_indicator_infected_humans_covid;
