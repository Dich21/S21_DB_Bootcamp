-- V1300__ldap_users.sql
---------------------------------------------------------
-- Создание таблицы ldap_users и генерация данных
-- Автор: Ваше имя
-- Содержит:
-- 1. Таблица ldap_users
-- 2. Генерация 10 000 случайных имен

-- 1. Создание таблицы ldap_users
CREATE TABLE IF NOT EXISTS ldap_users
(
    username VARCHAR(100) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2. Генерация 10 000 случайных имен
INSERT INTO ldap_users (username)
SELECT(SELECT CONCAT_WS(' ', name_first, name_last) AS generated
       FROM (SELECT STRING_AGG(x, '')
             FROM (SELECT start_arr[1 + ((RANDOM() * 25)::INT) % 16]
                   FROM (SELECT '{Co,gE,For,So,cO,GiM,Se,Cv,Gw,CA,FRA,gaC,qE,hA,FrO,gla}'::TEXT[] AS start_arr) syllarr,
                       GENERATE_SERIES(1, 3 + (generator * 0))) AS comp3syl(x)) AS comp_name_1st(name_first),
            (SELECT x[1 + ((RANDOM() * 25)::INT) % 14]
             FROM (SELECT
                       '{Co,gE,For,So,cO,GiM,Se,Cv,Gw,CA,FRA,gaC,qE,hA,FrO,gla,20,30}'::TEXT[]) AS z2(x)) AS comp_name_last(name_last))
FROM GENERATE_SERIES(1, 10000) AS generator;