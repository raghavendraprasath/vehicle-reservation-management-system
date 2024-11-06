-- Check if sequence exists, drop if it does, then create
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE user_seq';
EXCEPTION
    WHEN OTHERS THEN
        NULL; -- Ignore errors if sequence does not exist
END;
/
CREATE SEQUENCE user_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

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
    year NUMBER NOT NULL,
    status VARCHAR2(20) DEFAULT 'Available',
    CHECK (status IN ('Available', 'Reserved', 'In Maintenance')),
    location_id NUMBER,
    price_per_hour NUMBER(10, 2) NOT NULL,
    max_retail_price NUMBER(10, 2) NOT NULL,
    FOREIGN KEY (location_id) REFERENCES Locations(location_id)
);


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



BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Locations CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL; -- Ignore errors if table does not exist
END;
/
CREATE TABLE Locations (
    location_id NUMBER PRIMARY KEY,
    address VARCHAR2(255) NOT NULL,
    city VARCHAR2(100) NOT NULL,
    state VARCHAR2(100) NOT NULL,
    zip_code VARCHAR2(10) NOT NULL
);



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
    status VARCHAR2(20) CHECK (status IN ('Confirmed', 'Cancelled', 'Completed')),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id),
    FOREIGN KEY (location_id) REFERENCES Locations(location_id)
);