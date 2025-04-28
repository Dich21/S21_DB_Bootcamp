-- copy_sql.txt
---------------------------------------------------------
COPY data.test00_01_1 FROM '/Users/yaroslavkuklin/Documents/Prog/21_projects/DB_Bootcamp/Single/SQL_Day05-1/src/ex01/CSV/bench_table.sql_log.csv' WITH CSV;
COPY data.test00_01_2 FROM '/Users/yaroslavkuklin/Documents/Prog/21_projects/DB_Bootcamp/Single/SQL_Day05-1/src/ex01/CSV/bench_view.sql_log.csv' WITH CSV;

TRUNCATE data.test00_01_1;
TRUNCATE data.test00_01_2;