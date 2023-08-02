USE source05;

# 1. Составим список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.

INSERT INTO orders
  (user_id)
VALUES
  ('1'), ('1'), ('1'), ('6'), ('6'), ('3'), ('4');
 
SELECT 
	users.id,
	users.name,
	orders.user_id,
	orders.created_at AS 'Order date'
FROM users
JOIN orders
ON users.id = orders.user_id
GROUP BY users.name;

# 2. Выведем список товаров products и разделов catalogs, который соответствует товару.

SELECT 
	products.name AS 'Product name',
	products.catalog_id,
	catalogs.name AS 'Catalog name',
	catalogs.id 
FROM products
JOIN catalogs
ON products.catalog_id = catalogs.id;

# 3. Выведем список рейсов flights с русскими названиями городов.

DROP TABLE IF EXISTS flights;
CREATE TABLE flights (
  id SERIAL PRIMARY KEY,
  departure VARCHAR(255),
  destination VARCHAR(255)
);

INSERT INTO flights
  (departure, destination)
VALUES
  ('moscow', 'omsk'), ('novgorod', 'kazan'), ('irkutsk', 'moscow'), ('omsk', 'irkutsk'), ('moscow', 'kazan');
  
DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
  label VARCHAR(255),
  name VARCHAR(255)
);

INSERT INTO cities
  (label, name)
VALUES
  ('moscow', 'Москва'), ('novgorod', 'Новгород'), ('irkutsk', 'Иркутск'), ('omsk', 'Омск'), ('kazan', 'Казань');
  
SELECT 
	id,
	(SELECT name FROM cities WHERE (cities.label = flights.departure)) AS departure,
	(SELECT name FROM cities WHERE (cities.label = flights.destination)) AS destination
FROM flights;