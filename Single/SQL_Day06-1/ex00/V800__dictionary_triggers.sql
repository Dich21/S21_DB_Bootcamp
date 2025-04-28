-- V800__dictionary_triggers.sql
---------------------------------------------------------
-- Логирование изменений в таблице dictionary
-- Автор: Ullertyr
-- Содержит:
-- 1. Таблица dictionary_history
-- 2. Триггерная функция и триггер

-- 1. Таблица dictionary_history
CREATE TABLE IF NOT EXISTS dictionary_history
(
    id serial PRIMARY KEY,
    time_modified timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    action_type char(1) NOT NULL,
    user_modified varchar(100) NOT NULL,
    row_id bigint NOT NULL,
    dic_name varchar(50) NOT NULL,
    value varchar(100) NOT NULL,
    order_num int NOT NULL,
    time_start timestamp NOT NULL,
    time_end timestamp NOT NULL,
    CONSTRAINT ch_dictionary_history_action_type CHECK (action_type IN ('I', 'U', 'D'))
);

COMMENT ON TABLE data.dictionary_history IS 'История изменений таблицы dictionary';
COMMENT ON COLUMN data.dictionary_history.id IS 'Первичный ключ';
COMMENT ON COLUMN data.dictionary_history.time_modified IS 'Время изменения записи (по умолчанию текущее время)';
COMMENT ON COLUMN data.dictionary_history.action_type IS 'Тип операции: I=INSERT, U=UPDATE, D=DELETE';
COMMENT ON COLUMN data.dictionary_history.user_modified IS 'Пользователь, выполнивший изменение';
COMMENT ON COLUMN data.dictionary_history.row_id IS 'ID исходной записи из таблицы dictionary';
COMMENT ON COLUMN data.dictionary_history.dic_name IS 'Название словаря';
COMMENT ON COLUMN data.dictionary_history.value IS 'Значение записи';
COMMENT ON COLUMN data.dictionary_history.order_num IS 'Порядковый номер';
COMMENT ON COLUMN data.dictionary_history.time_start IS 'Время начала действия записи';
COMMENT ON COLUMN data.dictionary_history.time_end IS 'Время окончания действия записи';

-- 2. Триггерная функция и триггер
CREATE OR REPLACE FUNCTION dictionary_history_trigger()
RETURNS TRIGGER AS $$
    BEGIN
        IF (TG_OP = 'INSERT') THEN
            INSERT INTO dictionary_history(action_type, user_modified, row_id, dic_name, value, order_num, time_start, time_end)
            VALUES ('I', current_user, NEW.pk_dictionary, NEW.dic_name, NEW.value, NEW.order_num, NEW.time_start, NEW.time_end);
        ELSEIF (TG_OP = 'UPDATE') THEN
            INSERT INTO dictionary_history(action_type, user_modified, row_id, dic_name, value, order_num, time_start, time_end)
            VALUES ('U', current_user, NEW.pk_dictionary, NEW.dic_name, NEW.value, NEW.order_num, NEW.time_start, NEW.time_end);
        ELSEIF (TG_OP = 'DELETE') THEN
            INSERT INTO dictionary_history(action_type, user_modified, row_id, dic_name, value, order_num, time_start, time_end)
            VALUES ('D', current_user, OLD.pk_dictionary, OLD.dic_name, OLD.value, OLD.order_num, OLD.time_start, OLD.time_end);
        END IF;
        RETURN NULL;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER dictionary_history_trigger
AFTER INSERT OR UPDATE OR DELETE ON dictionary
FOR EACH ROW EXECUTE FUNCTION dictionary_history_trigger();

-- INSERT INTO dictionary (pk_dictionary, dic_name, value) VALUES (20000, 'test', 'test');
-- UPDATE dictionary SET value = 'new_value' WHERE pk_dictionary = 20000;
-- DELETE FROM dictionary WHERE pk_dictionary = 20000;
--
-- select * from dictionary_history
