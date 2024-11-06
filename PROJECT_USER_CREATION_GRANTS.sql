

DECLARE
    user_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO user_count FROM all_users WHERE username = 'PROJECT_USER';
    IF user_count = 0 THEN
        EXECUTE IMMEDIATE 'CREATE USER PROJECT_USER IDENTIFIED BY Sasapnilgneu07#';
    END IF;
END;
/
-- Grant privileges to the user
BEGIN
    EXECUTE IMMEDIATE 'GRANT CONNECT, RESOURCE TO PROJECT_USER';
EXCEPTION
    WHEN OTHERS THEN
        NULL; -- Ignore if grants already exist
END;
/