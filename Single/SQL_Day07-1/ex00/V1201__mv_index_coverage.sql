-- V1201__mv_index_coverage.sql
---------------------------------------------------------
-- Материализованное представление для статистики индексов

CREATE MATERIALIZED VIEW IF NOT EXISTS mv_experiment01_index_coverage AS
SELECT indexrelname AS "Index name",
       idx_scan AS "Total Amount of Index Scans",
       idx_tup_read AS "Count of returned values during Index Scan",
       idx_tup_fetch AS "Count of returned live values during Index Scan",
       PG_SIZE_PRETTY(PG_RELATION_SIZE(indexrelid)) AS "Index Size"
FROM pg_stat_user_indexes
WHERE schemaname = 'data'
  AND relname = 'experiment_01'
ORDER BY indexrelname;

select *
from mv_experiment01_index_coverage;