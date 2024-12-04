BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Users CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL; -- Ignore errors if table does not exist
END;
/

CREATE TABLE Users (
    user_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) NOT NULL UNIQUE,
    password VARCHAR2(255) NOT NULL,
    driver_license VARCHAR2(50) NOT NULL UNIQUE,
    phone_number VARCHAR2(15),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    role VARCHAR2(20),
    CONSTRAINT chk_role CHECK (role IN ('user', 'admin'))
);


-- Clear existing data
DELETE FROM Users;

-- Insert new data
INSERT INTO Users (user_id, first_name, last_name, email, password, driver_license, phone_number, role) VALUES
(1, 'John', 'Doe', 'john.doe@example.com', 'password123', 'D123456', '123-456-7890', 'user'),
(2, 'Jane', 'Smith', 'jane.smith@example.com', 'password123', 'D654321', '234-567-8901', 'user'),
(3, 'Alice', 'Johnson', 'alice.j@example.com', 'password123', 'D789123', '345-678-9012', 'admin'),
(4, 'Bob', 'Brown', 'bob.brown@example.com', 'password123', 'D321789', '456-789-0123', 'user'),
(5, 'Carol', 'White', 'carol.w@example.com', 'password123', 'D456789', '567-890-1234', 'user'),
(6, 'David', 'Black', 'david.b@example.com', 'password123', 'D987654', '678-901-2345', 'user'),
(7, 'Emma', 'Green', 'emma.g@example.com', 'password123', 'D147258', '789-012-3456', 'user'),
(8, 'Frank', 'Blue', 'frank.b@example.com', 'password123', 'D369852', '890-123-4567', 'user');




BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Locations CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL; -- Ignore errors if table does not exist
END;
/
CREATE TABLE Locations (
    location_id NUMBER PRIMARY KEY,
    user_id NUMBER,
    address VARCHAR2(255) NOT NULL,
    city VARCHAR2(100) NOT NULL,
    state VARCHAR2(100) NOT NULL,
    zip_code VARCHAR2(10) NOT NULL,
    longitude NUMBER(9, 4),
    latitude NUMBER(9, 4),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);


-- Clear existing data
DELETE FROM Locations;

-- Insert new data
INSERT INTO Locations (location_id, user_id, address, city, state, zip_code, longitude, latitude) VALUES
(1, 1, '123 Elm St', 'Springfield', 'IL', '62701', -89.6500, 39.8000),
(2, 2, '456 Oak St', 'Springfield', 'IL', '62702', -89.6501, 39.8001),
(3, 3, '789 Pine St', 'Springfield', 'IL', '62703', -89.6502, 39.8002),
(4, 4, '101 Maple St', 'Springfield', 'IL', '62704', -89.6503, 39.8003),
(5, 5, '202 Cedar St', 'Chicago', 'IL', '62705', -89.6504, 39.8004),
(6, 6, '303 Birch St', 'Chicago', 'IL', '62706', -89.6505, 39.8005),
(7, 7, '404 Willow St', 'Chicago', 'IL', '62707', -89.6506, 39.8006),
(8, 8, '505 Aspen St', 'Chicago', 'IL', '62708', -89.6507, 39.8007);




BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE User_Locations CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL; -- Ignore errors if table does not exist
END;
/
CREATE TABLE User_Locations (
    user_id NUMBER PRIMARY KEY,
    location_id NUMBER,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (location_id) REFERENCES Locations(location_id)
);


-- Clear existing data
DELETE FROM User_Locations;

-- Insert new data
INSERT INTO User_Locations (user_id, location_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8);




BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Vehicles CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL; -- Ignore errors if table does not exist
END;
/
CREATE TABLE Vehicles (
    vehicle_id NUMBER PRIMARY KEY,
    make VARCHAR2(50) NOT NULL,
    model VARCHAR2(50) NOT NULL,
    year NUMBER NOT NULL CHECK (year >= 1886), -- Only lower bound enforced in the table
    status VARCHAR2(20) DEFAULT 'Available' CHECK (status IN ('Available', 'Reserved', 'Unavailable')), -- Ensures valid statuses
    assigned_to_reservation VARCHAR2(20) DEFAULT 'No' CHECK (assigned_to_reservation IN ('Yes', 'No')), -- Binary indicator for reservation
    last_reserved_date TIMESTAMP,
    location_id NUMBER,
    price_per_hour NUMBER(10, 2) NOT NULL CHECK (price_per_hour >= 0), -- Ensures non-negative pricing
    max_retail_price NUMBER(10, 2) NOT NULL,
    longitude NUMBER(9, 4) CHECK (longitude BETWEEN -180 AND 180), -- Valid longitude range
    latitude NUMBER(9, 4) CHECK (latitude BETWEEN -90 AND 90), -- Valid latitude range
    FOREIGN KEY (location_id) REFERENCES Locations(location_id),
    CONSTRAINT chk_price CHECK (max_retail_price >= price_per_hour) -- Table-level check for cross-column constraint
);

CREATE OR REPLACE TRIGGER trg_check_vehicle_year
BEFORE INSERT OR UPDATE ON Vehicles
FOR EACH ROW
BEGIN
    IF :NEW.year > EXTRACT(YEAR FROM SYSDATE) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Year cannot be in the future.');
    END IF;
END;
/





-- Clear existing data
DELETE FROM Vehicles;

-- Insert new data
INSERT INTO Vehicles (
    vehicle_id, make, model, year, status, assigned_to_reservation, last_reserved_date, location_id, 
    price_per_hour, max_retail_price, longitude, latitude
) VALUES
(1, 'Toyota', 'Camry', 2020, 'Available', 'No', NULL, 1, 15.50, 25000.00, -89.6500, 39.8000),
(2, 'Honda', 'Civic', 2021, 'Available', 'No', NULL, 2, 17.00, 22000.00, -89.6501, 39.8001),
(3, 'Ford', 'Focus', 2019, 'Available', 'No', NULL, 3, 12.75, 18000.00, -89.6502, 39.8002),
(4, 'Chevrolet', 'Malibu', 2018, 'Available', 'No', NULL, 4, 16.00, 21000.00, -89.6503, 39.8003),
(5, 'Nissan', 'Altima', 2020, 'Available', 'No', NULL, 5, 18.25, 23000.00, -89.6504, 39.8004),
(6, 'Hyundai', 'Elantra', 2021, 'Available', 'No', NULL, 6, 14.50, 20000.00, -89.6505, 39.8005),
(7, 'Volkswagen', 'Passat', 2019, 'Available', 'No', NULL, 7, 15.75, 19000.00, -89.6506, 39.8006),
(8, 'Subaru', 'Impreza', 2022, 'Available', 'No', NULL, 8, 19.00, 24000.00, -89.6507, 39.8007);






BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Vehicle_Locations CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL; -- Ignore errors if table does not exist
END;
/
CREATE TABLE Vehicle_Locations (
    vehicle_id NUMBER PRIMARY KEY,
    location_id NUMBER,
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id),
    FOREIGN KEY (location_id) REFERENCES Locations(location_id)
);


-- Clear existing data
DELETE FROM Vehicle_Locations;

-- Insert new data
INSERT INTO Vehicle_Locations (vehicle_id, location_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8);



BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Vehicle_Price_Changes CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL; -- Ignore errors if table does not exist
END;
/
CREATE TABLE Vehicle_Price_Changes (
    price_change_id NUMBER PRIMARY KEY,
    vehicle_id NUMBER,
    old_price NUMBER(10, 2) NOT NULL,
    new_price NUMBER(10, 2) NOT NULL,
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id)
);


-- Clear existing data
DELETE FROM Vehicle_Price_Changes;

-- Insert new data
INSERT INTO Vehicle_Price_Changes (price_change_id, vehicle_id, old_price, new_price, change_date) VALUES
(1, 1, 15.00, 15.50, SYSTIMESTAMP - INTERVAL '10' DAY),
(2, 2, 16.50, 17.00, SYSTIMESTAMP - INTERVAL '9' DAY),
(3, 3, 12.50, 12.75, SYSTIMESTAMP - INTERVAL '8' DAY),
(4, 4, 15.75, 16.00, SYSTIMESTAMP - INTERVAL '7' DAY),
(5, 5, 18.00, 18.25, SYSTIMESTAMP - INTERVAL '6' DAY),
(6, 6, 14.25, 14.50, SYSTIMESTAMP - INTERVAL '5' DAY),
(7, 7, 15.50, 15.75, SYSTIMESTAMP - INTERVAL '4' DAY),
(8, 8, 18.75, 19.00, SYSTIMESTAMP - INTERVAL '3' DAY);




BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Reservations CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL; -- Ignore errors if table does not exist
END;
/
CREATE TABLE Reservations (
    reservation_id NUMBER PRIMARY KEY,
    user_id NUMBER,
    vehicle_id NUMBER,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    location_id NUMBER,
    status VARCHAR2(20) CHECK (status IN ('Confirmed', 'Cancelled', 'Completed', 'Pending')),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id),
    FOREIGN KEY (location_id) REFERENCES Locations(location_id)
);


-- Clear existing data
DELETE FROM Reservations;


-- Insert new data into Reservations
INSERT INTO Reservations (
    reservation_id, user_id, vehicle_id, start_time, end_time, location_id, status
) VALUES
(1, 1, 1, SYSTIMESTAMP - INTERVAL '20' DAY, SYSTIMESTAMP - INTERVAL '18' DAY, 1, 'Completed'),
(2, 2, 2, SYSTIMESTAMP - INTERVAL '15' DAY, SYSTIMESTAMP - INTERVAL '13' DAY, 2, 'Completed')
