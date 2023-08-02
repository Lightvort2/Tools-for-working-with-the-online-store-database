USE source10;

/* 1.  Создадим таблицу logs типа Archive. 
 Пусть при каждом создании записи в таблицах users, catalogs и products в таблицу logs помещается время и дата создания записи,
  название таблицы, идентификатор первичного ключа и содержимое поля name.*/

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  table_name VARCHAR(255),
  foreighn_id BIGINT UNSIGNED NOT NULL,
  name VARCHAR(255)
) ENGINE ARCHIVE;

DROP TRIGGER IF EXISTS add_log_users;
DELIMITER //
//
CREATE TRIGGER add_log_users AFTER INSERT ON users
FOR EACH ROW 
BEGIN 
	IF (NEW.id) 
			THEN
				INSERT INTO logs
					(table_name, foreighn_id, name)
				VALUES
					('users', NEW.id, NEW.name);
	END IF;
END//
DELIMITER ;

DROP TRIGGER IF EXISTS add_log_catalogs;
DELIMITER //
//
CREATE TRIGGER add_log_catalogs AFTER INSERT ON catalogs
FOR EACH ROW 
BEGIN 
	IF (NEW.id) 
			THEN
				INSERT INTO logs
					(table_name, foreighn_id, name)
				VALUES
					('catalogs', NEW.id, NEW.name);
	END IF;
END//
DELIMITER ;

DROP TRIGGER IF EXISTS add_log_products;
DELIMITER //
//
CREATE TRIGGER add_log_products AFTER INSERT ON products
FOR EACH ROW 
BEGIN 
	IF (NEW.id) 
			THEN
				INSERT INTO logs
					(table_name, foreighn_id, name)
				VALUES
					('products', NEW.id, NEW.name);
	END IF;
END//
DELIMITER ;

SHOW TRIGGERS;

# Проверяем работу триггеров
INSERT INTO users
  (name, birthday_at)
VALUES
  ('Test-name', '1985-02-14');
# Запись добавлена

INSERT INTO catalogs
  (name)
VALUES
  ('Test-cat-name');
# Запись добавлена
 
INSERT INTO products
  (name, description, price, catalog_id)
VALUES
	('Test-product', 'Test-description', 100500.00, 1);
# Запись добавлена
 

# 2. Создадим SQL-запрос, который помещает в таблицу users миллион записей.

DROP PROCEDURE IF EXISTS sp_add_users;
DELIMITER //
CREATE PROCEDURE sp_add_users ()
BEGIN
	DECLARE lim BIGINT DEFAULT 1000000;
	WHILE lim > 0
		DO
			INSERT INTO users
				(name, birthday_at)
			VALUES
				(NULL, SUBDATE(CURRENT_DATE(), 10500));
			SET lim = lim - 1;
		END WHILE;
END//
DELIMITER ;

CALL sp_add_users();

SELECT * FROM users
ORDER BY id DESC
LIMIT 5;