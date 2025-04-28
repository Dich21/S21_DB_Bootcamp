-- V080__create_dictionary_view.sql
---------------------------------------------------------
-- Создание представлений для работы с множествами данных словарей
-- Автор: Ullertyr
-- Содержит:
-- 1. Создание представления v_dictionary (объединение v_dictionary_unit и v_dictionary_land)
-- 2. Создание представления v_dictionary_all (прямой доступ к таблице dictionary)
-- 3. Создание представления v_dictionary_minus (разница между v_dictionary_all и v_dictionary_land)
-- 4. Создание представления v_dictionary_intersect (пересечение v_dictionary_all, v_dictionary_land и v_dictionary_unit)
-- 5. Создание представления v_dictionary_symmetric_minus (симметрическая разница между v_dictionary_all и v_dictionary_land)

CREATE VIEW v_dictionary AS
SELECT pk_dictionary, land_value AS value
FROM v_dictionary_land
UNION
SELECT pk_dictionary, unit_value AS value
FROM v_dictionary_unit
ORDER BY value;

COMMENT ON VIEW v_dictionary IS 'Объединение данных из v_dictionary_unit и v_dictionary_land. Сортировка по значению.';
COMMENT ON COLUMN v_dictionary.pk_dictionary IS 'Уникальный идентификатор записи';
COMMENT ON COLUMN v_dictionary.value IS 'Значение элемента словаря';

CREATE VIEW v_dictionary_all AS
SELECT pk_dictionary, dic_name, value
FROM dictionary
ORDER BY dic_name, value;

COMMENT ON VIEW v_dictionary_all IS 'Все записи таблицы dictionary, отсортированные по под-словарю и значению.';

CREATE VIEW v_dictionary_minus AS
SELECT pk_dictionary, dic_name, value
FROM v_dictionary_all
EXCEPT
SELECT l.pk_dictionary, a.dic_name, l.land_value
FROM v_dictionary_land l
JOIN v_dictionary_all a ON l.pk_dictionary = a.pk_dictionary;

COMMENT ON VIEW v_dictionary_minus IS 'Разница между v_dictionary_all и v_dictionary_land с унификацией колонок';
COMMENT ON COLUMN v_dictionary_minus.pk_dictionary IS 'Уникальный идентификатор';
COMMENT ON COLUMN v_dictionary_minus.dic_name IS 'Название под-словаря';
COMMENT ON COLUMN v_dictionary_minus.value IS 'Значение элемента';

CREATE VIEW v_dictionary_intersect AS
SELECT pk_dictionary, dic_name, value
FROM v_dictionary_all
INTERSECT
SELECT l.pk_dictionary, a.dic_name, l.land_value
FROM v_dictionary_land l
JOIN v_dictionary_all a ON l.pk_dictionary = a.pk_dictionary
INTERSECT
SELECT u.pk_dictionary, a.dic_name, u.unit_value
FROM v_dictionary_unit u
JOIN v_dictionary_all a ON u.pk_dictionary = a.pk_dictionary;

SELECT *
FROM v_dictionary_intersect;

CREATE VIEW v_dictionary_symmetric_minus AS
(
SELECT pk_dictionary, dic_name, value
FROM v_dictionary_all
UNION
SELECT l.pk_dictionary, a.dic_name, l.land_value
FROM v_dictionary_land l
JOIN v_dictionary_all a ON l.pk_dictionary = a.pk_dictionary)
EXCEPT
(
SELECT pk_dictionary, dic_name, value
FROM v_dictionary_all
INTERSECT
SELECT l.pk_dictionary, a.dic_name, l.land_value
FROM v_dictionary_land l
JOIN v_dictionary_all a ON l.pk_dictionary = a.pk_dictionary);

COMMENT ON VIEW v_dictionary_symmetric_minus IS
    'Симметрическая разница: элементы, присутствующие только в A или только в B.';