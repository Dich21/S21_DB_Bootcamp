-- V1301__ldap_index.sql
---------------------------------------------------------
-- Создание функционального индекса для поиска по upper(username)
CREATE INDEX idx_ldap_users ON ldap_users (upper(username));

-- DROP INDEX idx_ldap_users;
-- EXPLAIN ANALYZE SELECT * FROM ldap_users WHERE upper(username) = 'ALIENUSER';
