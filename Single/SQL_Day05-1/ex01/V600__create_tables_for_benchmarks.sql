-- V600__create_tables_for_benchmarks.sql
---------------------------------------------------------
-- Создание таблиц для хранения результатов pgbench
-- Автор: Ullertyr
-- Содержит:
-- 1. Таблицы test00_01_1 и test00_01_2

CREATE TABLE IF NOT EXISTS  test00_01_1
(
    client_id bigint,
    transaction_no bigint,
    time bigint,
    script_no bigint,
    time_epoch bigint,
    time_us bigint
);

CREATE TABLE IF NOT EXISTS test00_01_2
(
    client_id bigint,
    transaction_no bigint,
    time bigint,
    script_no bigint,
    time_epoch bigint,
    time_us bigint
);

COMMENT ON TABLE data.test00_01_1 IS 'Benchmark results for view v_country_indicator_original';
COMMENT ON TABLE data.test00_01_2 IS 'Benchmark results for table country_indicator';