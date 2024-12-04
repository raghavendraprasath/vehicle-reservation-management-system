----------------------  Report  -----------------------------


-- These reports are also present under the 'User Defined Reports' section under 'Reports' pane of Oracle SQL Developer
-- To view these reports in report view, Right Click on 'User Defined Reports' and select 'Open Report' 
-- 5 Separate XML files are present in repository, which can be opened to view


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
   
