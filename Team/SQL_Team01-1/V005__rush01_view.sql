-- V005__rush01_view.sql
---------------------------------------------------------
-- Создание представления для твитов о Tesla
-- Автор: Ullertyr
-- Содержит:
-- 1. Представление для фильтрации твитов, содержащих "tesla" (без учета регистра)

CREATE VIEW v_get_tweet_about_tesla AS
SELECT tweet_document ->> 'Text' AS tweet
FROM archive_tweets_elonmusk
WHERE tweet_document ->> 'Text' ILIKE '%tesla%';

COMMENT ON VIEW rush01.v_get_tweet_about_tesla IS 'Показывает твиты с упоминанием Tesla (регистронезависимый поиск)';