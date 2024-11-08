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
    status VARCHAR2(20),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id),
    CONSTRAINT chk_maintenance_status CHECK (status IN ('In-Progress', 'Completed'))
);


-- Clear existing data
DELETE FROM Maintenance;

-- Insert new data
INSERT INTO Maintenance (maintenance_id, vehicle_id, maintenance_date, description, status) VALUES
(1, 1, SYSTIMESTAMP - INTERVAL '30' DAY, 'Oil change and filter replacement', 'Completed'),
(2, 2, SYSTIMESTAMP - INTERVAL '25' DAY, 'Brake inspection and replacement', 'Completed'),
(3, 3, SYSTIMESTAMP - INTERVAL '20' DAY, 'Tire rotation and alignment', 'Completed'),
(4, 4, SYSTIMESTAMP - INTERVAL '15' DAY, 'Battery replacement', 'Completed'),
(5, 5, SYSTIMESTAMP - INTERVAL '10' DAY, 'Engine tune-up', 'Completed'),
(6, 6, SYSTIMESTAMP - INTERVAL '5' DAY, 'Transmission fluid change', 'In-Progress'),
(7, 7, SYSTIMESTAMP - INTERVAL '3' DAY, 'Air filter replacement', 'In-Progress'),
(8, 8, SYSTIMESTAMP - INTERVAL '1' DAY, 'Coolant system check', 'In-Progress');





BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Insurance CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL; -- Ignore errors if table does not exist
END;
/
CREATE TABLE Insurance (
    insurance_id NUMBER PRIMARY KEY,
    vehicle_id NUMBER,
    policy_number VARCHAR2(50) NOT NULL,
    provider_name VARCHAR2(100) NOT NULL,
    coverage_type VARCHAR2(50),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    premium_amount NUMBER(10, 2) NOT NULL,
    status VARCHAR2(20) CHECK (status IN ('Active', 'Expired', 'Cancelled')),
    user_id NUMBER,
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);


-- Clear existing data
DELETE FROM Insurance;

-- Insert new data
INSERT INTO Insurance (insurance_id, vehicle_id, policy_number, provider_name, coverage_type, start_date, end_date, premium_amount, status, user_id) VALUES
(1, 1, 'POL123456', 'XYZ Insurance', 'Comprehensive', SYSDATE - INTERVAL '1' YEAR, SYSDATE + INTERVAL '1' YEAR, 500.00, 'Active', 1),
(2, 2, 'POL234567', 'ABC Insurance', 'Liability', SYSDATE - INTERVAL '2' YEAR, SYSDATE - INTERVAL '1' MONTH, 300.00, 'Expired', 2),
(3, 3, 'POL345678', 'XYZ Insurance', 'Collision', SYSDATE - INTERVAL '1' YEAR, SYSDATE + INTERVAL '6' MONTH, 450.00, 'Active', 5),
(4, 4, 'POL456789', '123 Insurance', 'Comprehensive', SYSDATE - INTERVAL '6' MONTH, SYSDATE + INTERVAL '6' MONTH, 520.00, 'Active', 4),
(5, 5, 'POL567890', 'ABC Insurance', 'Comprehensive', SYSDATE - INTERVAL '1' YEAR, SYSDATE - INTERVAL '10' DAY, 400.00, 'Expired', 5),
(6, 6, 'POL678901', 'XYZ Insurance', 'Liability', SYSDATE - INTERVAL '2' MONTH, SYSDATE + INTERVAL '10' MONTH, 250.00, 'Active', 6),
(7, 7, 'POL789012', '123 Insurance', 'Collision', SYSDATE - INTERVAL '8' MONTH, SYSDATE + INTERVAL '4' MONTH, 430.00, 'Active', 7),
(8, 8, 'POL890123', 'XYZ Insurance', 'Comprehensive', SYSDATE - INTERVAL '1' YEAR, SYSDATE + INTERVAL '2' YEAR, 600.00, 'Active', 8);





BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Payments CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL; -- Ignore errors if table does not exist
END;
/
CREATE TABLE Payments (
    payment_id NUMBER PRIMARY KEY,
    user_id NUMBER NOT NULL,
    reservation_id NUMBER,  
    insurance_id NUMBER,
    amount NUMBER(10, 2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_status VARCHAR2(20) CHECK (payment_status IN ('Initiated', 'In Progress', 'Succeeded', 'Failed', 'Refunded')),
    payment_purpose VARCHAR2(20) CHECK (payment_purpose IN ('Reservation', 'Insurance')),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (reservation_id) REFERENCES Reservations(reservation_id),
    FOREIGN KEY (insurance_id) REFERENCES Insurance(insurance_id)
);




-- Clear existing data
DELETE FROM Payments;

-- Insert new data for Week-wise Sales view
INSERT INTO Payments (payment_id, user_id, reservation_id, insurance_id, amount, payment_date, payment_status, payment_purpose) VALUES
(1, 1, 1, NULL, 100.00, TIMESTAMP '2024-10-01 10:30:00', 'Succeeded', 'Reservation'),  -- Week 1
(2, 2, 2, NULL, 120.00, TIMESTAMP '2024-10-05 15:00:00', 'Succeeded', 'Reservation'),  -- Week 1
(3, 3, NULL, 3, 450.00, TIMESTAMP '2024-10-10 14:20:00', 'Succeeded', 'Insurance'),   -- Week 2
(4, 4, 4, NULL, 140.00, TIMESTAMP '2024-10-17 11:45:00', 'In Progress', 'Reservation'), -- Week 3
(5, 5, NULL, 5, 400.00, TIMESTAMP '2024-10-20 09:15:00', 'Succeeded', 'Insurance'),    -- Week 3
(6, 6, 6, NULL, 110.00, TIMESTAMP '2024-10-25 08:10:00', 'Initiated', 'Reservation'),   -- Week 4
(7, 7, NULL, 7, 430.00, TIMESTAMP '2024-10-29 16:30:00', 'Succeeded', 'Insurance');    -- Week 5





BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Authorities CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL; -- Ignore errors if table does not exist
END;
/
CREATE TABLE Authorities (
    authority_id NUMBER PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    contact_number VARCHAR2(15) NOT NULL,
    email VARCHAR2(100),
    jurisdiction_city VARCHAR2(100) NOT NULL,
    jurisdiction_state VARCHAR2(100) NOT NULL,
    jurisdiction_zip_code VARCHAR2(10)
);



-- Clear existing data
DELETE FROM Authorities;

-- Insert new data
INSERT INTO Authorities (authority_id, name, contact_number, email, jurisdiction_city, jurisdiction_state, jurisdiction_zip_code) VALUES
(1, 'Police Department', '555-1000', 'sppolice@city.gov', 'Springfield', 'IL', '62701'),
(2, 'Fire Department', '555-2000', 'spfire@city.gov', 'Springfield', 'IL', '62702'),
(3, 'Health Department', '555-3000', 'sphealth@city.gov', 'Springfield', 'IL', '62703'),
(4, 'Emergency Services', '555-4000', 'spemergency@city.gov', 'Springfield', 'IL', '62704'),
(5, 'Police Departmen', '555-5000', 'chpolice@city.gov', 'Chicago', 'IL', '62705'),
(6, 'Fire Department', '555-6000', 'chfire@city.gov', 'Chicago', 'IL', '62706'),
(7, 'Health Department', '555-7000', 'chhealth@city.gov', 'Chicago', 'IL', '62707'),
(8, 'Emergency Services', '555-8000', 'chemergency@city.gov', 'Chicago', 'IL', '62708');




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
    user_id NUMBER,
    location_id NUMBER,
    authority_id NUMBER,
    incident_time TIMESTAMP NOT NULL,
    description VARCHAR2(255),
    reported_to VARCHAR2(100),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (location_id) REFERENCES Locations(location_id),
    FOREIGN KEY (authority_id) REFERENCES Authorities(authority_id)
);


-- Clear existing data
DELETE FROM Emergency;

-- Insert new data
INSERT INTO Emergency (emergency_id, vehicle_id, user_id, location_id, authority_id, incident_time, description, reported_to) VALUES
(1, 1, 1, 1, 1, SYSTIMESTAMP - INTERVAL '20' DAY, 'Vehicle breakdown on highway', 'Police Department'),
(2, 2, 2, 2, 2, SYSTIMESTAMP - INTERVAL '15' DAY, 'Engine fire reported', 'Fire Department'),
(3, 3, 5, 3, 3, SYSTIMESTAMP - INTERVAL '10' DAY, 'Medical emergency in vehicle', 'Health Department'),
(4, 4, 4, 4, 4, SYSTIMESTAMP - INTERVAL '5' DAY, 'Major accident reported', 'Emergency Services'),
(5, 5, 5, 5, 5, SYSTIMESTAMP - INTERVAL '3' DAY, 'Traffic disruption due to breakdown', 'Transportation Department'),
(6, 6, 6, 6, 6, SYSTIMESTAMP - INTERVAL '1' DAY, 'Oil spill on road', 'Environmental Services'),
(7, 7, 7, 7, 7, SYSTIMESTAMP - INTERVAL '2' HOUR, 'Water leakage issue', 'Water Services'),
(8, 8, 8, 8, 8, SYSTIMESTAMP - INTERVAL '1' HOUR, 'Electric short circuit issue', 'Electric Services');




BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Emergency_Locations CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL; -- Ignore errors if table does not exist
END;
/
CREATE TABLE Emergency_Locations (
    emergency_id NUMBER PRIMARY KEY,
    location_id NUMBER,
    FOREIGN KEY (emergency_id) REFERENCES Emergency(emergency_id),
    FOREIGN KEY (location_id) REFERENCES Locations(location_id)
);


-- Clear existing data
DELETE FROM Emergency_Locations;

-- Insert new data
INSERT INTO Emergency_Locations (emergency_id, location_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8);





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
    emergency_id NUMBER,
    complaint_date TIMESTAMP NOT NULL,
    status VARCHAR2(20) DEFAULT 'Open' CHECK (status IN ('Open', 'Resolved', 'Closed')),
    description VARCHAR2(255),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (emergency_id) REFERENCES Emergency(emergency_id)
);


-- Clear existing data
DELETE FROM Complaints;

-- Insert new data
INSERT INTO Complaints (complaint_id, user_id, emergency_id, complaint_date, status, description) VALUES
(1, 1, 1, SYSTIMESTAMP - INTERVAL '15' DAY, 'Open', 'Complaint about emergency vehicle delay'),
(2, 2, 2, SYSTIMESTAMP - INTERVAL '12' DAY, 'Resolved', 'Complaint regarding emergency assistance quality'),
(3, 3, 3, SYSTIMESTAMP - INTERVAL '10' DAY, 'Open', 'Complaint about delay in emergency response'),
(4, 4, 4, SYSTIMESTAMP - INTERVAL '8' DAY, 'Closed', 'Complaint about insufficient emergency response information'),
(5, 5, 5, SYSTIMESTAMP - INTERVAL '5' DAY, 'Open', 'Complaint about slow emergency response time'),
(6, 6, 6, SYSTIMESTAMP - INTERVAL '3' DAY, 'Resolved', 'Complaint about lack of immediate medical support'),
(7, 7, 7, SYSTIMESTAMP - INTERVAL '1' DAY, 'Open', 'Complaint regarding delayed fire department arrival'),
(8, 8, 8, SYSTIMESTAMP - INTERVAL '2' HOUR, 'Open', 'Complaint about delayed police response at emergency location');



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
    vehicle_id NUMBER,
    resolution_date TIMESTAMP NOT NULL,
    resolution_details VARCHAR2(255),
    FOREIGN KEY (complaint_id) REFERENCES Complaints(complaint_id),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id)
);


-- Clear existing data
DELETE FROM Resolutions;

-- Insert new data
INSERT INTO Resolutions (resolution_id, complaint_id, vehicle_id, resolution_date, resolution_details) VALUES
(1, 1, 1, SYSTIMESTAMP - INTERVAL '14' DAY, 'Maintenance team has attended to the issue'),
(2, 2, 2, SYSTIMESTAMP - INTERVAL '10' DAY, 'Vehicle cleaned and sanitized'),
(3, 3, 3, SYSTIMESTAMP - INTERVAL '9' DAY, 'GPS reconfigured'),
(4, 4, 4, SYSTIMESTAMP - INTERVAL '6' DAY, 'Air conditioning repaired'),
(5, 5, 5, SYSTIMESTAMP - INTERVAL '3' DAY, 'Tire replaced'),
(6, 6, 6, SYSTIMESTAMP - INTERVAL '1' DAY, 'Fuel level sensor recalibrated');



BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Reassignments CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL; -- Ignore errors if table does not exist
END;
/
CREATE TABLE Reassignments (
    reassignment_id NUMBER PRIMARY KEY,
    reservation_id NUMBER,
    old_vehicle_id NUMBER,
    new_vehicle_id NUMBER,
    reassignment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reassignment_reason VARCHAR2(255),
    status VARCHAR2(20) DEFAULT 'Completed' CHECK (status IN ('Completed', 'Pending', 'Failed')),
    FOREIGN KEY (reservation_id) REFERENCES Reservations(reservation_id),
    FOREIGN KEY (old_vehicle_id) REFERENCES Vehicles(vehicle_id),
    FOREIGN KEY (new_vehicle_id) REFERENCES Vehicles(vehicle_id)
);


-- Clear existing data
DELETE FROM Reassignments;

-- Insert new data
INSERT INTO Reassignments (reassignment_id, reservation_id, old_vehicle_id, new_vehicle_id, reassignment_reason, status) VALUES
(1, 1, 1, 2, 'Vehicle breakdown', 'Completed'),
(2, 2, 2, 3, 'Customer preference', 'Completed'),
(3, 3, 3, 4, 'Maintenance issue', 'Pending'),
(4, 4, 4, 5, 'Vehicle upgrade', 'Completed'),
(5, 5, 5, 6, 'Vehicle unavailability', 'Failed');
