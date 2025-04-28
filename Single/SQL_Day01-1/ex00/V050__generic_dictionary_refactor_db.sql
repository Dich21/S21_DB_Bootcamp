-- V050__generic_dictionary_refactor_db.sql
---------------------------------------------------------
-- Рефакторинг структуры БД: создание общего словаря
-- Автор: Ullertyr
-- Содержит:
-- 1. Создание таблицы dictionary
-- 2. Перенос данных из indicator и country
-- 3. Добавление нового показателя "Area of the land"
-- 4. Модификация таблиц indicator и country


-- 1. Создание таблицы dictionary
CREATE TABLE IF NOT EXISTS dictionary (
    pk_dictionary BIGINT PRIMARY KEY,
    dic_name VARCHAR(50) NOT NULL,
    value VARCHAR(100) NOT NULL,
    order_num INT NOT NULL DEFAULT 0,
    time_start TIMESTAMP NOT NULL DEFAULT '1972-01-01',
    time_end TIMESTAMP NOT NULL DEFAULT '9999-01-01',
    CONSTRAINT uk_dictionary_dic_name_value UNIQUE (dic_name, value),
    CONSTRAINT ch_dictionary_time_range CHECK (
            time_start >= '1972-01-01'
            AND time_end <= '9999-01-01'
            AND time_start <= time_end)
);

COMMENT ON TABLE dictionary IS 'Общий словарь для хранения справочных данных';
COMMENT ON COLUMN dictionary.pk_dictionary IS 'Уникальный идентификатор записи';
COMMENT ON COLUMN dictionary.dic_name IS 'Название под-словаря (например, unit, land)';
COMMENT ON COLUMN dictionary.value IS 'Значение из списка (например, human, percent)';
COMMENT ON COLUMN dictionary.order_num IS 'Порядковый номер для сортировки (по умолчанию 0)';
COMMENT ON COLUMN dictionary.time_start IS 'Начало периода активности записи';
COMMENT ON COLUMN dictionary.time_end IS 'Конец периода активности записи';

-- Перенос данных из indicator (unit)
INSERT INTO dictionary (pk_dictionary, dic_name, value, order_num)
SELECT (SELECT COALESCE(MAX(pk_dictionary), 0) FROM dictionary) + ROW_NUMBER() OVER (),
       'unit', unit,
       CASE unit
           WHEN 'human' THEN 1
           WHEN 'percent' THEN 2
       END
FROM indicator
GROUP BY unit;

-- Перенос данных из country (object_type)
INSERT INTO dictionary (pk_dictionary, dic_name, value, order_num)
SELECT (SELECT COALESCE(MAX(pk_dictionary), 0) FROM dictionary) + ROW_NUMBER() OVER (),
       'land', object_type,
       CASE object_type
           WHEN 'country' THEN 1
           WHEN 'continent' THEN 2
       END
FROM country
GROUP BY object_type;

-- Добавление нового значения "square kilometer"
INSERT INTO dictionary (pk_dictionary, dic_name, value, order_num)
SELECT (SELECT COALESCE(MAX(pk_dictionary), 0) FROM dictionary) + ROW_NUMBER() OVER (),
        'unit', 'square kilometer', 3;

-- Модификация таблицы indicator
ALTER TABLE indicator
    DROP CONSTRAINT IF EXISTS ch_indicator_unit;
ALTER TABLE indicator
    RENAME COLUMN unit TO unit_id;
UPDATE indicator i
    SET unit_id = (SELECT pk_dictionary
                  FROM dictionary d
                  WHERE d.dic_name = 'unit' AND d.value = i.unit_id::TEXT);
ALTER TABLE indicator
    ALTER COLUMN unit_id TYPE BIGINT USING unit_id::bigint;

ALTER TABLE indicator
    ADD CONSTRAINT fk_unit_id_indicator
    FOREIGN KEY (unit_id) REFERENCES dictionary (pk_dictionary)
    ON DELETE RESTRICT ON UPDATE CASCADE;

COMMENT ON COLUMN indicator.unit_id IS 'Ссылка на единицу измерения в словаре';

-- Добавление нового показателя "Area of the land"
INSERT INTO indicator (name, unit_id)
VALUES ('Area of the land',
        (SELECT pk_dictionary
        FROM dictionary
        WHERE dic_name = 'unit' AND value = 'square kilometer'));

-- Модификация таблицы country
ALTER TABLE country
    DROP CONSTRAINT ch_object_type_country;
ALTER TABLE country
    RENAME COLUMN object_type TO object_type_id;
ALTER TABLE country
    ALTER COLUMN object_type_id DROP DEFAULT;
UPDATE country c
    SET object_type_id = (SELECT pk_dictionary
                            FROM dictionary d
                            WHERE d.dic_name = 'land' AND d.value = c.object_type_id::TEXT);
ALTER TABLE country
    ALTER COLUMN object_type_id
    TYPE BIGINT USING (object_type_id::BIGINT);
ALTER TABLE country
    ADD CONSTRAINT fk_object_type_id_country
    FOREIGN KEY (object_type_id) REFERENCES dictionary (pk_dictionary)
    ON DELETE RESTRICT ON UPDATE CASCADE;

COMMENT ON COLUMN country.object_type_id IS 'Ссылка на тип объекта (страна/континент) в словаре';




