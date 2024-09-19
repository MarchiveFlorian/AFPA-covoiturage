-- ENUM types
CREATE TYPE user_role AS ENUM ('employé', 'stagiaire');
CREATE TYPE employee_role AS ENUM ('formateur', 'administratif', 'externe', 'autre');
CREATE TYPE enum_fuel AS ENUM ('Essence', 'Gazole', 'GPL', 'Electrique');
CREATE TYPE enum_vehicule AS ENUM ('Compact', 'Berline', '4x4', 'Monospace', 'Utilitaire');
CREATE TYPE enum_trip AS ENUM ('ponctuel', 'régulier');

-- Table "user"
CREATE TABLE "user" (
   Id_user SERIAL PRIMARY KEY,
   last_name VARCHAR(50),
   first_name VARCHAR(50),
   email VARCHAR(100) UNIQUE,
   password VARCHAR(50),
   role user_role,
   registration_date TIMESTAMP,
   is_active BOOLEAN NOT NULL,
   phone VARCHAR(50),
   birthdate DATE,
   address VARCHAR(50),
   notif_preference VARCHAR(50)
);

-- Table participation
CREATE TABLE participation (
   Id_participation SERIAL PRIMARY KEY,
   start_date DATE,
   end_date DATE,
   status VARCHAR(50)
);

-- Table notification
CREATE TABLE notification (
   Id_notification SERIAL PRIMARY KEY,
   message VARCHAR(500),
   notification_date TIMESTAMP,
   is_read BOOLEAN,
   Id_user INT NOT NULL,
   FOREIGN KEY (Id_user) REFERENCES "user"(Id_user)
);

-- Table employee
CREATE TABLE employee (
   Id_employee SERIAL PRIMARY KEY,
   role employee_role,
   contract_duration VARCHAR(50),
   Id_user INT NOT NULL UNIQUE,
   FOREIGN KEY (Id_user) REFERENCES "user"(Id_user)
);

-- Table student
CREATE TABLE student (
   Id_student SERIAL PRIMARY KEY,
   training_name VARCHAR(50),
   Id_user INT NOT NULL UNIQUE,
   FOREIGN KEY (Id_user) REFERENCES "user"(Id_user)
);

-- Table fuel
CREATE TABLE fuel (
   Id_fuel SERIAL PRIMARY KEY,
   name enum_fuel,
   price VARCHAR(50)
);

-- Table afpa_center
CREATE TABLE afpa_center (
   Id_afpa_center SERIAL PRIMARY KEY,
   name VARCHAR(50),
   city VARCHAR(50),
   address VARCHAR(50),
   schedule TIMESTAMP
);

-- Table vehicle
CREATE TABLE vehicle (
   Id_vehicle SERIAL PRIMARY KEY,
   modele VARCHAR(50),
   vehicule_type enum_vehicule,
   empty_seat INT,
   avg_fuel_consomption INT,
   Id_fuel INT NOT NULL,
   Id_user INT NOT NULL,
   FOREIGN KEY (Id_fuel) REFERENCES fuel(Id_fuel),
   FOREIGN KEY (Id_user) REFERENCES "user"(Id_user)
);

-- Table trip
CREATE TABLE trip (
   Id_trip SERIAL PRIMARY KEY,
   departure_address VARCHAR(50),
   departure_date TIMESTAMP,
   arrival_address VARCHAR(50),
   trip_type enum_trip,
   trip_price DECIMAL(15,2),
   trip_description VARCHAR(50),
   frequency VARCHAR(100),
   Id_vehicle INT NOT NULL,
   Id_user INT NOT NULL,
   FOREIGN KEY (Id_vehicle) REFERENCES vehicle(Id_vehicle),
   FOREIGN KEY (Id_user) REFERENCES "user"(Id_user)
);

-- Table comment
CREATE TABLE comment (
   Id_comment SERIAL PRIMARY KEY,
   comment_text VARCHAR(300),
   comment_date TIMESTAMP,
   Id_trip INT NOT NULL,
   Id_user INT NOT NULL,
   FOREIGN KEY (Id_trip) REFERENCES trip(Id_trip),
   FOREIGN KEY (Id_user) REFERENCES "user"(Id_user)
);

-- Table training_session
CREATE TABLE training_session (
   Id_training_session SERIAL PRIMARY KEY,
   name VARCHAR(50),
   start_date DATE,
   end_date DATE,
   Id_afpa_center INT NOT NULL,
   FOREIGN KEY (Id_afpa_center) REFERENCES afpa_center(Id_afpa_center)
);

-- Table participation_user
CREATE TABLE participation_user (
   Id_user INT,
   Id_participation INT,
   PRIMARY KEY (Id_user, Id_participation),
   FOREIGN KEY (Id_user) REFERENCES "user"(Id_user),
   FOREIGN KEY (Id_participation) REFERENCES participation(Id_participation)
);

-- Table participation_trip
CREATE TABLE participation_trip (
   Id_trip INT,
   Id_participation INT,
   PRIMARY KEY (Id_trip, Id_participation),
   FOREIGN KEY (Id_trip) REFERENCES trip(Id_trip),
   FOREIGN KEY (Id_participation) REFERENCES participation(Id_participation)
);

-- Table employee_training
CREATE TABLE employee_training (
   Id_training_session INT,
   Id_employee INT,
   PRIMARY KEY (Id_training_session, Id_employee),
   FOREIGN KEY (Id_training_session) REFERENCES training_session(Id_training_session),
   FOREIGN KEY (Id_employee) REFERENCES employee(Id_employee)
);

-- Table student_training
CREATE TABLE student_training (
   Id_training_session INT,
   Id_student INT,
   PRIMARY KEY (Id_training_session, Id_student),
   FOREIGN KEY (Id_training_session) REFERENCES training_session(Id_training_session),
   FOREIGN KEY (Id_student) REFERENCES student(Id_student)
);