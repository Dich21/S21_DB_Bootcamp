-- V1602__add_gin_tsquery.sql
---------------------------------------------------------
-- Создание GIN индекса

CREATE INDEX idx_gin_news_from_earth ON news_from_earth
USING gin (content_vector);