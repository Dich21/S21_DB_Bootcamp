-- traffic_distribution.sql
---------------------------------------------------------
-- Управление распределением транзакций и генерацией тестовых данных
-- Автор: Ullertyr
-- Содержит:
-- 1. Функция route_transaction - распределяет транзакции по таблицам
-- 2. Функция generate_dummy_tx - генерирует тестовые транзакции
-- 3. Анонимный блок для массовой вставки данных
-- 4. Очистка таблиц

-- Функция распределения транзакций
CREATE OR REPLACE FUNCTION route_transaction(cardinal_number varchar(19), card_holder varchar(100),
                                             card_type varchar(50), card_valid_to date, card_pin varchar(3),
                                             status_tx varchar(30), amount_money numeric(9, 2),
                                             currency_name varchar(3), country_tx varchar(3),
                                             internal_tx_number uuid,
                                             inserted_at TIMESTAMPTZ)
    RETURNS void AS
$$
DECLARE
    table_number int;
    table_name   text;
    insert_query text;
BEGIN
    table_number := (ABS(hashtextextended(internal_tx_number::text, 0)) % 30) + 1;
    table_name := 'tx_' || LPAD(table_number::text, 2, '0');
    insert_query := FORMAT('INSERT INTO %I (card_number, card_holder, card_type, card_valid_to, card_pin, status_tx,
                      amount_money, currency_name, country_tx, internal_tx_number, inserted_at)
    VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)', table_name);
    EXECUTE insert_query
        USING cardinal_number, card_holder, card_type, card_valid_to,
            card_pin, status_tx, amount_money, currency_name, country_tx, internal_tx_number, inserted_at;
END;
$$ LANGUAGE plpgsql;

-- Генерация 1 тестовой транзакции
CREATE OR REPLACE FUNCTION generate_dummy_tx()
    RETURNS table
            (
            card_number varchar(19),
            card_holder varchar(100),
            card_type varchar(50),
            card_valid_to date,
            card_pin varchar(3),
            status_tx varchar(30),
            amount_money numeric(9, 2),
            currency_name varchar(3),
            country_tx varchar(3),
            internal_tx_number uuid,
            inserted_at TIMESTAMPTZ)
AS
$$
SELECT LPAD((RANDOM() * 9999)::int::text, 4, '0') || ' ' ||
       LPAD((RANDOM() * 9999)::int::text, 4, '0') || ' ' ||
       LPAD((RANDOM() * 9999)::int::text, 4, '0') || ' ' ||
       LPAD((RANDOM() * 9999)::int::text, 4, '0') AS card_number,
       'Test Holder ' || CHR((65 + RANDOM() * 25)::int) AS card_holder,
       (ARRAY ['VISA','Maestro','MIR'])[1 + FLOOR(RANDOM() * 3)::int] AS card_type,
       CURRENT_DATE + (RANDOM() * 365)::int AS card_valid_to,
       LPAD((RANDOM() * 999)::int::text, 3, '0') AS card_pin,
       (ARRAY ['DONE','PROCESSING','CANCELLED'])[1 + FLOOR(RANDOM() * 3)::int] AS status_tx,
       ROUND((RANDOM() * 10000)::numeric, 2) AS amount_money,
       (ARRAY ['USD','EUR','RUB','JPY','GBP'])[1 + FLOOR(RANDOM() * 5)::int] AS currency_name,
       (ARRAY ['RUS','USA','CHN','IND','DEU',
               'FRA','GBR','BRA','JPN','ITA','CAN',
               'AUS','KOR','ESP','MEX','IDN','TUR',
               'NLD','SAU','CHE','SWE'])[1 + FLOOR(RANDOM() * 21)::int] AS country_tx,
       gen_random_uuid() AS internal_tx_number,
       clock_timestamp() AS inserted_at;
$$ LANGUAGE sql;

-- Функция генерации тестовых данных
DO
$$
    DECLARE
        batch_size int := 100;
        total_rows int := 3000000;
        iterations int := total_rows / batch_size;
    BEGIN
        FOR i IN 1..iterations
            LOOP
                PERFORM route_transaction(
                        t.card_number, t.card_holder, t.card_type,
                        t.card_valid_to, t.card_pin, t.status_tx,
                        t.amount_money, t.currency_name, t.country_tx,
                        t.internal_tx_number, t.inserted_at
                        )
                FROM generate_dummy_tx() t
                LIMIT batch_size;
                IF i % 100 = 0 THEN
                    RAISE NOTICE 'Inserted % rows', i * batch_size;
                END IF;
            END LOOP;
    END
$$ LANGUAGE plpgsql;

-- TRUNCATE TABLE
--     tx_01, tx_02, tx_03, tx_04, tx_05, tx_06, tx_07, tx_08, tx_09, tx_10,
--     tx_11, tx_12, tx_13, tx_14, tx_15, tx_16, tx_17, tx_18, tx_19, tx_20,
--     tx_21, tx_22, tx_23, tx_24, tx_25, tx_26, tx_27, tx_28, tx_29, tx_30 CASCADE;

