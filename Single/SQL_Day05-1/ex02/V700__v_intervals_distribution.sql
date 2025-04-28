-- V700__v_intervals_distribution.sql
---------------------------------------------------------
-- Распределение времени по интервалам для client_id = 9
-- Автор: Ваше имя
-- Содержит:
-- 1. Расчет интервалов для test00_01_1 и test00_01_2
-- 2. Формирование гистограммы и процентов

CREATE VIEW data.v_intervals_distribution AS
WITH
    intervals AS (SELECT 'test00_01_1' AS table_name,
                         client_id,
                         MIN(time) AS min_time,
                         MAX(time) AS max_time,
                         COUNT(*) AS total
                  FROM data.test00_01_1
                  WHERE client_id = 9
                  GROUP BY client_id
                  UNION ALL
                  SELECT 'test00_01_2' AS table_name,
                         client_id,
                         MIN(time),
                         MAX(time),
                         COUNT(*)
                  FROM data.test00_01_2
                  WHERE client_id = 9
                  GROUP BY client_id),
    ranges    AS (SELECT table_name,
                         client_id,
                         min_time,
                         max_time,
                         total,
                         ROUND(min_time::numeric, 2) AS lower,
                         ROUND((min_time + (max_time - min_time) / 3)::numeric, 2) AS mid1,
                         ROUND((min_time + 2 * (max_time - min_time) / 3)::numeric, 2) AS mid2,
                         ROUND(max_time::numeric, 2) AS upper
                  FROM intervals)
SELECT r.table_name AS "Table Name",
       CASE
           WHEN bucket = 1 THEN FORMAT('[%s, %s)', r.lower, r.mid1)
           WHEN bucket = 2 THEN FORMAT('[%s, %s)', r.mid1, r.mid2)
           ELSE FORMAT('[%s, %s]', r.mid2, r.upper)
       END AS interval,
       cnt AS "Amount of Rows",
       REPEAT('.'::text, CEIL((cnt::float * 100) / r.total)::int) AS histogram,
       CEIL((cnt::float * 100) / r.total) AS percent
FROM (SELECT r.table_name,
             CASE
                 WHEN t.time < r.mid1 THEN 1
                 WHEN t.time < r.mid2 THEN 2
                 ELSE 3
             END AS bucket,
             COUNT(*) AS cnt
      FROM ranges r
      JOIN data.test00_01_1 t ON r.table_name = 'test00_01_1' AND t.client_id = r.client_id
      WHERE r.table_name = 'test00_01_1'
      GROUP BY 1, 2
      UNION ALL
      SELECT r.table_name,
             CASE
                 WHEN t.time < r.mid1 THEN 1
                 WHEN t.time < r.mid2 THEN 2
                 ELSE 3
             END AS bucket,
             COUNT(*) AS cnt
      FROM ranges r
      JOIN data.test00_01_2 t ON r.table_name = 'test00_01_2' AND t.client_id = r.client_id
      WHERE r.table_name = 'test00_01_2'
      GROUP BY 1, 2) AS buckets
JOIN ranges r USING (table_name)
ORDER BY r.table_name, bucket;

SELECT *
FROM data.v_intervals_distribution;

