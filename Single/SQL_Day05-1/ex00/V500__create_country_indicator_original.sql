-- V500__create_country_indicator_original.sql
---------------------------------------------------------
-- Создание представления v_country_indicator_original
-- Автор: Ullertyr
-- Содержит:
-- 1. Представление для доступа к данным country_indicator
-- 2. Комментарий к объекту

CREATE OR REPLACE VIEW v_country_indicator_original AS
SELECT *
FROM country_indicator;

COMMENT ON VIEW data.v_country_indicator_original IS
'Base view for benchmarking against country_indicator table';