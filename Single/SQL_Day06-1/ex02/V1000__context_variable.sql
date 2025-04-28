-- V1000__context_variable.sql
---------------------------------------------------------
-- Модификация триггера для обхода ограничений через контекстную переменную
-- Автор: Ullertyr
-- Содержит:
-- 1. Обновленная триггерная функция с проверкой переменной aliens.pass

DROP FUNCTION IF EXISTS fnc_trg_dictionary_check_working_hours() CASCADE;

CREATE FUNCTION fnc_trg_dictionary_check_working_hours()
    RETURNS trigger AS
$$
DECLARE
    secret_pass text;
BEGIN
    BEGIN
        secret_pass := CURRENT_SETTING('aliens.pass');
    EXCEPTION
        WHEN undefined_object THEN
            secret_pass := NULL;
    END;
    IF secret_pass = 'SECRET' THEN
        RETURN (CASE tg_op WHEN 'DELETE' THEN old ELSE new END);
    END IF;

    IF CURRENT_TIME BETWEEN '00:00:00' AND '23:59:59'
        AND CURRENT_TIME NOT BETWEEN '00:00:00' AND '00:00:01' THEN
        RAISE EXCEPTION 'Changing data is impossible! You have 1 second at midnight to make a change!';
    END IF;
    RETURN (CASE tg_op WHEN 'DELETE' THEN old ELSE new END);
END;
$$ LANGUAGE plpgsql;