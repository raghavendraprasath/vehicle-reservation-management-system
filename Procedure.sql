--------------- Procedure for Reassigning a Vehicle ----------------

CREATE OR REPLACE PROCEDURE Reassign_Vehicle (
    p_reassignment_id IN NUMBER, -- Reassignment ID
    p_reservation_id IN NUMBER, -- Reservation ID to update
    p_old_vehicle_id IN NUMBER, -- Old vehicle ID to be marked as unavailable
    p_new_vehicle_id IN NUMBER, -- New vehicle ID to be marked as reserved
    p_reassignment_reason IN VARCHAR2 -- Reason for reassignment
) IS
BEGIN
    -- Update the status of the old vehicle
    UPDATE Vehicles
    SET status = 'Unavailable', assigned_to_reservation = 'No'
    WHERE vehicle_id = p_old_vehicle_id;

    -- Update the status of the new vehicle
    UPDATE Vehicles
    SET status = 'Reserved', assigned_to_reservation = 'Yes'
    WHERE vehicle_id = p_new_vehicle_id;

    -- Insert a new record into the Reassignments table
    INSERT INTO Reassignments (
        reassignment_id, 
        reservation_id, 
        old_vehicle_id, 
        new_vehicle_id, 
        reassignment_date, 
        reassignment_reason, 
        status
    ) VALUES (
        p_reassignment_id, 
        p_reservation_id, 
        p_old_vehicle_id, 
        p_new_vehicle_id, 
        SYSTIMESTAMP, -- Reassignment date
        p_reassignment_reason, 
        'Completed' -- Status set to 'Completed' by default
    );

    COMMIT; -- Commit the transaction
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK; -- In case of any error, rollback the changes
        RAISE; -- Raise the error for further handling if needed
END;
/

----------------------- Procedure for Adding a New Reservation --------------------

CREATE OR REPLACE PROCEDURE Add_New_Reservation (
    p_reservation_id IN NUMBER, -- Reservation ID
    p_user_id IN NUMBER,        -- User ID who is making the reservation
    p_vehicle_id IN NUMBER,     -- Vehicle ID to be reserved
    p_start_time IN TIMESTAMP,  -- Start time of the reservation
    p_end_time IN TIMESTAMP,    -- End time of the reservation
    p_location_id IN NUMBER,    -- Location ID where the vehicle will be picked up
    p_status IN VARCHAR2        -- Status of the reservation (e.g., Confirmed, Pending)
) IS
    v_reassignment_exists NUMBER; -- Variable to hold the result of the reassignment check
BEGIN
    -- Step 1: Validate the vehicle's availability
    UPDATE Vehicles
    SET status = 'Reserved',
        assigned_to_reservation = 'Yes',
        last_reserved_date = SYSTIMESTAMP -- Track when the vehicle was reserved
    WHERE vehicle_id = p_vehicle_id
      AND status = 'Available'; -- Only allow available vehicles to be reserved

    -- Check if the update was successful (i.e., the vehicle was available)
    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Vehicle is not available for reservation.');
    END IF;

    -- Step 2: Insert the new reservation
    INSERT INTO Reservations (
        reservation_id, 
        user_id, 
        vehicle_id, 
        start_time, 
        end_time, 
        location_id, 
        status
    ) VALUES (
        p_reservation_id, 
        p_user_id, 
        p_vehicle_id, 
        p_start_time, 
        p_end_time, 
        p_location_id, 
        p_status
    );

    -- Step 3: Record the reassignment if the vehicle was reassigned (optional logic)
    -- Check if there's a pending reassignment for the vehicle
    SELECT COUNT(*) INTO v_reassignment_exists
    FROM Reassignments
    WHERE new_vehicle_id = p_vehicle_id
      AND status = 'Pending';

    IF v_reassignment_exists > 0 THEN
        UPDATE Reassignments
        SET status = 'Completed',
            reassignment_date = SYSTIMESTAMP
        WHERE new_vehicle_id = p_vehicle_id
          AND status = 'Pending';
    END IF;

    -- Commit the transaction
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK; -- Rollback the transaction on any error
        RAISE; -- Re-raise the error for debugging
END;
/
