#Операторы, фильтрация, сортировка и ограничение

USE source03;

#1
UPDATE users 
	SET 
		created_at = NOW(), updated_at = NOW();

#2
ALTER TABLE users 
	MODIFY created_at DATETIME, 
	MODIFY updated_at DATETIME;

#3
INSERT INTO storehouses_products
	(value)
VALUES
	(0), (2500), (0), (30), (500), (1);

SELECT value	
	FROM storehouses_products
	ORDER BY 
			CASE 
				WHEN value = 0 
				THEN 50000000 
				ELSE value
			END;

#4. Из таблицы users извлекаем пользователей, родившихся в августе и мае.
SELECT name,	
	DATE_FORMAT(birthday_at, '%M') AS birthday_at,
	MONTH(birthday_at)
	FROM users
	WHERE MONTH(birthday_at) IN (5, 8);
	
#5.  Из таблицы catalogs извлекаем записи
SELECT id, name
	FROM catalogs
	WHERE id IN (1, 2, 5)
	ORDER BY
			FIELD(id, 5, 1, 2);