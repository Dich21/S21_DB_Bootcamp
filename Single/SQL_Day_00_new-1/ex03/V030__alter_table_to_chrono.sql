-- V030__alter_table_to_chrono.sql
---------------------------------------------------------
-- Добавление хронологических колонок в справочники
-- Автор: Ullertyr
-- Содержит:
-- 1. Добавление time_start/time_end с дефолтными значениями
-- 2. NOT NULL констрейнты
-- 3. Документирование через COMMENT ON

ALTER TABLE indicator
ADD COLUMN time_start TIMESTAMP NOT NULL DEFAULT '1970-01-01',
ADD COLUMN time_end TIMESTAMP NOT NULL DEFAULT '9999-01-01';

COMMENT ON COLUMN indicator.time_start IS 'Начало активности записи (контакт с человечеством)';
COMMENT ON COLUMN indicator.time_end IS 'Конец активности записи (по умолчанию 9999 год)';

ALTER TABLE country
ADD COLUMN time_start TIMESTAMP NOT NULL DEFAULT '1970-01-01',
ADD COLUMN time_end TIMESTAMP NOT NULL DEFAULT '9999-01-01';

COMMENT ON COLUMN country.time_start IS 'Начало активности записи (контакт с человечеством)';
COMMENT ON COLUMN country.time_end IS 'Конец активности записи (по умолчанию 9999 год)';


