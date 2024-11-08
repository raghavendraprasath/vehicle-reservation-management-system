-- View for Customer Complaints
CREATE OR REPLACE VIEW Customer_Complaints AS
SELECT 
    c.complaint_id,
    u.user_id,
    u.first_name,
    u.last_name,
    c.complaint_date,
    c.status,
    c.description,
    r.resolution_date
FROM 
    Complaints c
JOIN 
    Users u ON c.user_id = u.user_id
LEFT JOIN 
    Resolutions r ON c.complaint_id = r.complaint_id;


-- View for Week-wise Sales
CREATE OR REPLACE VIEW Week_wise_Sales AS
SELECT 
    TRUNC(payment_date, 'IW') AS week_start,
    SUM(amount) AS total_sales
FROM 
    Payments
GROUP BY 
    TRUNC(payment_date, 'IW')
ORDER BY 
    week_start;


-- View for Total Sales by Region
CREATE OR REPLACE VIEW Total_Sales_by_Region AS
SELECT 
    l.city,
    SUM(p.amount) AS total_sales
FROM 
    Payments p
JOIN 
    Reservations r ON p.reservation_id = r.reservation_id
JOIN 
    Locations l ON r.location_id = l.location_id
GROUP BY 
    l.city;


-- View for Product-wise Price Changes
CREATE OR REPLACE VIEW Product_wise_Price_Changes AS
SELECT 
    v.vehicle_id,
    v.make,
    v.model,
    p.old_price,
    p.new_price,
    TO_CHAR(p.change_date, 'DD-MON-YY HH24:MI:SS') AS formatted_change_date
FROM 
    Vehicle_Price_Changes p
JOIN 
    Vehicles v ON p.vehicle_id = v.vehicle_id;

-- granting select privilege access to analyst user

BEGIN
    FOR view_record IN (SELECT view_name FROM all_views WHERE owner = 'PROJECT_USER') LOOP
        EXECUTE IMMEDIATE 'GRANT SELECT ON PROJECT_USER.' || view_record.view_name || ' TO ANALYST_USER';
    END LOOP;
END;
/
