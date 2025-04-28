-- V1800__ansisparc_for_data.sql
---------------------------------------------------------
-- Создание параметризованной SQL-функции для поиска новостей

CREATE OR REPLACE FUNCTION fnc_sql_getting_news_for_word(pword TEXT)
    RETURNS TABLE
            (
                CONTENT TEXT,
                SOURCE_NAME VARCHAR(100),
                TITLE VARCHAR
            )
AS
$$
SELECT content, source_name, title
FROM news_from_earth
WHERE content LIKE '%' || pword || '%'
$$ LANGUAGE sql;

SELECT *
FROM fnc_sql_getting_news_for_word('rows');