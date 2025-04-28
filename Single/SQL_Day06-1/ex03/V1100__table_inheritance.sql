-- V1100__table_inheritance.sql
---------------------------------------------------------
-- Распределение данных через наследование таблиц
-- Автор: Ullertyr
-- Содержит:
-- 1. Создание мастер-таблицы country_indicator_master
-- 2. Триггер для автоматического создания дочерних таблиц
-- 3. Копирование данных из country_indicator

-- 1. Создание мастер-таблицы country_indicator_master
CREATE TABLE IF NOT EXISTS country_indicator_master
(
pk_country_indicator_master serial PRIMARY KEY,
c_id bigint NOT NULL,
i_id bigint NOT NULL,
value numeric NOT NULL,
actual_date date NOT NULL,

CONSTRAINT fk_c_id_country FOREIGN KEY (c_id) REFERENCES country (pk_country),
CONSTRAINT fk_i_id_indicator FOREIGN KEY (i_id) REFERENCES indicator (pk_indicator));

COMMENT ON TABLE data.country_indicator_master IS 'Главная таблица для распределения данных';
COMMENT ON COLUMN data.country_indicator_master.pk_country_indicator_master IS 'Первичный ключ';
COMMENT ON COLUMN data.country_indicator_master.c_id IS 'ID страны';
COMMENT ON COLUMN data.country_indicator_master.i_id IS 'ID показателя';
COMMENT ON COLUMN data.country_indicator_master.value IS 'Значение показателя';
COMMENT ON COLUMN data.country_indicator_master.actual_date IS 'Дата актуальности данных';


-- 2. Триггер для автоматического создания дочерних таблиц
CREATE OR REPLACE FUNCTION fnc_trg_inherited_country_indicator_master()
    RETURNS trigger AS
$$
DECLARE
    child_table text := FORMAT('country_indicator_master_%s', new.c_id);
BEGIN
    IF NOT EXISTS (SELECT 1
                   FROM pg_tables
                   WHERE schemaname = 'data'
                     AND tablename = child_table) THEN
        EXECUTE FORMAT('
            CREATE TABLE data.%I (
                CONSTRAINT ch_%s CHECK (c_id = %L),
                CONSTRAINT uk_%s UNIQUE (c_id, i_id, actual_date)
            ) INHERITS (data.country_indicator_master)',
                       child_table,
                       child_table, new.c_id,
                       child_table
                );
    END IF;

    EXECUTE FORMAT('
                    INSERT INTO data.%I (c_id, i_id, actual_date, value)
                       VALUES($1, $2, $3, $4)', child_table)
        USING new.c_id, new.i_id, new.actual_date, new.value;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_inherited_country_indicator_master
BEFORE INSERT ON data.country_indicator_master
FOR EACH ROW EXECUTE FUNCTION data.fnc_trg_inherited_country_indicator_master();

-- 3. Копирование данных из country_indicator
INSERT INTO country_indicator_master (c_id, i_id, actual_date, value)
SELECT c_id, i_id, actual_date, value
FROM country_indicator;


-- 4. Процедура удаления всех дочерних таблиц и мастер-таблицы
CREATE OR REPLACE PROCEDURE data.p_drop_all_country_indicator_tables()
    LANGUAGE plpgsql
AS
$$
DECLARE
    child_table_record record;
BEGIN
    FOR child_table_record IN (SELECT c.relname AS table_name
                               FROM pg_inherits i
                               JOIN
                               pg_class c ON i.inhrelid = c.oid
                               WHERE i.inhparent = 'data.country_indicator_master'::regclass)
        LOOP
            EXECUTE FORMAT('DROP TABLE IF EXISTS data.%I CASCADE', child_table_record.table_name);
            RAISE NOTICE 'Таблица data.% удалена', child_table_record.table_name;
        END LOOP;

    -- Удаление мастер-таблицы
    DROP TABLE IF EXISTS data.country_indicator_master CASCADE;
    RAISE NOTICE 'Мастер-таблица data.country_indicator_master удалена';
END;
$$;

-- CALL p_drop_all_country_indicator_tables();