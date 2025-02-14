CREATE TABLE book
(
    id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title        VARCHAR(255),
    publish_year INT
);

INSERT INTO book (title, publish_year)
VALUES ('Война и мир', 1869),
       ('Преступление и наказание', 1866),
       ('Мастер и Маргарита', 1967),
       ('Дуб зеленый', 1983);



CREATE TABLE author
(
    id   BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100)

);
INSERT INTO author (name)
VALUES ('Лев Толстой'),
       ('Федор Достоевский'),
       ('Михаил Булгаков'),
       ('Лев Толстой');



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


--Связующая таблица книга и автора (многие ко многим)
CREATE TABLE book_author
(
    book_id   BIGINT,
    author_id BIGINT,

    CONSTRAINT fk_book FOREIGN KEY ("book_id") REFERENCES book (id),
    CONSTRAINT fk_author FOREIGN KEY ("author_id") REFERENCES author (id)

);


-- Связующая таблица книг с издательством (один ко многим)

CREATE TABLE book_publisher
(
    book_id      BIGINT,
    publisher_id BIGINT,

    CONSTRAINT fk_book_publisher FOREIGN KEY (book_id) REFERENCES book (id),
    CONSTRAINT fk_publisher FOREIGN KEY (publisher_id) REFERENCES publisher (id)

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



ALTER TABLE book
    ADD COLUMN price INTEGER;


SELECT  AVG(price) AS avg_total,
        MIN(price) AS min_total,
        MAX(price) AS max_total
FROM book;



SELECT a.name AS author, COUNT(DISTINCT ba.book_id) AS book_count
FROM author a
         JOIN book_author ba ON a.id = ba.author_id
GROUP BY a.name;


SELECT a.name AS author,
       COUNT(b.id) AS book_count,
       AVG(b.price) AS avg_price
FROM author a
         JOIN book_author ba ON a.id = ba.author_id
         JOIN book b ON ba.book_id = b.id
GROUP BY a.name;


INSERT INTO author (name)
VALUES ('Автор без книги 1'),
       ('Автор без книги 2');

SELECT a.name AS author
FROM author a
         LEFT JOIN book_author ba ON a.id = ba.author_id
GROUP BY a.name
HAVING COUNT(ba.book_id) = 0;
