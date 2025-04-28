-- V001__rush00_tables.sql
---------------------------------------------------------
-- Создание 30 таблиц для распределенного хранения транзакций
-- Автор: Ullertyr
-- Содержит:
-- 1. Динамическое создание таблиц tx_01...tx_30
-- 2. Комментарии к структуре таблиц и колонок

DO $$
DECLARE
    -- Объявляем переменную для хранения данных о колонках и комментариях
    column_data text[][] := ARRAY[
        ARRAY['card_number', 'Номер банковской карты в формате XXXX XXXX XXXX XXXX'],
        ARRAY['card_holder', 'Держатель карты'],
        ARRAY['card_type', 'Тип карты: VISA, Maestro, MIR'],
        ARRAY['card_valid_to', 'Дата окончания действия карты'],
        ARRAY['card_pin', 'Пин-код из 3 цифр'],
        ARRAY['status_tx', 'Статус транзакции: DONE, PROCESSING, CANCELLED'],
        ARRAY['amount_money', 'Сумма транзакции с точностью до 2 знаков'],
        ARRAY['currency_name', 'Код валюты по ISO (USD, EUR и т.д.)'],
        ARRAY['country_tx', 'Код страны по ISO 3166-1 alpha-3'],
        ARRAY['internal_tx_number', 'Уникальный идентификатор транзакции (UUID v4)'],
        ARRAY['inserted_at', 'Временная метка инсерта']
    ];
    -- Объявляем переменную для итерации по массиву
    var_slice text[];
BEGIN
    FOR i IN 1..30 LOOP
        -- Создаем таблицу
        EXECUTE FORMAT(
            'CREATE TABLE tx_%s (
                card_number      VARCHAR(19) NOT NULL,
                card_holder      VARCHAR(100) NOT NULL,
                card_type        VARCHAR(50) NOT NULL,
                card_valid_to    DATE NOT NULL,
                card_pin         VARCHAR(3) NOT NULL,
                status_tx        VARCHAR(30) NOT NULL DEFAULT ''PROCESSING'',
                amount_money     NUMERIC(9,2) NOT NULL DEFAULT 0,
                currency_name    VARCHAR(3) NOT NULL,
                country_tx       VARCHAR(3) NOT NULL,
                internal_tx_number UUID NOT NULL DEFAULT uuid_generate_v4(),
                inserted_at TIMESTAMPTZ NOT NULL
            )',
            LPAD(i::text, 2, '0')
        );

        -- Добавляем комментарии к колонкам
        FOREACH var_slice SLICE 1 IN ARRAY column_data LOOP
            EXECUTE FORMAT(
                'COMMENT ON COLUMN tx_%s.%I IS %L',
                LPAD(i::text, 2, '0'),
                var_slice[1],
                var_slice[2]
            );
        END LOOP;

        -- Добавляем комментарий к таблице
        EXECUTE FORMAT(
            'COMMENT ON TABLE tx_%s IS %L',
            LPAD(i::text, 2, '0'),
            'Таблица транзакций #' || i
        );
    END LOOP;
END
$$ LANGUAGE plpgsql;

-- DROP TABLE
--     tx_01, tx_02, tx_03, tx_04, tx_05, tx_06, tx_07, tx_08, tx_09, tx_10,
--     tx_11, tx_12, tx_13, tx_14, tx_15, tx_16, tx_17, tx_18, tx_19, tx_20,
--     tx_21, tx_22, tx_23, tx_24, tx_25, tx_26, tx_27, tx_28, tx_29, tx_30 CASCADE;