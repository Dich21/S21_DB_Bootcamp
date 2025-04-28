-- V620__create_views_get_time_client0_01.sql
---------------------------------------------------------

CREATE OR REPLACE VIEW v_test00_01_1 AS
SELECT time_us, transaction_no
FROM test00_01_1
WHERE client_id = '5';

CREATE OR REPLACE VIEW v_test00_01_2 AS
SELECT time_us, transaction_no
FROM test00_01_2
WHERE client_id = '5';

select * from test00_01_1;

-- COPY (select * from v_test00_01_2) to '/Users/yaroslavkuklin/Documents/Prog/21_projects/DB_Bootcamp/Single/SQL_Day05-1/src/ex01/v_test00_01_1.csv' WITH CSV HEADER;