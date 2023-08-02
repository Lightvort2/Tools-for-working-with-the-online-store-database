# Агрегация данных

USE source04;

#1. Подсчёт среднего возраста пользователей в таблице users.
	
SELECT name,
	avg(
		floor(
			(to_days(now()) - to_days(birthday_at)) / 365.25))
		AS age_avg 
FROM
	users;

#2. Подсчёт количества дней рождения, которые приходятся на каждый из дней недели

SELECT
    dayofweek(date_format(birthday_at, '2022-%m-%d')) AS 'day_of_week',
    count(*) AS 'birthdays_sum'
FROM users
GROUP BY dayofweek(date_format(birthday_at, '2022-%m-%d'))
ORDER BY day_of_week;

#3

truncate tbl;

ALTER TABLE tbl 
	MODIFY id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY;

INSERT INTO tbl
	(value)
VALUES
	(1), (2), (3), (4), (5);
	
SELECT 
	EXP(SUM(LN(value))) AS Multiply_sum
FROM tbl;