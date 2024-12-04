--------------------------------- Project User ---------------------------------------

DECLARE
    user_count NUMBER;
    session_count NUMBER;
BEGIN
    -- Check if the user exists
    SELECT COUNT(*) INTO user_count FROM all_users WHERE username = 'PROJECT_USER';

    IF user_count > 0 THEN
        -- Loop through all sessions of the user and kill them
        FOR rec IN (SELECT sid, serial# FROM v$session WHERE username = 'PROJECT_USER') LOOP
            BEGIN
                EXECUTE IMMEDIATE 'ALTER SYSTEM KILL SESSION ''' || rec.sid || ',' || rec.serial# || ''' IMMEDIATE';
            EXCEPTION
                WHEN OTHERS THEN
                    NULL; -- Ignore errors if session cannot be killed
            END;
        END LOOP;

        -- Wait for a few moments to ensure that the user is fully logged off and the session is killed
        FOR i IN 1..5 LOOP
            SELECT COUNT(*) INTO session_count FROM v$session WHERE username = 'PROJECT_USER';
            IF session_count = 0 THEN
                EXIT;
            ELSE
                DBMS_LOCK.sleep(10);  -- Sleep for 10 seconds before retrying
            END IF;
        END LOOP;

        -- If no active sessions, drop the user
        IF session_count = 0 THEN
            EXECUTE IMMEDIATE 'DROP USER PROJECT_USER CASCADE';
        ELSE
            DBMS_OUTPUT.PUT_LINE('User still has active sessions. Cannot drop user.');
        END IF;
    END IF;

    -- Create the user if it doesn't exist
    EXECUTE IMMEDIATE 'CREATE USER PROJECT_USER IDENTIFIED BY Sasapnilgneu07#';
END;
/
BEGIN
    -- Grant CONNECT, RESOURCE, and UNLIMITED TABLESPACE privileges to the user
    EXECUTE IMMEDIATE 'GRANT CONNECT, RESOURCE, UNLIMITED TABLESPACE TO PROJECT_USER';

    -- Grant ALTER ANY TABLE privilege to the user to allow ALTER operations on all tables
    EXECUTE IMMEDIATE 'GRANT ALTER ANY TABLE TO PROJECT_USER';

    -- Grant SELECT ON VIEWS to PROJECT_USER with GRANT OPTION to allow granting SELECT on views to others
    FOR view_record IN (SELECT view_name FROM all_views WHERE owner = 'PROJECT_USER') LOOP
        EXECUTE IMMEDIATE 'GRANT SELECT ON PROJECT_USER.' || view_record.view_name || ' TO PROJECT_USER WITH GRANT OPTION';
    END LOOP;

    -- Grant EXECUTE ANY PROCEDURE privilege to the user
    EXECUTE IMMEDIATE 'GRANT EXECUTE ANY PROCEDURE TO PROJECT_USER';

    -- Grant CREATE TRIGGER privilege to the user
    EXECUTE IMMEDIATE 'GRANT CREATE TRIGGER TO PROJECT_USER';

    -- Grant ADMINISTER DATABASE TRIGGER privilege to the user
    EXECUTE IMMEDIATE 'GRANT ADMINISTER DATABASE TRIGGER TO PROJECT_USER';

    -- Grant CREATE ANY VIEW privilege to the user
    EXECUTE IMMEDIATE 'GRANT CREATE ANY VIEW TO PROJECT_USER';

    -- Grant CREATE ANY PROCEDURE privilege to the user
    EXECUTE IMMEDIATE 'GRANT CREATE ANY PROCEDURE TO PROJECT_USER';

    -- Grant CREATE SYNONYM privilege to the user
    EXECUTE IMMEDIATE 'GRANT CREATE SYNONYM TO PROJECT_USER';

    -- Grant DROP ANY VIEW privilege to the user
    EXECUTE IMMEDIATE 'GRANT DROP ANY VIEW TO PROJECT_USER';

    -- Grant CREATE ANY INDEX privilege to the user
    EXECUTE IMMEDIATE 'GRANT CREATE ANY INDEX TO PROJECT_USER';

    -- Grant ALTER ANY INDEX privilege to the user
    EXECUTE IMMEDIATE 'GRANT ALTER ANY INDEX TO PROJECT_USER';
    
    EXECUTE IMMEDIATE 'CREATE OR REPLACE DIRECTORY reports_dir AS ''/Users/nikhilpandey/Desktop''';
    
    EXECUTE IMMEDIATE 'GRANT READ, WRITE ON DIRECTORY reports_dir TO project_user';



EXCEPTION
    WHEN OTHERS THEN
        NULL; -- Ignore if grants already exist
END;
/





--------------------------------- Analyst User ---------------------------------------

DECLARE
    user_count NUMBER;
    session_count NUMBER;
BEGIN
    -- Check if the user exists
    SELECT COUNT(*) INTO user_count FROM all_users WHERE username = 'ANALYST_USER';

    IF user_count > 0 THEN
        -- Loop through all sessions of the user and kill them
        FOR rec IN (SELECT sid, serial# FROM v$session WHERE username = 'ANALYST_USER') LOOP
            BEGIN
                EXECUTE IMMEDIATE 'ALTER SYSTEM KILL SESSION ''' || rec.sid || ',' || rec.serial# || ''' IMMEDIATE';
            EXCEPTION
                WHEN OTHERS THEN
                    NULL; -- Ignore errors if session cannot be killed
            END;
        END LOOP;

        -- Wait for a few moments to ensure that the user is fully logged off and the session is killed
        FOR i IN 1..5 LOOP
            SELECT COUNT(*) INTO session_count FROM v$session WHERE username = 'ANALYST_USER';
            IF session_count = 0 THEN
                EXIT;
            ELSE
                DBMS_LOCK.sleep(10);  -- Sleep for 10 seconds before retrying
            END IF;
        END LOOP;

        -- If no active sessions, drop the user
        IF session_count = 0 THEN
            EXECUTE IMMEDIATE 'DROP USER ANALYST_USER CASCADE';
        ELSE
            DBMS_OUTPUT.PUT_LINE('User still has active sessions. Cannot drop user.');
        END IF;
    END IF;

    -- Create the user if it doesn't exist
    EXECUTE IMMEDIATE 'CREATE USER ANALYST_USER IDENTIFIED BY Analystuser07#';
END;
/

BEGIN
    -- Grant basic connection privileges
    EXECUTE IMMEDIATE 'GRANT CONNECT, CREATE SESSION TO ANALYST_USER';

    -- Grant SELECT privileges on all relevant views in the PROJECT_USER schema
    FOR view_record IN (SELECT view_name FROM all_views WHERE owner = 'PROJECT_USER') LOOP
        EXECUTE IMMEDIATE 'GRANT SELECT ON PROJECT_USER.' || view_record.view_name || ' TO ANALYST_USER';
    END LOOP;

    -- Grant SELECT privileges on all tables in the PROJECT_USER schema
    FOR table_record IN (SELECT table_name FROM all_tables WHERE owner = 'PROJECT_USER') LOOP
        EXECUTE IMMEDIATE 'GRANT SELECT ON PROJECT_USER.' || table_record.table_name || ' TO ANALYST_USER';
    END LOOP;

    -- Grant EXECUTE privileges on all procedures in the PROJECT_USER schema
    FOR proc_record IN (SELECT object_name FROM all_objects WHERE object_type IN ('PROCEDURE', 'FUNCTION') AND owner = 'PROJECT_USER') LOOP
        EXECUTE IMMEDIATE 'GRANT EXECUTE ON PROJECT_USER.' || proc_record.object_name || ' TO ANALYST_USER';
    END LOOP;

    -- Grant EXECUTE privileges on all packages in the PROJECT_USER schema
    FOR package_record IN (SELECT object_name FROM all_objects WHERE object_type = 'PACKAGE' AND owner = 'PROJECT_USER') LOOP
        EXECUTE IMMEDIATE 'GRANT EXECUTE ON PROJECT_USER.' || package_record.object_name || ' TO ANALYST_USER';
    END LOOP;

    -- Grant EXECUTE privileges on all package bodies in the PROJECT_USER schema
    FOR package_body_record IN (SELECT object_name FROM all_objects WHERE object_type = 'PACKAGE BODY' AND owner = 'PROJECT_USER') LOOP
        EXECUTE IMMEDIATE 'GRANT EXECUTE ON PROJECT_USER.' || package_body_record.object_name || ' TO ANALYST_USER';
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        NULL; -- Ignore errors if privileges already exist or if something else goes wrong
END;
/
