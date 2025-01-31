CREATE TABLE customers (
                           "id" BIGINT GENERATED ALWAYS AS IDENTITY,
                           "name" VARCHAR (30),
                           "surname" VARCHAR (30),
                           "city" VARCHAR (30)
);

--a
INSERT INTO customers ("name", "surname", "city")
VALUES ('Вячеслав', 'Дубовицкий', 'Ленинград'),
       ('Дмитрий', 'Иванов', 'Москва'),
       ('Степан', 'Петрович', 'Ленинград');


SELECT
    id,
    name AS "Имя",
    surname AS "Фамилия",
    city AS "Город"
FROM customers;

--b
UPDATE customers
SET surname = 'Иванов'
WHERE id = 2;

--c
UPDATE customers
SET city = 'Санкт-Петербург'
WHERE city = 'Ленинград';

--d
DELETE FROM customers
WHERE id = 1;

--e
SELECT
    id,
    name AS "Имя",
    surname AS "Фамилия",
    city AS "Город"
FROM customers;

--f
SELECT
    id,
    name AS "Имя",
    surname AS "Фамилия",
    city AS "Город"
FROM customers
WHERE city = 'Санкт-Петербург'
ORDER BY surname;


