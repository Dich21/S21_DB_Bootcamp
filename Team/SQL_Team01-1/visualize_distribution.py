import psycopg2
import matplotlib.pyplot as plt
import numpy as np

conn = psycopg2.connect(dbname="rush", user="rush", password="rush", host="localhost")
cur = conn.cursor()
cur.execute("SELECT month_year, tweet_count FROM rush01.v_get_distribution_tweet_by_month_year")
data = cur.fetchall()
cur.close()
conn.close()

dates = [row[0] for row in data]
counts = [row[1] for row in data]
plt.figure(figsize=(14, 7))
bars = plt.bar(dates, counts, color='dodgerblue')

for bar in bars:
    height = bar.get_height()
    if height > 0:
        plt.text(bar.get_x() + bar.get_width()/2, height + 5, str(height),
                 ha='center', va='bottom', fontsize=10)

plt.xticks(np.arange(len(dates)), dates, rotation=90, ha='center', fontsize=10)
plt.title('Распределение твитов по месяцам', fontsize=14)
plt.xlabel('Месяц/Год', fontsize=12)
plt.ylabel('Количество твитов', fontsize=12)
plt.grid(axis='y', linestyle='--', alpha=0.7)
plt.tight_layout()
plt.savefig('tweet_distribution.png', dpi=300)
plt.show()
