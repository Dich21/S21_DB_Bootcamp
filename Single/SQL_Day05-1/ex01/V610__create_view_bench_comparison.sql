-- V610__create_view_bench_comparison.sql
---------------------------------------------------------

CREATE OR REPLACE VIEW v_compare_test_results AS
SELECT 'v_country_indicator_original' AS "Object Name",
       MAX(time) AS "Maximum time",
       MIN(time) AS "Minimum time",
       ROUND(AVG(time), 5) AS "Average time"
FROM data.test00_01_1
UNION ALL
SELECT 'country_indicator' AS "Object Name",
       MAX(time) AS "Maximum time",
       MIN(time) AS "Minimum time",
       ROUND(AVG(time), 5) AS "Average time"
FROM data.test00_01_2;

select * from v_compare_test_results;
