-- V130__drop_after_refactoring.sql
---------------------------------------------------------
-- Удаление устаревших объектов после рефакторинга
-- Автор: Ullertyr
-- Содержит:
-- 1. Удаление представлений COVID и словарей
-- 2. Удаление временной таблицы Северной Америки

-- 1. Каскадное удаление представлений
DROP VIEW IF EXISTS
    v_check_country_01_05_2020_covid,
    v_dictionary_intersect,
    v_dictionary_minus,
    v_dictionary_symmetric_minus,
    v_dictionary
CASCADE;

-- 2. Удаление временной таблицы с континентом
DROP TABLE IF EXISTS country_north_america CASCADE;
