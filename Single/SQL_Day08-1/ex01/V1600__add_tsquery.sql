-- V1600__add_tsquery.sql
---------------------------------------------------------
-- Добавление tsvector колонки и инициализация данных

ALTER TABLE news_from_earth
ADD COLUMN content_vector tsvector;

UPDATE news_from_earth
SET content_vector = to_tsvector('english', content);