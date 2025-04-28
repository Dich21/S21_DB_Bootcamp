-- bench_view.sql
\set pk_country_indicator random(1, 1000000)
BEGIN;
SELECT * FROM data.v_country_indicator_original WHERE pk_country_indicator = :pk_country_indicator;
END;