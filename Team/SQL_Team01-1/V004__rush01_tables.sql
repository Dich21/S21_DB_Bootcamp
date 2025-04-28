-- V004__rush01_tables.sql
---------------------------------------------------------
-- Создание таблицы для хранения твитов Илона Маска в формате JSONB
-- Автор: Ullertyr
-- Содержит:
-- 1. Создание таблицы archive_tweets_elonmusk
-- 2. Загрузка данных из CSV-архива
-- 3. Комментарии к структуре таблицы

--
CREATE TABLE archive_tweets_elonmusk
(
    tweet_id UUID NOT NULL DEFAULT uuid_generate_v4(),
    tweet_document JSONB NOT NULL
);

COMMENT ON TABLE archive_tweets_elonmusk IS 'Хранилище твитов Илона Маска в формате JSONB';
COMMENT ON COLUMN archive_tweets_elonmusk.tweet_id IS 'Уникальный идентификатор твита (UUID v4)';
COMMENT ON COLUMN archive_tweets_elonmusk.tweet_document IS 'Документ твита в формате JSONB';