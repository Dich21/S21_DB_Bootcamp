-- V040__alter_tables_by_cc.sql
---------------------------------------------------------
-- Добавление проверочных ограничений
-- Автор: Ullertyr
-- Содержит:
-- 1. CHECK-констрейнты для временных диапазонов
-- 2. Валидация допустимых значений unit и object_type
-- 3. Приведение value к NOT NULL

ALTER TABLE indicator
ADD CONSTRAINT ch_indicator_time_range
    CHECK (time_start >= '1970-01-01' and time_end <= '9999-01-01'),
ADD CONSTRAINT ch_indicator_unit
    CHECK (unit IN ('human', 'percent'));

ALTER TABLE country
ADD CONSTRAINT ch_country_time_range
    CHECK (time_start >= '1970-01-01' and time_end <= '9999-01-01'),
ADD CONSTRAINT ch_object_type_country
    CHECK (object_type IN ('country', 'continent'));

ALTER TABLE country_indicator
    ALTER COLUMN value SET NOT NULL,
ADD CONSTRAINT ch_country_indicator_value
    CHECK (value >= 0);


