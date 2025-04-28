-- V1401__part_unique_ldap_users.sql
---------------------------------------------------------
-- Создание частичного уникального индекса

CREATE UNIQUE INDEX idx_ldap_users_user_group
ON ldap_users (user_group)
WHERE user_group !=100;