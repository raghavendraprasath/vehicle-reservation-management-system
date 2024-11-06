BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Maintenance CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL; -- Ignore errors if table does not exist
END;
/
CREATE TABLE Maintenance (
    maintenance_id NUMBER PRIMARY KEY,
    vehicle_id NUMBER,
    maintenance_date TIMESTAMP NOT NULL,
    description VARCHAR2(255),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id)
);



BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Payments CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL; -- Ignore errors if table does not exist
END;
/
CREATE TABLE Payments (
    payment_id NUMBER PRIMARY KEY,
    reservation_id NUMBER,
    amount NUMBER(10, 2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    region VARCHAR2(100),
    FOREIGN KEY (reservation_id) REFERENCES Reservations(reservation_id)
);


BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Emergency CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL; -- Ignore errors if table does not exist
END;
/
CREATE TABLE Emergency (
    emergency_id NUMBER PRIMARY KEY,
    vehicle_id NUMBER,
    incident_time TIMESTAMP NOT NULL,
    description VARCHAR2(255),
    reported_to VARCHAR2(100),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id)
);


BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Complaints CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL; -- Ignore errors if table does not exist
END;
/
CREATE TABLE Complaints (
    complaint_id NUMBER PRIMARY KEY,
    user_id NUMBER,
    complaint_date TIMESTAMP NOT NULL,
    status VARCHAR2(20) DEFAULT 'Open' CHECK (status IN ('Open', 'Resolved', 'Closed')),
    description VARCHAR2(255),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);




BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Resolutions CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL; -- Ignore errors if table does not exist
END;
/
CREATE TABLE Resolutions (
    resolution_id NUMBER PRIMARY KEY,
    complaint_id NUMBER,
    resolution_date TIMESTAMP NOT NULL,
    resolution_details VARCHAR2(255),
    FOREIGN KEY (complaint_id) REFERENCES Complaints(complaint_id)
);