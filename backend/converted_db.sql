CREATE TABLE app_city (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    city_en VARCHAR(200) NOT NULL,
    city VARCHAR(200)
);

CREATE TABLE app_user (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    password VARCHAR(255),
    dob DATE,
    login VARCHAR(180),
    name VARCHAR(255),
    surname VARCHAR(255),
    email VARCHAR(255) NOT NULL,
    city_id INTEGER NOT NULL,
    FOREIGN KEY (city_id) REFERENCES app_city (id)
);

CREATE TABLE app_application (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title VARCHAR(255) NOT NULL,
    text TEXT NOT NULL,
    date_created DATETIME NOT NULL,
    author_id INTEGER NOT NULL,
    status VARCHAR(30) NOT NULL,
    FOREIGN KEY (author_id) REFERENCES app_user (id)
);

CREATE TABLE app_forecast (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date DATE,
    time TIME,
    temperature REAL,
    conditions VARCHAR(255),
    pressure REAL,
    humidity REAL,
    city_id INTEGER NOT NULL,
    max_temp REAL,
    min_temp REAL,
    wind_speed REAL,
    FOREIGN KEY (city_id) REFERENCES app_city (id)
);

-- Индексы для оптимизации запросов
CREATE INDEX app_user_city_id_idx ON app_user (city_id);
CREATE INDEX app_application_author_id_idx ON app_application (author_id);
CREATE INDEX app_forecast_city_id_idx ON app_forecast (city_id);
