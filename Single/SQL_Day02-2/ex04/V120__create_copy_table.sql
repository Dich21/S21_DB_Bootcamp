-- V120__create_copy_table.sql
---------------------------------------------------------
-- Создание копии таблицы country для континента "Северная Америка"
-- Автор: Ullertyr
-- Содержит:
-- 1. Создание таблицы country_north_america с наследованием структуры
-- 2. Перенос данных с фильтрацией по континенту


-- 1. Создание таблицы с наследованием всех ограничений
CREATE TABLE country_north_america
(
LIKE country INCLUDING ALL);

COMMENT ON TABLE country_north_america IS
    'Копия таблицы country для континента Северная Америка (включая все ограничения)';


-- 2. Вставка данных с фильтрацией через подзапрос
INSERT INTO country_north_america
SELECT *
FROM country c
WHERE c.par_id = (
                 SELECT pk_country
                 FROM country
                 WHERE name = 'North America');

SELECT *
FROM country_north_america;