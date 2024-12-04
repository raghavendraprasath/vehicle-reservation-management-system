-----------------------------  Packages  ---------------------------------------


--------- Vehicle Management -----------------

-- Declaring the procedure and functions for vehcile management

CREATE OR REPLACE PACKAGE Vehicle_Management AS
    -- Procedure to Add a New Vehicle
    PROCEDURE Add_Vehicle (
        p_make VARCHAR2,
        p_model VARCHAR2,
        p_year NUMBER,
        p_price_per_hour NUMBER,
        p_location_id NUMBER
    );

    -- Procedure to Update Vehicle Information
    PROCEDURE Update_Vehicle_Info (
        p_vehicle_id NUMBER,
        p_make VARCHAR2,
        p_model VARCHAR2,
        p_year NUMBER,
        p_price_per_hour NUMBER,
        p_location_id NUMBER
    );

    -- Procedure to Update Vehicle Status
    PROCEDURE Update_Vehicle_Status (
        p_vehicle_id NUMBER,
        p_new_status VARCHAR2
    );

    -- Function to Check Vehicle Availability
    FUNCTION Check_Vehicle_Availability (
        p_vehicle_id IN NUMBER,
        p_start_time IN TIMESTAMP,
        p_end_time IN TIMESTAMP
    ) RETURN VARCHAR2;
    
    -- Function to Calculate Total Revenue for a Vehicle
    FUNCTION Calculate_Vehicle_Revenue (
        p_vehicle_id IN NUMBER
    ) RETURN NUMBER;
END Vehicle_Management;
/




-- Implementation of procedure and fucntions

CREATE OR REPLACE PACKAGE BODY Vehicle_Management AS
    -- Procedure to Add a New Vehicle
    PROCEDURE Add_Vehicle (
        p_make VARCHAR2,
        p_model VARCHAR2,
        p_year NUMBER,
        p_price_per_hour NUMBER,
        p_location_id NUMBER
    ) IS
        v_new_vehicle_id NUMBER;
    BEGIN
        -- Generate the next vehicle ID based on the current maximum vehicle_id
        SELECT NVL(MAX(vehicle_id), 0) + 1 INTO v_new_vehicle_id
        FROM Vehicles;

        -- Insert the new vehicle into the Vehicles table
        INSERT INTO Vehicles (
            vehicle_id, make, model, year, price_per_hour, location_id, status
        ) VALUES (
            v_new_vehicle_id, p_make, p_model, p_year, p_price_per_hour, p_location_id, 'Available'
        );

        DBMS_OUTPUT.PUT_LINE('New vehicle added successfully with ID ' || v_new_vehicle_id);
    END Add_Vehicle;

    -- Procedure to Update Vehicle Information
    PROCEDURE Update_Vehicle_Info (
        p_vehicle_id NUMBER,
        p_make VARCHAR2,
        p_model VARCHAR2,
        p_year NUMBER,
        p_price_per_hour NUMBER,
        p_location_id NUMBER
    ) IS
    BEGIN
        -- Update the vehicle information in the Vehicles table
        UPDATE Vehicles
        SET make = p_make,
            model = p_model,
            year = p_year,
            price_per_hour = p_price_per_hour,
            location_id = p_location_id
        WHERE vehicle_id = p_vehicle_id;

        DBMS_OUTPUT.PUT_LINE('Vehicle information updated successfully.');
    END Update_Vehicle_Info;

    -- Procedure to Update Vehicle Status
    PROCEDURE Update_Vehicle_Status (
        p_vehicle_id NUMBER,
        p_new_status VARCHAR2
    ) IS
    BEGIN
        -- Update the vehicle status (e.g., Available, Reserved, In Maintenance)
        UPDATE Vehicles
        SET status = p_new_status
        WHERE vehicle_id = p_vehicle_id;

        DBMS_OUTPUT.PUT_LINE('Vehicle status updated to ' || p_new_status);
    END Update_Vehicle_Status;

    -- Function to Check Vehicle Availability
    FUNCTION Check_Vehicle_Availability (
        p_vehicle_id IN NUMBER,
        p_start_time IN TIMESTAMP,
        p_end_time IN TIMESTAMP
    ) RETURN VARCHAR2 IS
        v_conflict_count NUMBER;
    BEGIN
        -- Check if the vehicle is available during the specified time period
        SELECT COUNT(*)
        INTO v_conflict_count
        FROM Reservations
        WHERE vehicle_id = p_vehicle_id
          AND status IN ('Confirmed', 'Pending')
          AND (
                (p_start_time BETWEEN start_time AND end_time) OR
                (p_end_time BETWEEN start_time AND end_time) OR
                (p_start_time <= start_time AND p_end_time >= end_time)
              );

        IF v_conflict_count > 0 THEN
            RETURN 'Unavailable';
        ELSE
            RETURN 'Available';
        END IF;
    END Check_Vehicle_Availability;

    -- Function to Calculate Total Revenue for a Vehicle
    FUNCTION Calculate_Vehicle_Revenue (
        p_vehicle_id IN NUMBER
    ) RETURN NUMBER IS
        v_revenue NUMBER := 0;
        v_price_per_hour NUMBER(10, 2);
        v_duration_in_hours NUMBER(10, 2);
    BEGIN
        -- Fetch the price per hour for the vehicle
        SELECT price_per_hour
        INTO v_price_per_hour
        FROM Vehicles
        WHERE vehicle_id = p_vehicle_id;

        -- Calculate the total revenue from all reservations for the vehicle
        FOR r IN (
            SELECT r.start_time, r.end_time
            FROM Reservations r
            WHERE r.vehicle_id = p_vehicle_id AND r.status = 'Completed'
        ) LOOP
            -- Calculate the duration of the reservation in hours
            v_duration_in_hours := (EXTRACT(DAY FROM (r.end_time - r.start_time)) * 24 +
                                    EXTRACT(HOUR FROM (r.end_time - r.start_time))) ;
            -- Accumulate the revenue for each completed reservation
            v_revenue := v_revenue + (v_duration_in_hours * v_price_per_hour);
        END LOOP;

        RETURN v_revenue;
    END Calculate_Vehicle_Revenue;

END Vehicle_Management;
/


---------------- Reservation Management -----------------------

-- Declaring the procedure and fucntions

CREATE OR REPLACE PACKAGE Reservation_Management AS
    -- Procedure to Create a New Reservation
    PROCEDURE Create_Reservation (
        p_user_id NUMBER,
        p_vehicle_id NUMBER,
        p_start_time TIMESTAMP,
        p_end_time TIMESTAMP,
        p_location_id NUMBER
    );

    -- Procedure to Update Reservation Status
    PROCEDURE Update_Reservation_Status (
        p_reservation_id NUMBER,
        p_new_status VARCHAR2
    );

    -- Function to Calculate Revenue for a Reservation
    FUNCTION Calculate_Reservation_Revenue (
        p_reservation_id NUMBER
    ) RETURN NUMBER;

    -- Function to Check Conflicts for Reservation Timing
    FUNCTION Check_Reservation_Conflict (
        p_vehicle_id IN NUMBER,
        p_start_time IN TIMESTAMP,
        p_end_time IN TIMESTAMP
    ) RETURN VARCHAR2;
END Reservation_Management;
/


-- Implementation of procedure and functions

CREATE OR REPLACE PACKAGE BODY Reservation_Management AS
    -- Procedure to Create a New Reservation
  PROCEDURE Create_Reservation (
    p_user_id NUMBER,
    p_vehicle_id NUMBER,
    p_start_time TIMESTAMP,
    p_end_time TIMESTAMP,
    p_location_id NUMBER
) IS
    v_conflict_status VARCHAR2(20);
    v_new_reservation_id NUMBER;
BEGIN
    -- Check if the vehicle is available
    v_conflict_status := Check_Reservation_Conflict(p_vehicle_id, p_start_time, p_end_time);

    IF v_conflict_status = 'Unavailable' THEN
        RAISE_APPLICATION_ERROR(-20002, 'The vehicle is not available for the selected time range.');
    END IF;

    -- Generate the next reservation ID
    SELECT NVL(MAX(reservation_id), 0) + 1 INTO v_new_reservation_id
    FROM Reservations;

    -- Insert the new reservation
    INSERT INTO Reservations (
        reservation_id, user_id, vehicle_id, start_time, end_time, location_id, status
    ) VALUES (
        v_new_reservation_id, p_user_id, p_vehicle_id, p_start_time, p_end_time, p_location_id, 'Confirmed'
    );

    -- Update the vehicle status
    UPDATE Vehicles
    SET status = 'Reserved', assigned_to_reservation = 'Yes'
    WHERE vehicle_id = p_vehicle_id;

    DBMS_OUTPUT.PUT_LINE('Reservation created successfully.');
END Create_Reservation;


    -- Procedure to Update Reservation Status
    PROCEDURE Update_Reservation_Status (
        p_reservation_id NUMBER,
        p_new_status VARCHAR2
    ) IS
        v_vehicle_id NUMBER;
    BEGIN
        -- Get the vehicle ID associated with the reservation
        SELECT vehicle_id INTO v_vehicle_id
        FROM Reservations
        WHERE reservation_id = p_reservation_id;

        -- Update the reservation status
        UPDATE Reservations
        SET status = p_new_status
        WHERE reservation_id = p_reservation_id;

        IF p_new_status IN ('Cancelled', 'Completed') THEN
            -- Update the vehicle status if necessary
            UPDATE Vehicles
            SET status = 'Available', assigned_to_reservation = 'No'
            WHERE vehicle_id = v_vehicle_id;
        END IF;

        DBMS_OUTPUT.PUT_LINE('Reservation status updated successfully.');
    END Update_Reservation_Status;

    -- Function to Calculate Revenue for a Reservation
    FUNCTION Calculate_Reservation_Revenue (
        p_reservation_id NUMBER
    ) RETURN NUMBER IS
        v_revenue NUMBER;
        v_price_per_hour NUMBER(10, 2);
        v_duration_in_hours NUMBER(10, 2);
    BEGIN
        -- Fetch the hourly price and duration of the reservation
        SELECT v.price_per_hour,
               (EXTRACT(DAY FROM (r.end_time - r.start_time)) * 24 +
                EXTRACT(HOUR FROM (r.end_time - r.start_time))) AS duration_in_hours
        INTO v_price_per_hour, v_duration_in_hours
        FROM Reservations r
        JOIN Vehicles v ON r.vehicle_id = v.vehicle_id
        WHERE r.reservation_id = p_reservation_id;

        -- Calculate the revenue
        v_revenue := v_price_per_hour * v_duration_in_hours;

        RETURN v_revenue;
    END Calculate_Reservation_Revenue;

    -- Function to Check Conflicts for Reservation Timing
    FUNCTION Check_Reservation_Conflict (
        p_vehicle_id IN NUMBER,
        p_start_time IN TIMESTAMP,
        p_end_time IN TIMESTAMP
    ) RETURN VARCHAR2 IS
        v_conflict_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_conflict_count
        FROM Reservations
        WHERE vehicle_id = p_vehicle_id
          AND status IN ('Confirmed', 'Pending')
          AND (
                (p_start_time BETWEEN start_time AND end_time) OR
                (p_end_time BETWEEN start_time AND end_time) OR
                (p_start_time <= start_time AND p_end_time >= end_time)
              );

        IF v_conflict_count > 0 THEN
            RETURN 'Unavailable';
        ELSE
            RETURN 'Available';
        END IF;
    END Check_Reservation_Conflict;
END Reservation_Management;
/
