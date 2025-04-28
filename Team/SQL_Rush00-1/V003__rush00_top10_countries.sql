-- V003__rush00_top10_countries.sql
---------------------------------------------------------
-- Топ-10 стран по транзакциям
-- Автор: Ullertyr

CREATE OR REPLACE FUNCTION fnc_v_get_top10_tx_countries()
    RETURNS void AS
$$
DECLARE
    union_part text := '';
BEGIN
    FOR i IN 1..30
        LOOP
            union_part := union_part || FORMAT('select country_tx from tx_%s',
                                               LPAD(i::text, 2, '0'));
            IF i < 30 THEN
                union_part := union_part || ' UNION ALL ';
            END IF;
        END LOOP;

    EXECUTE FORMAT('
        CREATE OR REPLACE VIEW v_get_top10_tx_countries AS
        SELECT
            country_tx AS "Country",
            COUNT(*) AS "Amount of Transactions"
        FROM (%s) AS all_tx
        GROUP BY country_tx
        ORDER BY COUNT(*) DESC
        LIMIT 10',
        union_part
    );
END;
$$ LANGUAGE plpgsql;

DO
$$
    BEGIN
        EXECUTE fnc_v_get_top10_tx_countries();
    END
$$ LANGUAGE plpgsql;

SELECT * FROM v_get_top10_tx_countries;

COMMENT ON VIEW v_get_top10_tx_countries IS 'Топ-10 стран по количеству транзакций';
COMMENT ON COLUMN v_get_top10_tx_countries."Country" IS 'Код страны (ISO 3166-1 alpha-3)';
COMMENT ON COLUMN v_get_top10_tx_countries."Amount of Transactions" IS 'Общее количество транзакций';

SELECT *
FROM v_get_top10_tx_countries;