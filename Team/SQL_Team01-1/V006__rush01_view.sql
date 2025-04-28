-- V007__rush01_function.sql
---------------------------------------------------------
-- Функция преобразования даты
-- Автор: Ullertyr

CREATE OR REPLACE FUNCTION fnc_get_month_year(pcreatedate VARCHAR)
    RETURNS DATE AS
$$
BEGIN
    RETURN DATE_TRUNC('month',
        TO_DATE(SUBSTRING(pcreatedate FROM '(\w+\s+\d{1,2},\s+\d{4})'), 'FMMonth DD, YYYY')
    );
EXCEPTION
    WHEN OTHERS THEN
        RETURN NULL;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION rush01.fnc_get_month_year IS 'Преобразует строку CreatedAt в дату формата 01/MM/YYYY';


CREATE OR REPLACE VIEW v_get_distribution_tweet_by_month_year AS
SELECT TO_CHAR(fnc_get_month_year(tweet_document ->> 'CreatedAt'), 'DD/MM/YYYY') AS month_year,
       COUNT(*) AS tweet_count
FROM archive_tweets_elonmusk
GROUP BY 1
ORDER BY TO_DATE(1::TEXT, 'MM/YYYY');

COMMENT ON VIEW rush01.v_get_distribution_tweet_by_month_year IS 'Распределение твитов по месяцам и годам';

SELECT *
FROM v_get_distribution_tweet_by_month_year;