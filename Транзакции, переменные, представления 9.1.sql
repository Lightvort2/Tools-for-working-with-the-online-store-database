# 1. Переместим запись id = 1 из таблицы shop.users в таблицу sample.users, используя транзакции.

USE sample;

TRUNCATE TABLE users;

START TRANSACTION;

INSERT INTO sample.users 
	SELECT
		id,
		name
	FROM source06.users
	WHERE id = 1;

COMMIT;


# 2. Создадим представление, которое выводит название name товарной позиции из таблицы products и соответствующее название каталога name из таблицы catalogs.

USE source06;

CREATE VIEW pro_cat AS 
	SELECT 
		p.name AS 'product name',
		c.name AS 'catalog name'
	FROM products p 
		LEFT JOIN catalogs c ON p.catalog_id = c.id 
;

SELECT * FROM pro_cat;


# 3. Составим запрос, который выводит полный список дат за август.

DROP TABLE IF EXISTS calendar;
CREATE TABLE calendar (
  id SERIAL PRIMARY KEY,
  created_at DATE
);

INSERT INTO calendar (created_at) VALUES
	('2018-08-01'), ('2016-08-04'), ('2018-08-16'), ('2018-08-17');
	
DROP TABLE IF EXISTS aug_18;
CREATE TEMPORARY TABLE aug_18 (
	id SERIAL PRIMARY KEY,
  	date_in_aug DATE
);

INSERT INTO aug_18 (date_in_aug) VALUES
	('2018-08-01'), ('2018-08-02'), ('2018-08-03'), ('2018-08-04'), ('2018-08-05'), ('2018-08-06'), ('2018-08-07'), ('2018-08-08'), ('2018-08-09'), ('2018-08-10'),
	('2018-08-11'), ('2018-08-12'), ('2018-08-13'), ('2018-08-14'), ('2018-08-15'), ('2018-08-16'), ('2018-08-17'), ('2018-08-18'), ('2018-08-19'), ('2018-08-20'),
	('2018-08-21'), ('2018-08-22'), ('2018-08-23'), ('2018-08-24'), ('2018-08-25'), ('2018-08-26'), ('2018-08-27'), ('2018-08-28'), ('2018-08-29'), ('2018-08-30'),
	('2018-08-31');
	
SELECT 
	a.date_in_aug AS 'check date',
	(CASE 
		WHEN (c2.created_at = a.date_in_aug)
		THEN '1'
		ELSE '0'
	END
	) AS 'check result'
FROM aug_18 a
	LEFT JOIN calendar c2 ON c2.created_at = a.date_in_aug;
	
# 4. Создадим запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.

DROP TABLE IF EXISTS records_to_delete;
CREATE TABLE records_to_delete (
  id SERIAL PRIMARY KEY,
  created_at DATE
);

INSERT INTO records_to_delete (created_at) VALUES
	('2022-10-01'), ('2022-10-02'), ('2022-10-03'), ('2022-10-04'), ('2022-10-05'), ('2022-10-06'), ('2022-10-07'), ('2022-10-08'), ('2022-10-09'), ('2022-10-10');
	
SELECT * FROM records_to_delete;

CREATE VIEW last_5 AS
	SELECT created_at
		FROM records_to_delete 
		ORDER BY created_at DESC
		LIMIT 5
;

SELECT * FROM last_5;