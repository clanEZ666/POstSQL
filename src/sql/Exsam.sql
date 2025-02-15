CREATE TABLE classes (
                         class_id SERIAL PRIMARY KEY,
                         name VARCHAR(50) NOT NULL,
                         teacher VARCHAR(100) NOT NULL
);

CREATE TABLE students (
                          student_id SERIAL PRIMARY KEY,
                          name VARCHAR(100) NOT NULL,
                          class_id INT,
                          age INTEGER CHECK (age > 5)
);

CREATE TABLE grades (
                        grade_id SERIAL PRIMARY KEY,
                        student_id INT,
                        subject VARCHAR(100) NOT NULL,
                        grade INTEGER CHECK (grade BETWEEN 1 AND 5)
);

-- 3) Добавление внешних ключей отдельно
ALTER TABLE students
    ADD CONSTRAINT fk_students_class FOREIGN KEY (class_id) REFERENCES classes(class_id) ON DELETE CASCADE;

ALTER TABLE grades
    ADD CONSTRAINT fk_grades_student FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE;


INSERT INTO classes (name, teacher) VALUES
                                        ('1A', 'Мария Иванова'),
                                        ('2B', 'Петр Куликов');

INSERT INTO students (name, class_id, age)
VALUES ('Саша Синцов', 1, 7),
       ('Оля Петрова', 2, 8);

INSERT INTO grades (student_id, subject, grade)
VALUES  (1, 'Математика', 5),
        (2, 'Русский Язык', 4);

--Запрос с группировкой и сортировкой по средней оценкой по ученикам
SELECT student_id, AVG(grade) AS avg_grade
FROM grades
GROUP BY student_id
ORDER BY avg_grade DESC;

--Информация об учениках и их классах
SELECT s.student_id, s.name AS student_name, c.name AS class_name, s.age
FROM students s
         JOIN classes c ON s.class_id = c.class_id;

--Создание представления (оценки с именами учеников)
CREATE VIEW student_grades AS
SELECT s.name AS student_name, g.subject, g.grade
FROM grades g
         JOIN students s ON g.student_id = s.student_id;

SELECT * FROM student_grades;

--Запрос с CASE WHEN (определение успеваемости)
SELECT student_id, grade,
       CASE WHEN grade = 5 THEN 'Отлично'
            WHEN grade = 4 THEN 'Хорошо'
            WHEN grade = 3 THEN 'Удовлетворительно'
            ELSE 'Нужно подтянуться' END AS performance
FROM grades;

-- COALESCE, если у ученика нет оценок, показываем "Нет оценок"
INSERT INTO students (name, class_id, age)
VALUES ('Яша Белоручка', 1, 7);

SELECT s.name, COALESCE(g.subject, 'Нет оценок') AS subject, COALESCE(g.grade, 0) AS grade
FROM students s
         LEFT JOIN grades g ON s.student_id = g.student_id;

--Получение количества учеников в классе)
CREATE FUNCTION get_student_count(class_id_param INT) RETURNS INT AS $$
DECLARE student_count INT;
BEGIN
SELECT COUNT(*) INTO student_count FROM students WHERE class_id = class_id_param;
RETURN student_count;
END;
$$ LANGUAGE plpgsql;

--Проверка
SELECT get_student_count(1);
