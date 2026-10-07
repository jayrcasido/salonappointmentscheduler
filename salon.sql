DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS services;

CREATE TABLE customers (
  customer_id SERIAL PRIMARY KEY,
  phone VARCHAR(20) UNIQUE,
  name VARCHAR(255) NOT NULL
);

CREATE TABLE services (
  service_id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

CREATE TABLE appointments (
  appointment_id SERIAL PRIMARY KEY,
  customer_id INT NOT NULL,
  service_id INT NOT NULL,
  time VARCHAR(255) NOT NULL,
  CONSTRAINT appointments_customer_fk FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  CONSTRAINT appointments_service_fk FOREIGN KEY (service_id) REFERENCES services(service_id)
);

INSERT INTO services (name) VALUES
  ('cut'),
  ('color'),
  ('perm'),
  ('style'),
  ('trim');
