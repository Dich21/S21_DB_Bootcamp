-- V100__cte_view.sql
---------------------------------------------------------
-- Реализация CTE для проверки данных COVID-19
-- Автор: Ullertyr
-- Содержит:
-- 1. Представление v_check_country_01_05_2020_COVID_cte (переписанное с CTE)
-- 2. Представление-проверка v_check_country_01_05_2020_COVID_check


-- 1. Основное представление с CTE
CREATE VIEW v_check_country_01_05_2020_covid_cte AS
WITH
    id_indicator_infected_humans_covid AS (
                                          SELECT pk_indicator
                                          FROM indicator
                                          WHERE name = 'Infected humans COVID-19'),
    country_indicator_by_id            AS (
                                          SELECT *
                                          FROM country_indicator
                                          WHERE i_id = (
                                                       SELECT pk_indicator
                                                       FROM id_indicator_infected_humans_covid)
                                            AND actual_date = '2020-05-01')
SELECT c.name, ci.value
FROM country c
LEFT JOIN country_indicator_by_id ci ON c.pk_country = ci.c_id
WHERE c_id IS NULL;

COMMENT ON VIEW v_check_country_01_05_2020_covid_cte IS 'Проверка данных COVID-19 через CTE';
COMMENT ON COLUMN v_check_country_01_05_2020_covid_cte.name IS 'Название страны/континента';
COMMENT ON COLUMN v_check_country_01_05_2020_covid_cte.value IS 'Значение (NULL если отсутствует)';

-- 2. Представление для сравнения данных
CREATE VIEW v_check_country_01_05_2020_covid_check AS
SELECT cte.name AS name_cte,
       prev.value AS name_previous,
       (cte.name IS NOT DISTINCT FROM prev.name) AND
       (cte.value IS NOT DISTINCT FROM prev.value) AS check_row
FROM v_check_country_01_05_2020_covid_cte cte
FULL JOIN v_check_country_01_05_2020_covid prev ON cte.name = prev.name
ORDER BY name_cte NULLS FIRST, name_previous NULLS FIRST;

SELECT *
FROM v_check_country_01_05_2020_covid_check;

COMMENT ON VIEW v_check_country_01_05_2020_covid_check IS 'Сравнение данных CTE и предыдущей версии';
COMMENT ON COLUMN v_check_country_01_05_2020_covid_check.name_cte IS 'Название из CTE-представления';
COMMENT ON COLUMN v_check_country_01_05_2020_covid_check.name_previous IS 'Название из исходного представления';
COMMENT ON COLUMN v_check_country_01_05_2020_covid_check.check_row IS 'Результат проверки (TRUE/FALSE)';