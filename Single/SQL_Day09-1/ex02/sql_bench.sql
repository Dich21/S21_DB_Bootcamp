SELECT *
FROM fnc_sql_getting_news_for_word('test' || (RANDOM() * 1000)::TEXT);
