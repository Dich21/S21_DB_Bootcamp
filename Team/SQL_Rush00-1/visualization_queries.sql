-- visualization_queries.sql
---------------------------------------------------------
-- SQL-запросы для визуализации данных в Grafana
-- Автор: Ullertyr
-- Содержит:
-- 1. Запрос для графика загрузки данных по секундам
-- 2. Запрос для распределения данных между таблицами
-- 3. Запрос для топ-10 стран по транзакциям


-- 1. График загрузки данных по секундам
SELECT
    date_trunc('second', inserted_at) AS second,
    COUNT(*) AS transaction_count
FROM (
    SELECT inserted_at FROM rush00.tx_01
    UNION ALL SELECT inserted_at FROM rush00.tx_02
    UNION ALL SELECT inserted_at FROM rush00.tx_03
    UNION ALL SELECT inserted_at FROM rush00.tx_04
    UNION ALL SELECT inserted_at FROM rush00.tx_05
    UNION ALL SELECT inserted_at FROM rush00.tx_06
    UNION ALL SELECT inserted_at FROM rush00.tx_07
    UNION ALL SELECT inserted_at FROM rush00.tx_08
    UNION ALL SELECT inserted_at FROM rush00.tx_09
    UNION ALL SELECT inserted_at FROM rush00.tx_10
    UNION ALL SELECT inserted_at FROM rush00.tx_11
    UNION ALL SELECT inserted_at FROM rush00.tx_12
    UNION ALL SELECT inserted_at FROM rush00.tx_13
    UNION ALL SELECT inserted_at FROM rush00.tx_14
    UNION ALL SELECT inserted_at FROM rush00.tx_15
    UNION ALL SELECT inserted_at FROM rush00.tx_16
    UNION ALL SELECT inserted_at FROM rush00.tx_17
    UNION ALL SELECT inserted_at FROM rush00.tx_18
    UNION ALL SELECT inserted_at FROM rush00.tx_19
    UNION ALL SELECT inserted_at FROM rush00.tx_20
    UNION ALL SELECT inserted_at FROM rush00.tx_21
    UNION ALL SELECT inserted_at FROM rush00.tx_22
    UNION ALL SELECT inserted_at FROM rush00.tx_23
    UNION ALL SELECT inserted_at FROM rush00.tx_24
    UNION ALL SELECT inserted_at FROM rush00.tx_25
    UNION ALL SELECT inserted_at FROM rush00.tx_26
    UNION ALL SELECT inserted_at FROM rush00.tx_27
    UNION ALL SELECT inserted_at FROM rush00.tx_28
    UNION ALL SELECT inserted_at FROM rush00.tx_29
    UNION ALL SELECT inserted_at FROM rush00.tx_30
) AS all_tx
GROUP BY second
ORDER BY second
LIMIT 10;

-- 2. Распределение данных между таблицами
SELECT * FROM v_data_distribution;

-- 3. Топ-10 стран по транзакциям
SELECT * FROM v_get_top10_tx_countries;

