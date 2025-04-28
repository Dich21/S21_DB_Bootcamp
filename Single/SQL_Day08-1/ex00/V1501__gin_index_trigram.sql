-- V1501__gin_index_trigram.sql
---------------------------------------------------------
-- Создание расширения и GIN индекса

CREATE EXTENSION IF NOT EXISTS pg_trgm;
create index idx_news_from_earth_gin on news_from_earth using gin (content gin_trgm_ops);