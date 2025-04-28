-- bench_table.sql
\set pk_country_indicator random(1, 1000000)
BEGIN;
SELECT * FROM data.country_indicator WHERE pk_country_indicator = :pk_country_indicator;
END;