create or replace FUNCTION custom_authentication(
  p_username IN VARCHAR2,
  p_password IN VARCHAR2
) RETURN BOOLEAN
IS
  l_valid BOOLEAN;
BEGIN
  l_valid := aut_authentication.is_login_valid(p_username, p_password);

  IF NOT l_valid THEN
    raise_application_error(
      -20001,
      'Invalid credentials for: ' || p_username || '/' || p_password
    );
  END IF;

  RETURN l_valid;
END;
/



create or replace FUNCTION get_user_role (p_username IN VARCHAR2) 
RETURN VARCHAR2 
IS 
    l_role VARCHAR2(50); 
BEGIN 
    SELECT rle.rle_name INTO l_role 
    FROM aut_users usr 
    JOIN aut_usr_rle ure ON usr.usr_id = ure.ure_usr_id 
    JOIN aut_roles rle ON ure.ure_rle_id = rle.rle_id 
    WHERE UPPER(usr.usr_username) = UPPER(p_username) 
    AND ure.ure_valid_until IS NULL; 
 
    RETURN l_role; 
EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
        RETURN NULL; 
END;
/