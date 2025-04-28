-- V002__rush00_view_data_distribution.sql
---------------------------------------------------------
-- Представление распределения данных
-- Автор: Ullertyr


CREATE OR REPLACE FUNCTION fnc_generate_distribution_view_sql()
    RETURNS text AS
$$
DECLARE
    sql_query text := '';
BEGIN
    FOR i IN 1..30
        LOOP
            sql_query = sql_query || FORMAT('select ''tx_%s'' as "Table Name",
                                     (select count(*) from tx_%s) as "Amount of rows"',
                                            LPAD(i::text, 2, '0'),
                                            LPAD(i::text, 2, '0'));
            IF i < 30 THEN
                sql_query = sql_query || ' UNION ALL ';
            END IF;
        END LOOP;
    RETURN 'create or replace view v_data_distribution as ' || sql_query;
END;
$$ LANGUAGE plpgsql;

DO
$$
    BEGIN
        EXECUTE fnc_generate_distribution_view_sql();
    END
$$ LANGUAGE plpgsql;

COMMENT ON VIEW v_data_distribution IS 'Показывает распределение записей между таблицами транзакций';
COMMENT ON COLUMN v_data_distribution."Table Name" IS 'Имя таблицы транзакций';
COMMENT ON COLUMN v_data_distribution."Amount of rows" IS 'Количество записей в таблице';

SELECT *
FROM v_data_distribution;