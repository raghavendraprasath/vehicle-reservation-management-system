----------------------------------  Trigger   ---------------------------------------------

CREATE OR REPLACE TRIGGER Update_Vehicle_Status_On_Reassignment
AFTER INSERT ON Reassignments
FOR EACH ROW
BEGIN
    -- Update the status of the old vehicle to 'Available'
    UPDATE Vehicles
    SET status = 'Available',
        assigned_to_reservation = 'No'
    WHERE vehicle_id = :NEW.old_vehicle_id;

    -- Update the status of the new vehicle to 'Reserved'
    UPDATE Vehicles
    SET status = 'Reserved',
        assigned_to_reservation = 'Yes'
    WHERE vehicle_id = :NEW.new_vehicle_id;
END;
/
