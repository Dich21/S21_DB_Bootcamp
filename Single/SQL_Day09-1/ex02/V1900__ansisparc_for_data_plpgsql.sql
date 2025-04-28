-- V1900__ansisparc_for_data_plpgsql.sql
---------------------------------------------------------
-- Создание PL/pgSQL-функции с аналогичной логикой

CREATE OR REPLACE FUNCTION fnc_plpgsql_getting_news_for_word(pword TEXT)
    RETURNS TABLE
            (
                CONTENT TEXT,
                SOURCE_NAME VARCHAR(100),
                TITLE VARCHAR
            )
AS
$$
BEGIN
    RETURN QUERY
        SELECT n.content, n.source_name, n.title
        FROM news_from_earth n
        WHERE n.content LIKE '%' || pword || '%';
END;
$$ LANGUAGE plpgsql;