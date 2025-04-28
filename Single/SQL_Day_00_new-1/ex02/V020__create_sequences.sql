-- V020__create_sequences.sql
---------------------------------------------------------
-- Создание последовательностей для генерации ID
-- Автор: Ullertyr
-- Содержит:
-- 1. Последовательности с шагом 10 для indicator/country/country_indicator
-- 2. Привязка sequence к колонкам ID через DEFAULT
-- 3. Синхронизация sequence с текущим max(id)

-- Последовательность для indicator
CREATE SEQUENCE IF NOT EXISTS seq_indicator
    INCREMENT BY 10
    OWNED BY data.indicator.pk_indicator;

ALTER TABLE indicator
    ALTER COLUMN pk_indicator
    SET DEFAULT nextval('seq_indicator');

SELECT setval('seq_indicator', (SELECT max(pk_indicator) FROM indicator));

-- Последовательность для country
CREATE SEQUENCE IF NOT EXISTS seq_country
    INCREMENT BY 10
    OWNED BY data.country.pk_country;

ALTER TABLE country
    ALTER COLUMN pk_country
    SET DEFAULT nextval('seq_country');

SELECT setval('seq_country', (SELECT max(pk_country) FROM country));

-- Последовательность для country_indicator
CREATE SEQUENCE IF NOT EXISTS seq_country_indicator
    INCREMENT BY 10
    OWNED BY data.country_indicator.pk_country_indicator;

ALTER TABLE country_indicator
    ALTER COLUMN pk_country_indicator
    SET DEFAULT nextval('seq_country_indicator');

SELECT setval('seq_country_indicator', (SELECT max(pk_country_indicator) FROM country_indicator));

SELECT setval('data.seq_indicator', (select max(pk_indicator) from indicator));
