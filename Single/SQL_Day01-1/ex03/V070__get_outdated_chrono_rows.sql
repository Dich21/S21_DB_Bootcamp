-- V070__get_outdated_chrono_rows.sql
---------------------------------------------------------
-- Представления для устаревших записей и расчёта плотности
-- Автор: Ullertyr
-- Содержит:
-- 1. Представления outdated для indicator, country, dictionary
-- 2. Генерация данных для "Area of the land"
-- 3. Представление v_average_humans_per_country

-- Представление для устаревших показателей
CREATE OR REPLACE VIEW v_outdated_indicators AS
    SELECT pk_indicator, name, time_start, time_end
    FROM indicator
    WHERE time_end < CURRENT_TIMESTAMP
    ORDER BY pk_indicator DESC;

COMMENT ON VIEW v_outdated_indicators IS 'Неактуальные показатели';
COMMENT ON COLUMN v_outdated_indicators.pk_indicator IS 'ID записи';
COMMENT ON COLUMN v_outdated_indicators.name IS 'Наименование показателя';

CREATE OR REPLACE VIEW v_outdated_countries AS
    SELECT pk_country, name, time_start, time_end
    FROM country
    WHERE time_end < CURRENT_TIMESTAMP
    ORDER BY pk_country DESC;

COMMENT ON VIEW v_outdated_countries IS 'Неактуальные страны/континенты';

CREATE OR REPLACE VIEW v_outdated_dictionary AS
    SELECT pk_dictionary, dic_name, value, time_start, time_end
    FROM dictionary
    WHERE time_end < CURRENT_TIMESTAMP
    ORDER BY pk_dictionary DESC;

COMMENT ON VIEW v_outdated_dictionary IS 'Неактуальные записи общего словаря';

INSERT INTO country_indicator (c_id, i_id, value, actual_date)
    SELECT pk_country,
           (SELECT pk_indicator
            FROM indicator
            WHERE name = 'Area of the land'),
      floor(random() * 10000000) + 10000,
            '2020-05-01'::timestamp
    FROM country c
    WHERE c.object_type_id = (SELECT pk_dictionary FROM dictionary WHERE value = 'country');


-- Представление для плотности населения
CREATE OR REPLACE VIEW v_average_humans_per_country AS
    SELECT c.name as country_name,
           ROUND(
                   (SELECT value::numeric
                    FROM country_indicator
                    WHERE i_id = (SELECT pk_indicator
                                  FROM indicator
                                  WHERE name = 'Population of country')
                    AND actual_date = '2019-05-01'
                    AND c_id = c.pk_country
                    LIMIT 1) /
                    NULLIF((SELECT value::numeric
                    FROM country_indicator
                    WHERE i_id = (SELECT pk_indicator
                                  FROM indicator
                                  WHERE name = 'Area of the land')
                    AND actual_date = '2020-05-01'
                    AND c_id = c.pk_country
                    LIMIT 1), 0), 3) AS density
    FROM country c
    WHERE object_type_id = (SELECT pk_dictionary FROM dictionary WHERE value = 'country')
    ORDER BY c.name;

SELECT * FROM v_average_humans_per_country;

COMMENT ON VIEW v_average_humans_per_country IS 'Плотность населения (чел/км²)';