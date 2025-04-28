-- V1400__alter_ldap_users.sql
---------------------------------------------------------
-- Добавление колонки user_group и обновление данных
-- Автор: Ваше имя
-- Содержит:
-- 1. Добавление колонки user_group
-- 2. Назначение значений 100 и уникальных номеров

-- 1. Добавление колонки user_group
ALTER TABLE ldap_users
    ADD COLUMN user_group INT;

-- 2. Назначение значений 100 и уникальных номеров
WITH
    random_users AS (SELECT ctid
                     FROM ldap_users
                     ORDER BY RANDOM()
                     LIMIT (4000 + (RANDOM() * 1000)::INT))
UPDATE ldap_users
SET user_group = 100
WHERE ctid IN (SELECT ctid FROM random_users);

UPDATE ldap_users
set user_group = sub.unique_group
from (select ctid, row_number() over(order by random()) + 100 as unique_group
      from ldap_users
      where user_group is null ) as sub
where ldap_users.ctid = sub.ctid;