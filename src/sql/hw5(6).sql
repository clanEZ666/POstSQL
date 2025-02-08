CREATE TABLE book
(
    id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title        VARCHAR(255),
    publish_year INT
);

INSERT INTO book (title, publish_year)
VALUES ('Война и мир', 1869),
       ('Преступление и наказание', 1866),
       ('Мастер и Маргарита', 1967);



CREATE TABLE author
(
    id   BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100)

);
INSERT INTO author (name)
VALUES ('Лев Толстой'),
       ('Федор Достоевский'),
       ('Михаил Булгаков');



CREATE TABLE publisher
(
    id   BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100)
);
INSERT INTO publisher (name)
VALUES ('Молодая Россия'),
       ('Издательство Эксмо'),
       ('Молодая гвардия');


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
       (3, 3);


--Связь книг и издательств
INSERT INTO book_publisher (book_id, publisher_id)
VALUES (1, 1),
       (2, 2),
       (3, 3);

SELECT b.title, p.name AS publisher
FROM book b
         JOIN book_publisher bp ON b.id = bp.book_id
         JOIN publisher p ON bp.publisher_id = p.id;
