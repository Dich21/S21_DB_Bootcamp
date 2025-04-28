# import_tweets.py
import psycopg2
import json

# Подключение к БД
conn = psycopg2.connect(
    dbname="rush",
    user="rush",
    password="rush",
    host="localhost",
    port="5432",
    options=f"-c search_path=rush01"
)
cur = conn.cursor()

# Чтение и вставка данных
with open('../datasets/elonmask_tweets.txt', 'r', encoding='utf-8') as f:
    for line in f:
        try:
            tweet = json.loads(line.strip())
            cur.execute("""
                INSERT INTO archive_tweets_elonmusk (tweet_document) 
                VALUES (%s::jsonb)
            """, (json.dumps(tweet),))
        except json.JSONDecodeError:
            print(f"Ошибка в строке: {line}")

conn.commit()
cur.close()
conn.close()