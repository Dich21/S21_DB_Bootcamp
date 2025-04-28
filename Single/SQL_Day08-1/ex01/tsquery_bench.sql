SELECT content, source_name, title
FROM news_from_earth
WHERE content_vector @@ TO_TSQUERY('english', 'woman');