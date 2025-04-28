-- V110__views_in_exists.sql
---------------------------------------------------------
-- Поиск неиспользуемых индикаторов через NOT EXISTS и NOT IN
-- Автор: Ullertyr
-- Содержит:
-- 1. Представление v_missing_indicators_exists (NOT EXISTS)
-- 2. Представление v_missing_indicators_in (NOT IN)

-- 1. Решение через NOT EXISTS
CREATE OR REPLACE VIEW v_missing_indicators_exists AS
SELECT *
FROM indicator i
WHERE NOT EXISTS
      (
      SELECT 1
      FROM country_indicator ci
      WHERE ci.i_id = i.pk_indicator);

SELECT *
FROM v_missing_indicators_exists;

COMMENT ON VIEW v_missing_indicators_exists IS 'Индикаторы без связанных данных (NOT EXISTS)';
COMMENT ON COLUMN v_missing_indicators_exists.pk_indicator IS 'ID индикатора';
COMMENT ON COLUMN v_missing_indicators_exists.name IS 'Название индикатора';
COMMENT ON COLUMN v_missing_indicators_exists.unit_id IS 'Ссылка на единицу измерения';

-- 2. Решение через NOT IN
CREATE OR REPLACE VIEW v_missing_indicators_in AS
SELECT *
FROM indicator
WHERE indicator.pk_indicator NOT IN (
                                    SELECT DISTINCT i_id
                                    FROM country_indicator
                                    WHERE i_id IS NOT NULL);

SELECT *
FROM v_missing_indicators_in;

COMMENT ON VIEW v_missing_indicators_in IS 'Индикаторы без связанных данных (NOT IN)';
COMMENT ON COLUMN v_missing_indicators_in.pk_indicator IS 'ID индикатора';
COMMENT ON COLUMN v_missing_indicators_in.name IS 'Название индикатора';
COMMENT ON COLUMN v_missing_indicators_in.unit_id IS 'Ссылка на единицу измерения';