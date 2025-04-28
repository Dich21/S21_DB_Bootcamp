# visualize_top_words.py
import psycopg2
import matplotlib.pyplot as plt

conn = psycopg2.connect(dbname="rush", user="rush", password="rush", host="localhost", port="5432",
                        options=f"-c search_path=rush01")
cur = conn.cursor()

cur.execute("""
    WITH
    filtered_tweets AS (SELECT REGEXP_REPLACE(tweet, '[^\w\s]', '', 'g') AS cleaned_text
                        FROM v_get_tweet_about_tesla),
    words           AS (SELECT LOWER(UNNEST(REGEXP_SPLIT_TO_ARRAY(cleaned_text, '\s+'))) AS word
                        FROM filtered_tweets)
    SELECT word, COUNT(*) AS frequency
    FROM words
    WHERE word NOT IN (SELECT stop_words.word FROM stop_words) AND word != ''
    GROUP BY word
    ORDER BY frequency DESC
    LIMIT 20;
""")

data = cur.fetchall()
words = [row[0] for row in data]
freq = [row[1] for row in data]

plt.barh(words, freq)
plt.title('TOP-20 слов в твитах о Tesla')
plt.gca().invert_yaxis()
plt.savefig('top_20_words.png', bbox_inches='tight')
