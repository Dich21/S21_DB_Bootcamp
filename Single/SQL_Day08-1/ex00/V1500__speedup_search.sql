-- V1500__speedup_search.sql
-- Создание таблицы news_from_earth и заполнение тестовыми данными
-- Автор: Ullertyr
-- Содержит:
-- 1. Создание таблицы
-- 2. Вставка 5 исходных записей
-- 3. Дублирование до 950 строк

CREATE TABLE IF NOT EXISTS news_from_earth
(
    content TEXT,
    source_name VARCHAR(100),
    title VARCHAR,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TEMP TABLE temp_table
(
    content TEXT,
    source_name VARCHAR(100),
    title VARCHAR
);

COPY temp_table (source_name, title, content)
FROM '/Users/yaroslavkuklin/Library/Application Support/Postgres/BD_1/news_data.csv'
WITH (FORMAT CSV, HEADER);

INSERT INTO news_from_earth (content, source_name, title)
SELECT content, source_name, title
FROM temp_table
CROSS JOIN GENERATE_SERIES(1, 190);

EXPLAIN ANALYZE
SELECT content, source_name, title
FROM news_from_earth
WHERE content ~* 'women'


