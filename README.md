# DAMG-6210_PROJECT_TEAM_19

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
1. SQL Environment: Ensure you are running following scripts using Oracle SQL Developer.
2. Database Setup: Make sure the database service is running, and you have access with the necessary privileges to create users, tables, and views.
3. SQL Files: Download all the required SQL script files from the GitHub repository (PROJECT_USER_CREATION_GRANTS.sql, Create_Table_Query_DAMG6210.sql, Create_Table_Query_2_DAMG6210.sql, PROJECT_3_views.sql, Project3_views_2.sql, Analyst.sql).
Order of Execution
Run the following SQL scripts in the specified order to set up the project database:
1. PROJECT_USER_CREATION_GRANTS.sql
o This script sets up necessary users (e.g., PROJECT_USER and ANALYST_USER) and grants appropriate permissions.
o Run (this file as admin user): Execute the script to create users and assign privileges.
2. Create_Table_Query_DAMG6210.sql
o This script creates the primary tables required for the project.
o Run: Execute this script as a PROJECT_USER to set up all foundational tables and their attributes.
3. Create_Table_Query_2_DAMG6210.sql
o This script includes additional table attributes or modifications to the tables created in the previous step.
o Run: Execute this script as a PROJECT_USER to update tables with extra attributes or constraints as required.
4. PROJECT_3_views.sql
o This script creates essential views related to the project.
o Run: Execute this script as an ANALYST USER to set up the views needed for data.
5. Project3_views_2.sql
o This script provides additional views or updates existing ones for enhanced functionality.
o Run: Execute this script as an ANALYST USER to continue to set up the views needed.
6. Analyst.sql
o In order to view the data from VIEWS created, please run the queries inside this file
Verification
After running all scripts, verify that the setup is complete:
• Check Users: Ensure the PROJECT_USER and ANALYST_USER were created successfully.
• Verify Tables: Use SELECT * FROM user_tables; ; to confirm that all tables were created.
• Confirm Views (by ANALYST_USER):
-- To list all views owned by the current user
SELECT view_name
FROM user_views;
-- To list all views accessible to the current user (including those owned by other users)
SELECT owner, view_name
FROM all_views;
 
Testing
Once everything is set up, run a few sample queries to test the data retrieval and confirm that the views and tables are functioning as expected.
