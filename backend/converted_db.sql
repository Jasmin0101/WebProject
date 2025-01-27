-- Table: app_application
CREATE TABLE app_application (
  id INTEGER PRIMARY KEY AUTOINCREMENT, 
  title VARCHAR(255) NOT NULL, 
  date_created DATETIME NOT NULL, 
  author_id INTEGER NOT NULL,
  total_attachments INTEGER NOT NULL, 
  status VARCHAR(2) NOT NULL,
  FOREIGN KEY (author_id) REFERENCES app_user (id)
);

-- Table: app_city
CREATE TABLE app_city (
  id INTEGER PRIMARY KEY AUTOINCREMENT, 
  city_en VARCHAR(200) NOT NULL, 
  city VARCHAR(200)
);

-- Table: app_fileapplicationattachments
CREATE TABLE app_fileapplicationattachments (
  id INTEGER PRIMARY KEY AUTOINCREMENT, 
  number_in_order INTEGER NOT NULL, 
  application_id INTEGER NOT NULL,
  author_id INTEGER NOT NULL,
  file VARCHAR(100) NOT NULL,
  FOREIGN KEY (application_id) REFERENCES app_application (id),
  FOREIGN KEY (author_id) REFERENCES app_user (id)
);

-- Table: app_forecast
CREATE TABLE app_forecast (
  id INTEGER PRIMARY KEY AUTOINCREMENT, 
  date DATE, 
  time TIME, 
  temperature REAL, 
  conditions VARCHAR(255), 
  pressure REAL, 
  humidity REAL, 
  city_id INTEGER NOT NULL, 
  wind_speed REAL,
  FOREIGN KEY (city_id) REFERENCES app_city (id)
);

-- Table: app_infoapplicationattachments
CREATE TABLE app_infoapplicationattachments (
  id INTEGER PRIMARY KEY AUTOINCREMENT, 
  number_in_order INTEGER NOT NULL, 
  info TEXT NOT NULL, 
  application_id INTEGER NOT NULL,
  FOREIGN KEY (application_id) REFERENCES app_application (id)
);

-- Table: app_textapplicationattachments
CREATE TABLE app_textapplicationattachments (
  id INTEGER PRIMARY KEY AUTOINCREMENT, 
  number_in_order INTEGER NOT NULL, 
  text TEXT NOT NULL, 
  application_id INTEGER NOT NULL, 
  author_id INTEGER NOT NULL,
  FOREIGN KEY (application_id) REFERENCES app_application (id),
  FOREIGN KEY (author_id) REFERENCES app_user (id)
);

-- Table: app_user
CREATE TABLE app_user (
  id INTEGER PRIMARY KEY AUTOINCREMENT, 
  password VARCHAR(255), 
  dob DATE, 
  login VARCHAR(180), 
  name VARCHAR(255), 
  surname VARCHAR(255), 
  email VARCHAR(255) NOT NULL, 
  city_id INTEGER NOT NULL, 
  status VARCHAR(2) NOT NULL,
  FOREIGN KEY (city_id) REFERENCES app_city (id)
);

-- Indexes:
CREATE INDEX app_application_author_id_idx ON app_application (author_id);
CREATE INDEX app_fileapplicationattachments_application_id_idx ON app_fileapplicationattachments (application_id);
CREATE INDEX app_fileapplicationattachments_author_id_idx ON app_fileapplicationattachments (author_id);
CREATE INDEX app_forecast_city_id_idx ON app_forecast (city_id);
CREATE INDEX app_infoapplicationattachments_application_id_idx ON app_infoapplicationattachments (application_id);
CREATE INDEX app_textapplicationattachments_application_id_idx ON app_textapplicationattachments (application_id);
CREATE INDEX app_textapplicationattachments_author_id_idx ON app_textapplicationattachments (author_id);
CREATE INDEX app_user_city_id_idx ON app_user (city_id);
