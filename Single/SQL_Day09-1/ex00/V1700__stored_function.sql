-- V1700__stored_function.sql
---------------------------------------------------------
-- Создание SQL-функции для генерации LDAP-имен

CREATE OR REPLACE FUNCTION fnc_generate_ldap_usernames()
RETURNS TABLE (username TEXT) AS $$
SELECT(SELECT CONCAT_WS(' ', name_first, name_last) AS generated
       FROM (SELECT STRING_AGG(x, '')
             FROM (SELECT start_arr[1 + ((RANDOM() * 25)::INT) % 16]
                   FROM (SELECT '{Co,gE,For,So,cO,GiM,Se,Cv,Gw,CA,FRA,gaC,qE,hA,FrO,gla}'::TEXT[] AS start_arr) syllarr,
                       GENERATE_SERIES(1, 3 + (generator * 0))) AS comp3syl(x)) AS comp_name_1st(name_first),
            (SELECT x[1 + ((RANDOM() * 25)::INT) % 14]
             FROM (SELECT '{Co,gE,For,So,cO,GiM,Se,Cv,Gw,CA,FRA,gaC,qE,hA,FrO,gla,20,30}'::TEXT[]) AS z2(x)) AS comp_name_last(name_last))
FROM GENERATE_SERIES(1, 10000) AS generator;
$$ LANGUAGE SQL;

SELECT *
FROM fnc_generate_ldap_usernames()