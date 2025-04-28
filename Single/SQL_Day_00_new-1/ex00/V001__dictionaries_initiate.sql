-- V001__dictionaries_initiate.sql
---------------------------------------------------------
-- Начальное заполнение справочников для тестирования
-- Автор: Ullertyr
-- Содержит:
-- 1. Добавление 7 континентов
-- 2. Базовые показатели (population, unemployment, COVID)
-- 3. Пример иерархии стран (параметр par_id)

INSERT INTO indicator (pk_indicator, name, unit)
VALUES
    (1, 'Population of country', 'human'),
    (2, 'Unemployment rate', 'percent'),
    (3, 'Infected humans COVID-19', 'human');


CREATE TEMP TABLE temp_countries (
    id INTEGER,
    country_name TEXT,
    continent_name TEXT
);

COPY temp_countries FROM '/Users/yaroslavkuklin/Documents/Prog/21_projects/DB_Bootcamp/Single/SQL_Day_00_new-1/src/ex00/list_of_countries_with_numbers.csv'
WITH (FORMAT CSV, HEADER true, DELIMITER ',');

INSERT INTO data.country (pk_country, name, object_type)
VALUES
    (1, 'Africa', 'continent'),
    (2, 'Asia', 'continent'),
    (3, 'Europe', 'continent'),
    (4, 'North America', 'continent'),
    (5, 'South America', 'continent'),
    (6, 'Australia', 'continent'),
    (7, 'Antarctica', 'continent');


INSERT INTO data.country (pk_country, name, par_id, object_type)
SELECT
    (SELECT MAX(pk_country) FROM data.country) + ROW_NUMBER() OVER () AS id,
    country_name,
    (SELECT country.pk_country FROM data.country WHERE country.name = continent_name AND country.object_type = 'continent'),
    'country'
FROM temp_countries;

DROP TABLE temp_countries;