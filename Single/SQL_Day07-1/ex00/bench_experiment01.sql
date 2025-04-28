-- bench_experiment01.sql
\set ID1 random (1, 10000000)
\set ID2 random (:ID1 + 1, 10000000)

SELECT ROW_NUMBER() OVER () AS row_num,
       MIN(d) OVER (PARTITION BY MAX(a) ORDER BY MIN(c)
           ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS min_amount,
       d,
       COUNT(DISTINCT c) AS amount
FROM data.experiment_01
WHERE a BETWEEN :ID1 AND :ID2
GROUP BY d
ORDER BY min_amount;