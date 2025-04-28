-- V140__view_with_hierarchy.sql
---------------------------------------------------------
-- Добавление территорий и создание иерархического представления
-- Автор: Ullertyr
-- Содержит:
-- 1. Добавление территории в словарь
-- 2. Вставка зависимых территорий
-- 3. Создание рекурсивного представления

-- 1. Добавление 'territory' в словарь land
INSERT INTO dictionary(pk_dictionary, dic_name, value, order_num)
SELECT (SELECT MAX(pk_dictionary) + 1
        FROM dictionary),
       'land',
       'territory',
       (SELECT order_num + 1 FROM dictionary WHERE dic_name = 'land' AND value = 'country')
WHERE NOT EXISTS
              (SELECT 1 FROM dictionary WHERE dic_name = 'land' AND value = 'territory');

-- 2. Добавление территорий в таблицу country
INSERT INTO country(name, par_id, object_type_id)
VALUES ('Grenland',
        (SELECT pk_country FROM country WHERE name = 'Denmark'),
        (SELECT pk_dictionary FROM dictionary WHERE dic_name = 'land' AND value = 'territory')),
       ('Gibraltar',
        (SELECT pk_country FROM country WHERE name = 'United Kingdom'),
        (SELECT pk_dictionary FROM dictionary WHERE dic_name = 'land' AND value = 'territory')),
       ('Montserrat',
        (SELECT pk_country
         FROM country
         WHERE name = 'United Kingdom'),
        (SELECT pk_dictionary FROM dictionary WHERE dic_name = 'land' AND value = 'territory'));

-- 3. Создание иерархического представления
CREATE OR REPLACE VIEW v_hierarchy_europe AS
WITH
    RECURSIVE
    hierarchy AS (SELECT pk_country, name,
                         (SELECT value FROM dictionary WHERE pk_dictionary = object_type_id) AS type_of_land,
                         1 AS level
                  FROM country c
                  WHERE par_id = (SELECT pk_country FROM country WHERE name = 'Europe')

                  UNION ALL

                  SELECT c.pk_country,c.name,
                         (SELECT value FROM dictionary WHERE pk_dictionary = c.object_type_id) AS type_of_land,
                         h.level + 1
                  FROM country c
                  JOIN hierarchy h ON c.par_id = h.pk_country)
SELECT *
FROM hierarchy;

SELECT * FROM v_hierarchy_europe;

COMMENT ON VIEW v_hierarchy_europe IS 'Иерархия стран и территорий Европы';
COMMENT ON COLUMN v_hierarchy_europe.pk_country IS 'Уникальный идентификатор';
COMMENT ON COLUMN v_hierarchy_europe.name IS 'Название страны/территории';
COMMENT ON COLUMN v_hierarchy_europe.type_of_land IS 'Тип (континент, страна, территория)';
COMMENT ON COLUMN v_hierarchy_europe.level IS 'Уровень вложенности';
