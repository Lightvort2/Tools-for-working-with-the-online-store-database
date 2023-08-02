USE source08;

# 1. Создадим хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
# С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро",
# с 12:00 до 18:00 функция должна возвращать фразу "Добрый день",
# с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".

DROP FUNCTION IF EXISTS hello;
DELIMITER //
//
CREATE FUNCTION hello()
RETURNS TEXT DETERMINISTIC
BEGIN
	CASE
		WHEN CURRENT_TIME() BETWEEN '06:00:00' AND '12:00:00' 
			THEN 
				RETURN 'Доброе утро';
		WHEN CURRENT_TIME() BETWEEN '12:00:00' AND '18:00:00'
			THEN 
				RETURN 'Добрый день';
		WHEN CURRENT_TIME() BETWEEN '18:00:00' AND '00:00:00' 
			THEN
				RETURN 'Добрый вечер';
		ELSE
			RETURN 'Доброй ночи';
	END CASE;
END//
DELIMITER ;

SELECT hello() AS 'Приветствие';

/* 2. В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
 Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
 Используя триггеры, добьёмся того, чтобы одно из этих полей или оба поля были заполнены. При попытке присвоить полям NULL-значение необходимо отменить операцию.*/

DROP TRIGGER IF EXISTS not_null;
DELIMITER //
//
CREATE TRIGGER not_null BEFORE INSERT ON products
FOR EACH ROW 
BEGIN 
	IF (ISNULL(NEW.name) AND ISNULL(NEW.description)) 
			THEN
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Сработал ТРИГГЕР! Поля "name" и "description" не могут быть одновременно пустыми! Добавление записи отменено';
	END IF;
END//
DELIMITER ;

SHOW TRIGGERS;

# Проверяем работу триггера
INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  (NULL, 'Супер-Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', 29310.00, 2);
# Запись добавлена

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
	('Super-Gigabyte H310M S2H', NULL, 5790.00, 2);
# Запись добавлена
 
INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  (NULL, NULL, 4060.00, 2);
# Запись не добавлена. Сработала ошибка

