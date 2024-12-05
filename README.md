Instruction Sheet for Running SQL Project Scripts
Project Title: Zipcar Vehicle Rental Management System
Project – Group 19
1. Nikhil Pandey – 002775062
2. Raghavendra Prasath Sridhar – 0023112779
3. Rohan Manish Jauhari – 002324427
4. Hardi Manish Shah – 002301430

In order to access the project please open the GitHub repository in the following link:
https://github.com/rohanjauhari1312/DAMG-6210_PROJECT_TEAM_19

** IF ANY I/O OR CONNECTION ERROR PLEASE TRY TO CONNECT TO THE SESSION OF THE PARTICULAR USER AND RERUN THE SCRIPTS **

Prerequisites
1.	SQL Environment: Ensure you are running following scripts using Oracle SQL Developer.
2.	Database Setup: Make sure the database service is running, and you have access with the necessary privileges to create users, tables, views and execute scripts.
3.	SQL Files: Download all the required SQL script files from the GitHub repository

Order of Execution

Run the following SQL scripts in the specified order to set up the project database:

1.	PROJECT_USER_CREATION_GRANTS.sql
o	This script sets up necessary users (e.g., PROJECT_USER and ANALYST_USER) and grants appropriate permissions.
o	Run (this file as system admin): Execute the script to create users and assign privileges.
2.	Create_Table_Query_DAMG6210.sql
o	This script creates the primary tables required for the project.
o	Run: Execute this script as a PROJECT_USER to set up all foundational tables and their attributes.
3.	Create_Table_Query_2_DAMG6210.sql
o	This script includes additional table attributes or modifications to the tables created in the previous step.
o	Run: Execute this script as a PROJECT_USER to update tables with extra attributes or constraints as required.
4.	PROJECT_3_views.sql
o	This script creates essential views related to the project.
o	Run: Execute this script as an PROJECT_USER to set up the views needed for data.
5.	Project3_views_2.sql
o	This script provides additional views or updates existing ones for enhanced functionality.
o	Run: Execute this script as an PROJECT_USER to continue to set up the views needed.
6.	Trigger.sql
o	Contains triggers like Update_Vehicle_Status_On_Reassignment 
o	Run: Execute this script as a PROJECT_USER
7.	Procedure.sql
o	Contains stored procedures for updating reservation statuses and vehicle assignments.
o	Run: Execute this script as a PROJECT_USER
8.	Functions.sql
o	Implements functions like Calculate_Reservation_Revenue and Check_Vehicle_Availability.
o	Run: Execute this script as a PROJECT_USER
9.	Packages.sql
o	Manages the Vehicle_Management and Reservation_Management packages.
o	Run: Execute this script as a PROJECT_USER
10.	Reports.sql (5 XML files are also present in repository for User Defined Report view)
Contains queries for generating reports:
o	Vehicle Availability Report
o	Reservation Status Report
o	Vehicles Assigned to Reservations Report
o	Vehicle Utilization Report
o	Location-Based Vehicle Availability Report
O Run: Execute this script as a PROJECT_USER & ANALYST_USER
-- These reports are also present under the 'User Defined Reports' section under 'Reports' pane of Oracle SQL Developer
-- To view these reports in report view, Right Click on 'User Defined Reports' and select 'Open Report' 
-- 5 Separate XML files are present in repository, which can be opened to view
11.	Analyst.sql
o	In order to run the use cases of functions, stored procedures, packages, reports, view the data from VIEWS created, please run the queries inside this file
o	Run: Execute this script as an ANALYST_USER
Verification
After running all scripts, verify that the setup is complete:
•	Check Users: Ensure the PROJECT_USER and ANALYST_USER were created successfully.
SELECT username FROM all_users WHERE username IN ('PROJECT_USER', 'ANALYST_USER');
•	Verify Tables: Use SELECT * FROM user_tables; ; to confirm that all tables were created.
SELECT table_name FROM user_tables WHERE table_name IS NOT NULL;
•	Confirm Views (by ANALYST_USER): 
-- To list all views owned by the current user
SELECT view_name
FROM user_views;
-- To list all views accessible to the current user (including those owned by other users)
SELECT owner, view_name
FROM all_views;

Testing
Once everything is set up, run a few sample queries to test the data retrieval and confirm that the views and tables are functioning as expected.


Important Notes:
No ORA Errors: Ensure that no ORA errors are encountered during script execution. The scripts should run without any issues.
Idempotent Scripts: The scripts are designed to be idempotent. They will drop existing objects if they exist and recreate them without causing errors.
Reports: The repository contains XML files for reports, which can be opened in Oracle SQL Developer under the "User Defined Reports" section.
COMMIT & ROLLBACK: Make sure to use COMMIT where necessary, and ROLLBACK on errors if indicated.
