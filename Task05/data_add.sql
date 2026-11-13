INSERT INTO users (first_name, last_name, email, gender, register_date, occupation_id)
VALUES (
  'Алексей', 'Воронин', 'voronin.as@mrsu.ru', 'male',
  date('now'),
  (SELECT id FROM occupations WHERE name = 'student')
);

INSERT INTO users (first_name, last_name, email, gender, register_date, occupation_id)
VALUES (
  'Илья', 'Берман', 'berman.ia@mrsu.ru', 'male',
  date('now'),
  (SELECT id FROM occupations WHERE name = 'student')
);

INSERT INTO users (first_name, last_name, email, gender, register_date, occupation_id)
VALUES (
  'Глеб', 'Вельдяскин', 'veldyaskin.gv@mrsu.ru', 'male',
  date('now'),
  (SELECT id FROM occupations WHERE name = 'student')
);

INSERT INTO users (first_name, last_name, email, gender, register_date, occupation_id)
VALUES (
  'Максим', 'Денисов', 'denisov.ms@mrsu.ru', 'male',
  date('now'),
  (SELECT id FROM occupations WHERE name = 'student')
);

INSERT INTO users (first_name, last_name, email, gender, register_date, occupation_id)
VALUES (
  'Кирилл', 'Ефимкин', 'efimkin.kd@mrsu.ru', 'male',
  date('now'),
  (SELECT id FROM occupations WHERE name = 'student')
);

INSERT INTO movies (title, year) VALUES ('Inception Fan Cut', 2024);
INSERT INTO movie_genres (movie_id, genre_id)
VALUES (
  (SELECT id FROM movies WHERE title = 'Inception Fan Cut' AND year = 2024),
  (SELECT id FROM genres WHERE name = 'Sci-Fi')
);

INSERT INTO movies (title, year) VALUES ('Campus Comedy Night', 2025);
INSERT INTO movie_genres (movie_id, genre_id)
VALUES (
  (SELECT id FROM movies WHERE title = 'Campus Comedy Night' AND year = 2025),
  (SELECT id FROM genres WHERE name = 'Comedy')
);

INSERT INTO movies (title, year) VALUES ('Northern Lights Drama', 2023);
INSERT INTO movie_genres (movie_id, genre_id)
VALUES (
  (SELECT id FROM movies WHERE title = 'Northern Lights Drama' AND year = 2023),
  (SELECT id FROM genres WHERE name = 'Drama')
);

INSERT INTO ratings (user_id, movie_id, rating, timestamp)
VALUES (
  (SELECT id FROM users WHERE email = 'voronin.as@mrsu.ru'),
  (SELECT id FROM movies WHERE title = 'Inception Fan Cut' AND year = 2024),
  4.5,
  strftime('%s', 'now')
);

INSERT INTO ratings (user_id, movie_id, rating, timestamp)
VALUES (
  (SELECT id FROM users WHERE email = 'voronin.as@mrsu.ru'),
  (SELECT id FROM movies WHERE title = 'Campus Comedy Night' AND year = 2025),
  4.0,
  strftime('%s', 'now')
);

INSERT INTO ratings (user_id, movie_id, rating, timestamp)
VALUES (
  (SELECT id FROM users WHERE email = 'voronin.as@mrsu.ru'),
  (SELECT id FROM movies WHERE title = 'Northern Lights Drama' AND year = 2023),
  5.0,
  strftime('%s', 'now')
);