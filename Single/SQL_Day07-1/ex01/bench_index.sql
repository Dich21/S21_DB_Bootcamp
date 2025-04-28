\set username random(1, 10000)
SELECT *
FROM data.ldap_users
WHERE UPPER(username) = (SELECT username FROM data.ldap_users OFFSET :username LIMIT 1);