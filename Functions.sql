--------------- Function to Calculate Reservation Revenue -----------------------

CREATE OR REPLACE FUNCTION Calculate_Reservation_Revenue (
    p_reservation_id IN NUMBER
) RETURN NUMBER
IS
    v_price_per_hour NUMBER(10, 2);
    v_start_time TIMESTAMP;
    v_end_time TIMESTAMP;
    v_duration_in_hours NUMBER;
    v_total_revenue NUMBER;
BEGIN
    -- Step 1: Retrieve the reservation details and vehicle price per hour
    SELECT r.start_time, r.end_time, v.price_per_hour
    INTO v_start_time, v_end_time, v_price_per_hour
    FROM Reservations r
    JOIN Vehicles v ON r.vehicle_id = v.vehicle_id
    WHERE r.reservation_id = p_reservation_id;

    -- Step 2: Calculate the reservation duration in hours
    v_duration_in_hours := EXTRACT(DAY FROM (v_end_time - v_start_time)) * 24
                           + EXTRACT(HOUR FROM (v_end_time - v_start_time))
                           + (EXTRACT(MINUTE FROM (v_end_time - v_start_time)) / 60);

    -- Step 3: Calculate the total revenue
    v_total_revenue := v_price_per_hour * v_duration_in_hours;

    -- Step 4: Return the total revenue
    RETURN ROUND(v_total_revenue, 2);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'Reservation ID not found.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20003, 'An error occurred while calculating revenue.');
END;
/


-------------------- Function to Check Vehicle Availability -------------------------

CREATE OR REPLACE FUNCTION Check_Vehicle_Availability (
    p_vehicle_id IN NUMBER,
    p_start_time IN TIMESTAMP,
    p_end_time IN TIMESTAMP
) RETURN VARCHAR2
IS
    v_count NUMBER;
BEGIN
    -- Step 1: Check for overlapping reservations
    SELECT COUNT(*)
    INTO v_count
    FROM Reservations
    WHERE vehicle_id = p_vehicle_id
      AND status IN ('Confirmed', 'Pending') -- Only consider active reservations
      AND (
            (p_start_time BETWEEN start_time AND end_time) OR
            (p_end_time BETWEEN start_time AND end_time) OR
            (p_start_time <= start_time AND p_end_time >= end_time)
          );

    -- Step 2: Determine availability
    IF v_count > 0 THEN
        RETURN 'Unavailable';
    ELSE
        RETURN 'Available';
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Available'; -- If no reservations are found
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20004, 'An error occurred while checking availability.');
END;
/
