-- V000__db_model_initiate.sql
---------------------------------------------------------
-- Инициализация базовой структуры EAV-модели
-- Автор: Ullertyr
-- Содержит:
-- 1. Создание таблиц indicator, country, country_indicator
-- 2. Определение ключей и ограничений
-- 3. Документирование через COMMENT ON


CREATE TABLE IF NOT EXISTS indicator
(
    pk_indicator BIGINT PRIMARY KEY NOT NULL,
    name VARCHAR(255) NOT NULL,
    unit VARCHAR(20) NOT NULL,
    CONSTRAINT uk_indicator_name UNIQUE (name)
);

COMMENT ON TABLE indicator IS 'Словарь показателей';
COMMENT ON COLUMN indicator.pk_indicator IS 'Идентификатор показателя';
COMMENT ON COLUMN indicator.name IS 'Наименование показателя';
COMMENT ON COLUMN indicator.unit IS 'Единица измерения показателя';

CREATE TABLE IF NOT EXISTS country
(
    pk_country BIGINT PRIMARY KEY NOT NULL,
    name VARCHAR(255) NOT NULL,
    par_id BIGINT,
    object_type VARCHAR(20) NOT NULL DEFAULT 'country',
    CONSTRAINT fk_par_id_country FOREIGN KEY (par_id) REFERENCES country (pk_country),
    CONSTRAINT uk_country_name_object_type UNIQUE (name, object_type)
);

COMMENT ON TABLE country IS 'Словарь стран и континентов';
COMMENT ON COLUMN country.pk_country IS 'Идентификатор страны';
COMMENT ON COLUMN country.name IS 'Наименование страны';
COMMENT ON COLUMN country.par_id IS 'Ссылка на родительский объект';
COMMENT ON COLUMN country.object_type IS 'Тип объекта (страна/континент)';

CREATE TABLE IF NOT EXISTS country_indicator
(
    pk_country_indicator BIGINT PRIMARY KEY NOT NULL,
    c_id BIGINT NOT NULL,
    i_id BIGINT NOT NULL,
    value INT,
    actual_date TIMESTAMP NOT NULL,
    CONSTRAINT fk_c_id_country FOREIGN KEY (c_id) REFERENCES country (pk_country),
    CONSTRAINT fk_i_id_indicator FOREIGN KEY (i_id) REFERENCES indicator (pk_indicator),
    CONSTRAINT uk_c_id_i_id_actual_date UNIQUE (c_id, i_id, actual_date)
);

COMMENT ON TABLE country_indicator IS 'Исторические значения показателей';
COMMENT ON COLUMN country_indicator.pk_country_indicator IS 'Идентификатор записи';
COMMENT ON COLUMN country_indicator.c_id IS 'Ссылка на страну';
COMMENT ON COLUMN country_indicator.i_id IS 'Ссылка на показатель';
COMMENT ON COLUMN country_indicator.value IS 'Значение показателя';
COMMENT ON COLUMN country_indicator.actual_date IS 'Дата актуализации значения';

