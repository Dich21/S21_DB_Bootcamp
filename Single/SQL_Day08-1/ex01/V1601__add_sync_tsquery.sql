-- V1601__add_sync_tsquery.sql
---------------------------------------------------------
-- Триггерная функция для синхронизации

CREATE OR REPLACE FUNCTION fnc_sync_content_vector()
    RETURNS TRIGGER AS
$$
BEGIN
    NEW.content_vector := to_tsvector('russian', NEW.content);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER sync_content_vector_trigger
    BEFORE INSERT OR UPDATE
    ON news_from_earth
    FOR EACH ROW
EXECUTE FUNCTION fnc_sync_content_vector();

-- Тестовые данные с проверкой триггера
INSERT INTO news_from_earth (content, source_name, title)
VALUES ('Many men, many minds', 'Test#1', 'Test#1');

INSERT INTO news_from_earth (content, source_name, title)
VALUES ('', 'Test#2', 'Test#2');

UPDATE news_from_earth
SET content = 'It is never too late to learn'
WHERE title = 'Test#2';