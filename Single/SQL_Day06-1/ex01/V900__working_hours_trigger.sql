-- V900__working_hours_trigger.sql
---------------------------------------------------------
-- Триггер для ограничения изменений в рабочее время
-- Автор: Ullertyr
-- Содержит:
-- 1. Триггерная функция проверки времени
-- 2. Триггер на таблице dictionary

-- 1. Триггерная функция проверки времени
CREATE OR REPLACE FUNCTION fnc_trg_dictionary_check_working_hours()
    RETURNS trigger AS
$$
BEGIN
    IF CURRENT_TIME BETWEEN '00:00:00' AND '23:59:59'
        AND CURRENT_TIME NOT BETWEEN '00:00:00' AND '00:00:01' THEN
        RAISE EXCEPTION 'Changing data is impossible! You have 1 second at midnight to make a change!';
    END IF;
    RETURN (CASE tg_op WHEN 'DELETE' THEN old ELSE new END);
END;
$$ LANGUAGE plpgsql;

-- 2. Триггер на таблице dictionary
CREATE OR REPLACE TRIGGER trg_dictionary_check_working_hours
    BEFORE INSERT OR UPDATE OR DELETE
    ON dictionary
    FOR EACH ROW
EXECUTE FUNCTION fnc_trg_dictionary_check_working_hours();

SELECT *
FROM dictionary;

