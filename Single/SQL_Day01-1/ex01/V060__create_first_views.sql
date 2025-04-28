-- V060__create_first_views.sql
---------------------------------------------------------
-- Создание представлений для под-словарей
-- Автор: Ullertyr
-- Содержит:
-- 1. Представление для единиц измерения (unit)
-- 2. Представление для типов объектов (land)
-- 3. Фильтрацию актуальных записей через временной диапазон
-- 4. Сортировку по order_num


-- Представление для единиц измерения (unit)
CREATE OR REPLACE VIEW v_dictionary_unit AS
    SELECT
        pk_dictionary,
        value AS unit_value
    FROM dictionary
    WHERE dic_name = 'unit' AND CURRENT_TIMESTAMP BETWEEN time_start AND time_end
    ORDER BY order_num;


COMMENT ON VIEW v_dictionary_unit IS 'Актуальные единицы измерения из словаря';
COMMENT ON COLUMN v_dictionary_unit.pk_dictionary IS 'ID записи словаря';
COMMENT ON COLUMN v_dictionary_unit.unit_value IS 'Значение единицы измерения';

-- Представление для типов объектов (land)
CREATE OR REPLACE VIEW v_dictionary_land AS
    SELECT
        pk_dictionary,
        value AS land_value
    FROM dictionary
    WHERE dic_name = 'land' AND CURRENT_TIMESTAMP BETWEEN time_start AND time_end
    ORDER BY order_num;

COMMENT ON VIEW v_dictionary_land IS 'Актуальные типы объектов (страна/континент)';
COMMENT ON COLUMN v_dictionary_land.pk_dictionary IS 'ID записи словаря';
COMMENT ON COLUMN v_dictionary_land.land_value IS 'Тип географического объекта';