-- База данных парикмахерской
-- Спецификация: кадровый учёт, услуги, запись, выполненные работы, зарплата

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS appointment_services;
DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS schedule;
DROP TABLE IF EXISTS services;
DROP TABLE IF EXISTS clients;
DROP TABLE IF EXISTS masters;

-- Мастера (кадровый учёт; при увольнении данные сохраняются)
CREATE TABLE masters (
  id              INTEGER PRIMARY KEY,
  full_name       TEXT    NOT NULL,
  phone           TEXT,
  specialization  TEXT    NOT NULL CHECK (specialization IN ('male', 'female', 'universal')),
  salary_percent  REAL    NOT NULL CHECK (salary_percent > 0 AND salary_percent <= 100),
  hire_date       TEXT    NOT NULL DEFAULT (date('now')),
  fire_date       TEXT,   -- NULL = работает
  is_active       INTEGER NOT NULL DEFAULT 1 CHECK (is_active IN (0, 1))
);

-- Индивидуальный график работы мастера
CREATE TABLE schedule (
  id          INTEGER PRIMARY KEY,
  master_id   INTEGER NOT NULL REFERENCES masters(id) ON DELETE RESTRICT,
  weekday     INTEGER NOT NULL CHECK (weekday BETWEEN 1 AND 7), -- 1=пн … 7=вс
  start_time  TEXT    NOT NULL,  -- '09:00'
  end_time    TEXT    NOT NULL,  -- '18:00'
  CHECK (start_time < end_time)
);

-- Справочник услуг (для мужчин / женщин / обоих)
CREATE TABLE services (
  id            INTEGER PRIMARY KEY,
  name          TEXT    NOT NULL,
  duration_min  INTEGER NOT NULL CHECK (duration_min > 0),
  price         REAL    NOT NULL CHECK (price >= 0),
  for_gender    TEXT    NOT NULL CHECK (for_gender IN ('male', 'female', 'both'))
);

-- Клиенты
CREATE TABLE clients (
  id         INTEGER PRIMARY KEY,
  full_name  TEXT NOT NULL,
  phone      TEXT,
  gender     TEXT NOT NULL CHECK (gender IN ('male', 'female'))
);

-- Предварительная запись / факт визита
CREATE TABLE appointments (
  id                   INTEGER PRIMARY KEY,
  client_id            INTEGER NOT NULL REFERENCES clients(id) ON DELETE RESTRICT,
  master_id            INTEGER NOT NULL REFERENCES masters(id) ON DELETE RESTRICT,
  appointment_datetime TEXT    NOT NULL,  -- 'YYYY-MM-DD HH:MM'
  status               TEXT    NOT NULL DEFAULT 'scheduled'
                               CHECK (status IN ('scheduled', 'completed', 'cancelled')),
  total_price          REAL,   -- итоговая сумма (заполняется при completed)
  created_at           TEXT    NOT NULL DEFAULT (datetime('now'))
);

-- Услуги в рамках одной записи (M:N)
CREATE TABLE appointment_services (
  appointment_id  INTEGER NOT NULL REFERENCES appointments(id) ON DELETE CASCADE,
  service_id      INTEGER NOT NULL REFERENCES services(id) ON DELETE RESTRICT,
  price_at_time   REAL    NOT NULL CHECK (price_at_time >= 0), -- цена на момент записи
  PRIMARY KEY (appointment_id, service_id)
);

-- ========== ТЕСТОВЫЕ ДАННЫЕ ==========

INSERT INTO masters (id, full_name, phone, specialization, salary_percent, hire_date, fire_date, is_active) VALUES
(1, 'Иванов Пётр Сергеевич',   '+79001112233', 'male',      40.0, '2022-03-01', NULL,         1),
(2, 'Смирнова Анна Викторовна','+79002223344', 'female',    45.0, '2021-06-15', NULL,         1),
(3, 'Козлов Дмитрий Игоревич', '+79003334455', 'universal', 50.0, '2020-01-10', NULL,         1),
(4, 'Петрова Ольга Николаевна','+79004445566', 'female',    42.0, '2019-09-01', '2024-12-31', 0);

INSERT INTO schedule (master_id, weekday, start_time, end_time) VALUES
(1, 1, '09:00', '18:00'),
(1, 2, '09:00', '18:00'),
(1, 3, '09:00', '18:00'),
(1, 4, '09:00', '18:00'),
(1, 5, '09:00', '18:00'),
(2, 1, '10:00', '19:00'),
(2, 2, '10:00', '19:00'),
(2, 3, '10:00', '19:00'),
(2, 5, '10:00', '19:00'),
(2, 6, '10:00', '16:00'),
(3, 1, '09:00', '20:00'),
(3, 2, '09:00', '20:00'),
(3, 3, '09:00', '20:00'),
(3, 4, '09:00', '20:00'),
(3, 5, '09:00', '20:00'),
(3, 6, '10:00', '15:00'),
(4, 1, '09:00', '17:00'),
(4, 3, '09:00', '17:00'),
(4, 5, '09:00', '17:00');

INSERT INTO services (id, name, duration_min, price, for_gender) VALUES
(1,  'Мужская стрижка',           30,  500.00, 'male'),
(2,  'Бритьё опасной бритвой',    25,  400.00, 'male'),
(3,  'Моделирование бороды',      20,  350.00, 'male'),
(4,  'Женская стрижка',           45,  800.00, 'female'),
(5,  'Укладка',                   40,  600.00, 'female'),
(6,  'Окрашивание',               90, 2500.00, 'female'),
(7,  'Мелирование',              120, 3000.00, 'female'),
(8,  'Мытьё головы',              15,  200.00, 'both'),
(9,  'Детская стрижка',           25,  400.00, 'both'),
(10, 'Комплексный уход',          60, 1200.00, 'both');

INSERT INTO clients (id, full_name, phone, gender) VALUES
(1, 'Сидоров Алексей',     '+79161234567', 'male'),
(2, 'Кузнецова Мария',     '+79167654321', 'female'),
(3, 'Волков Андрей',       '+79165551122', 'male'),
(4, 'Новикова Екатерина',  '+79163334455', 'female'),
(5, 'Морозов Игорь',       '+79162223344', 'male');

INSERT INTO appointments (id, client_id, master_id, appointment_datetime, status, total_price, created_at) VALUES
(1, 1, 1, '2025-11-10 10:00', 'completed',  900.00, '2025-11-08 12:00:00'),
(2, 2, 2, '2025-11-10 11:00', 'completed', 1400.00, '2025-11-09 09:30:00'),
(3, 3, 3, '2025-11-11 14:00', 'completed',  850.00, '2025-11-10 18:00:00'),
(4, 4, 2, '2025-11-12 15:00', 'scheduled',   NULL,  '2025-11-11 10:00:00'),
(5, 5, 1, '2025-11-12 16:00', 'scheduled',   NULL,  '2025-11-11 11:00:00'),
(6, 1, 3, '2025-10-05 12:00', 'completed',  700.00, '2025-10-01 14:00:00'),
(7, 2, 4, '2024-11-20 13:00', 'completed', 3300.00, '2024-11-18 09:00:00');

INSERT INTO appointment_services (appointment_id, service_id, price_at_time) VALUES
(1, 1,  500.00),
(1, 2,  400.00),
(2, 4,  800.00),
(2, 5,  600.00),
(3, 1,  500.00),
(3, 3,  350.00),
(4, 6, 2500.00),
(4, 5,  600.00),
(5, 1,  500.00),
(5, 8,  200.00),
(6, 1,  500.00),
(6, 8,  200.00),
(7, 6, 2500.00),
(7, 4,  800.00);
