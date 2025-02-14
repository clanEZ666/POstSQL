--Авторы
CREATE TABLE author
(
    id   BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

INSERT INTO author (name)
VALUES ('Лев Толстой'),
       ('Федор Достоевский'),
       ('Михаил Булгаков'),
       ('Лев Толстой');


--Книги
CREATE TABLE book
(
    id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title        VARCHAR(255),
    publish_year INTEGER NOT NULL CHECK (publish_year > 0),
    price        INTEGER NOT NULL CHECK (price >= 0)
);

INSERT INTO book (title, publish_year)
VALUES ('Война и мир', 1869),
       ('Преступление и наказание', 1866),
       ('Мастер и Маргарита', 1967),
       ('Дуб зеленый', 1983);


-- Издательства
CREATE TABLE publisher
(
    id   BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100)
);

INSERT INTO publisher (name)
VALUES ('Молодая Россия'),
       ('Издательство Эксмо'),
       ('Молодая гвардия'),
       ('Молодая Россия');


-- Многие ко многим
CREATE TABLE book_author
(
    book_id   BIGINT,
    author_id BIGINT,
    CONSTRAINT fk_book FOREIGN KEY (book_id) REFERENCES book (id) ON DELETE CASCADE,
    CONSTRAINT fk_author FOREIGN KEY (author_id) REFERENCES author (id) ON DELETE CASCADE
);

--Один ко многим
CREATE TABLE book_publisher
(
    book_id      BIGINT,
    publisher_id BIGINT,
    CONSTRAINT fk_book_publisher FOREIGN KEY (book_id) REFERENCES book (id) ON DELETE SET NULL,
    CONSTRAINT fk_publisher FOREIGN KEY (publisher_id) REFERENCES publisher (id) ON DELETE RESTRICT
);


--Связь книг и авторов
INSERT INTO book_author (book_id, author_id)
VALUES (1, 1),
       (2, 2),
       (3, 3),
       (4, 4);


--Связь книг и издательств
INSERT INTO book_publisher (book_id, publisher_id)
VALUES (1, 1),
       (2, 2),
       (3, 3),
       (4, 4);

SELECT b.title, p.name AS publisher
FROM book b
         JOIN book_publisher bp ON b.id = bp.book_id
         JOIN publisher p ON bp.publisher_id = p.id;


--Таблица иерархии
CREATE TABLE category
(
    id        BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name      VARCHAR(100),
    parent_id BIGINT NULL,
    CONSTRAINT fk_parent FOREIGN KEY (parent_id) REFERENCES category (id) ON DELETE CASCADE
);

INSERT INTO category (name, parent_id)
VALUES ('Литература', NULL),
       ('Русская классика', 1),
       ('Романы 19 века', 2);



ALTER TABLE book
    ADD COLUMN page_count INT NOT NULL DEFAULT 100
        CHECK (page_count > 0);

SELECT *
FROM book
WHERE page_count > (SELECT AVG(page_count) FROM book);

ALTER TABLE book
    ADD COLUMN amount INT NOT NULL
        CHECK (amount >= 0);

SELECT *
FROM book
WHERE publish_year = (SELECT MAX(publish_year) FROM book);



SELECT *
FROM (SELECT title, price, amount, (price * amount) AS total_value
      FROM book) AS b
WHERE total_value > 300000
ORDER BY total_value;


SELECT title, SUM(price * amount) AS total_value
FROM book
GROUP BY title
HAVING SUM(price * amount) > 300000
ORDER BY total_value;


WITH book_totals AS (SELECT title, price, amount, (price * amount) AS total_value
                     FROM book)
SELECT *
FROM book_totals
WHERE total_value > 300000
ORDER BY total_value;