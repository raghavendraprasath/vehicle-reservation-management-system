
----------------------- To view the data of the VIEWS Created please run these queries ------------------------

SELECT * FROM PROJECT_USER.Current_Inventory_Status;

SELECT * FROM PROJECT_USER.Reservation_Revenue_Analysis;

SELECT * FROM PROJECT_USER.Most_Popular_Vehicles;

SELECT * FROM PROJECT_USER.Customer_Complaints;

SELECT * FROM PROJECT_USER.Week_wise_Sales;

SELECT * FROM PROJECT_USER.Total_Sales_by_Region;

SELECT * FROM PROJECT_USER.Product_wise_Price_Changes;


-------------------------- Stored Procedure Use cases -------------------------

-- Procedure for Reassigning a Vehicle
-- Adds New Reservation
BEGIN
    Reassign_Vehicle(
        p_reassignment_id => 1001, -- Unique reassignment ID
        p_reservation_id => 5,     -- Reservation ID
        p_old_vehicle_id => 1,     -- Old Vehicle ID
        p_new_vehicle_id => 3,     -- New Vehicle ID
        p_reassignment_reason => 'Customer requested a different vehicle' -- Reason for reassignment
    );
END;
/


-- Procedure for Adding a New Reservation
-- Calculate revenue for reservation ID 1
DECLARE
    revenue NUMBER;
BEGIN
    revenue := Calculate_Reservation_Revenue(1);
    DBMS_OUTPUT.PUT_LINE('Total Revenue for Reservation 1: ' || revenue);
END;
/



------------------------ Functions Use Cases -------------------------------

-- Function to Calculate Reservation Revenue
-- Calculate revenue for reservation ID 1
DECLARE
    revenue NUMBER;
BEGIN
    revenue := Calculate_Reservation_Revenue(1);
    DBMS_OUTPUT.PUT_LINE('Total Revenue for Reservation 1: ' || revenue);
END;
/



-- Function to Check Vehicle Availability
-- Check Availability
DECLARE
    availability_status VARCHAR2(20);
BEGIN
    availability_status := Check_Vehicle_Availability(1, SYSTIMESTAMP + INTERVAL '1' DAY, SYSTIMESTAMP + INTERVAL '2' DAY);
    DBMS_OUTPUT.PUT_LINE('Vehicle Availability: ' || availability_status);
END;
/

---------------------------------- Packages ----------------------------------

----------- Vehicle Management -----------
-- Add a New Vehicle
BEGIN
    Vehicle_Management.Add_New_Vehicle(
        'Tesla', 'Model 3', 2023, 1, 25.00, 40000, -122.4194, 37.7749
    );
END;
/

-- Update Vehicle Status

BEGIN
    Vehicle_Management.Update_Vehicle_Status(1, 'Reserved');
END;
/

-- Check Vehicle Availability
DECLARE
    availability_status VARCHAR2(20);
BEGIN
    availability_status := Vehicle_Management.Check_Vehicle_Availability(1, SYSTIMESTAMP + INTERVAL '1' DAY, SYSTIMESTAMP + INTERVAL '2' DAY);
    DBMS_OUTPUT.PUT_LINE('Vehicle Availability: ' || availability_status);
END;
/

-- Calculate Vehicle Revenue
DECLARE
    total_revenue NUMBER;
BEGIN
    total_revenue := Vehicle_Management.Calculate_Vehicle_Revenue(1);
    DBMS_OUTPUT.PUT_LINE('Total Revenue: ' || total_revenue);
END;
/


----------- Reservation Management ------------

-- Create a New Reservation

BEGIN
    Reservation_Management.Create_Reservation(
        1, -- user_id
        1, -- vehicle_id
        SYSTIMESTAMP + INTERVAL '1' DAY, -- start_time
        SYSTIMESTAMP + INTERVAL '2' DAY, -- end_time
        1  -- location_id
    );
END;
/

-- Update Reservation Status
BEGIN
    Reservation_Management.Update_Reservation_Status(1, 'Completed');
END;
/

-- Calculate Reservation Revenue
DECLARE
    total_revenue NUMBER;
BEGIN
    total_revenue := Reservation_Management.Calculate_Reservation_Revenue(1);
    DBMS_OUTPUT.PUT_LINE('Reservation Revenue: ' || total_revenue);
END;
/

-- Check Reservation Conflict
DECLARE
    availability_status VARCHAR2(20);
BEGIN
    availability_status := Reservation_Management.Check_Reservation_Conflict(1, SYSTIMESTAMP + INTERVAL '1' DAY, SYSTIMESTAMP + INTERVAL '2' DAY);
    DBMS_OUTPUT.PUT_LINE('Reservation Conflict Status: ' || availability_status);
END;
/



----------------------  Report  -----------------------------





-- 1. Vehicle Availability Report
PROMPT ===============================
PROMPT Vehicle Availability Report
PROMPT ===============================
SELECT 
    vehicle_id, make, model, status, assigned_to_reservation, location_id
FROM 
    PROJECT_USER.Vehicles
WHERE 
    status = 'Available';

-- 2. Reservation Status Report
PROMPT ===============================
PROMPT Reservation Status Report
PROMPT ===============================
SELECT 
    reservation_id, user_id, vehicle_id, start_time, end_time, status
FROM 
    PROJECT_USER.Reservations
ORDER BY 
    start_time;

-- 3. Vehicles Assigned to Reservations Report
PROMPT ===============================
PROMPT Vehicles Assigned to Reservations Report
PROMPT ===============================
SELECT 
    v.vehicle_id, v.make, v.model, v.status, r.reservation_id, r.user_id, r.status AS reservation_status
FROM 
    PROJECT_USER.Vehicles v
JOIN 
    PROJECT_USER.Reservations r ON v.vehicle_id = r.vehicle_id
WHERE 
    v.assigned_to_reservation = 'Yes'
ORDER BY 
    r.start_time;

-- 4. Vehicle Utilization Report
PROMPT ===============================
PROMPT Vehicle Utilization Report
PROMPT ===============================
SELECT 
    v.vehicle_id, 
    v.make, 
    v.model, 
    COUNT(r.reservation_id) AS total_reservations,
    SUM(CASE WHEN r.status IN ('Completed', 'Confirmed', 'Pending') THEN 1 ELSE 0 END) AS active_reservations
FROM 
    PROJECT_USER.Vehicles v
LEFT JOIN 
    PROJECT_USER.Reservations r ON v.vehicle_id = r.vehicle_id
GROUP BY 
    v.vehicle_id, v.make, v.model
ORDER BY 
    total_reservations DESC;

-- 5. Location-Based Vehicle Availability Report
PROMPT ===============================
PROMPT Location-Based Vehicle Availability Report
PROMPT ===============================
SELECT 
    location_id, 
    COUNT(vehicle_id) AS total_vehicles,
    SUM(CASE WHEN status = 'Available' THEN 1 ELSE 0 END) AS available_vehicles
FROM 
    PROJECT_USER.Vehicles
GROUP BY 
    location_id;
