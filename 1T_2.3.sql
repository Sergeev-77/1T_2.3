DROP TABLE IF EXISTS public.score;
DROP TABLE IF EXISTS public.users;
DROP TABLE IF EXISTS public.departments;

CREATE TABLE public.departments(
	department_id 						SERIAL PRIMARY KEY,
	department 							VARCHAR NOT NULL,
	head								VARCHAR NOT NULL,
	staff_count							INT DEFAULT 1
)
;

INSERT INTO public.departments (department, head, staff_count) 
VALUES 
('Разработка', 'Иванов И.И', 3),
('Инженеры', 'Петров П.П', 2)

;


CREATE TABLE public.users (
	user_id 							SERIAL PRIMARY KEY,
	username 							VARCHAR  NOT NULL,
	birthdate 							DATE  NOT NULL,
	employment_date						DATE  NOT NULL,
	job_position						VARCHAR NOT NULL,
	grade								VARCHAR CHECK (grade IN ('jun', 'middle', 'senior', 'lead')),
	salary								INT NOT NULL,
	department_id						INT,
	driver_license						BOOL DEFAULT  (trunc(random() * 1000000)::int % 2)::bool,
FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE CASCADE
)
;

INSERT INTO public.users (username, birthdate, employment_date, job_position, grade, salary, department_id) 
VALUES 
('Иванов И.И', '2000-01-01', '2020-11-01', 'Руководитель отдела разработки', 'lead', 200000,1),
('Сидоров С.С', '2001-05-03', '2021-10-01', 'Зам руководителя отдела разработки', 'senior', 150000,1),
('Смирнов С.С', '2003-03-03', '2021-09-01', 'Разработчик', 'middle', 100000,1),

('Петров П.П', '2002-02-02', '2021-07-07', 'Руководитель отдела инженеров', 'lead', 200000,2),
('Васечкин В.В', '2004-04-04', '2021-06-06', 'Инженер', 'jun', 100000,2)


;

CREATE TABLE public.score (
	user_id 							INT,
	quarter 							DATE  NOT NULL CHECK (quarter = date_trunc('quarter',quarter)),
	score	 							CHAR(1) CHECK (score IN ('A', 'B', 'C', 'D', 'E')),
CONSTRAINT score_pkey PRIMARY KEY (user_id, quarter),
FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
)
;
INSERT INTO public.score (user_id, quarter, score) 
VALUES 
(1, '2022-01-01', 'A'),
(1, '2022-04-01', 'B'),
(2, '2022-01-01', 'B'),
(2, '2022-04-01', 'C'),
(3, '2022-01-01', 'C'),
(3, '2022-04-01', 'D'),
(4, '2022-01-01', 'D'),
(4, '2022-04-01', 'E'),
(5, '2022-01-01', 'E'),
(5, '2022-04-01', 'A')
;

INSERT INTO public.departments (department, head, staff_count) 
VALUES 
('Интелектуальный анализ данных', 'Лекун Я.', 3)
;

INSERT INTO public.users (username, birthdate, employment_date, job_position, grade, salary, department_id) 
VALUES 
('Лекун Я.', '1980-01-01', '2022-10-01', 'Руководитель отдела интелектуального анализа данных', 'lead', 1000000, 3),
('Ын А.', '1970-07-07', '2022-10-01', 'Зам.руководителя отдела интелектуального анализа данных', 'middle', 500000, 3),
('Симпсон Б.', '1960-06-06', '2022-10-01', 'Аналитик', 'jun', 50000, 3)
;

--Уникальный номер сотрудника, его ФИО и стаж работы – для всех сотрудников компании
SELECT 
	user_id,
	username,
	age(CURRENT_DATE, employment_date) experience
FROM users;

-- Уникальный номер сотрудника, его ФИО и стаж работы – только первых 3-х сотрудников
SELECT 
	user_id,
	username,
	age(CURRENT_DATE, employment_date) experience
FROM users
LIMIT 3
;

-- Уникальный номер сотрудников - водителей
SELECT 
	user_id
FROM users
WHERE driver_license 
;

--   Выведите номера сотрудников, которые хотя бы за 1 квартал получили оценку D или E
SELECT user_id 
	FROM score
WHERE quarter = '2022-01-01'  AND score IN ('D', 'E')
;

--Выведите самую высокую зарплату в компании.
SELECT 
	MAX(salary)
FROM users
;