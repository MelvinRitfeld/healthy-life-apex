create or replace TRIGGER trg_audit_aut_users
AFTER INSERT OR UPDATE OR DELETE ON AUT_USERS
FOR EACH ROW
DECLARE
  l_operation  VARCHAR2(10);
  l_usr_id     NUMBER;
  l_username   VARCHAR2(50);
BEGIN
  IF INSERTING THEN
    l_operation := 'INSERT';
    l_usr_id    := :NEW.USR_ID;
    l_username  := :NEW.USR_USERNAME;
  ELSIF UPDATING THEN
    l_operation := 'UPDATE';
    l_usr_id    := :NEW.USR_ID;
    l_username  := :NEW.USR_USERNAME;
  ELSIF DELETING THEN
    l_operation := 'DELETE';
    l_usr_id    := :OLD.USR_ID;
    l_username  := :OLD.USR_USERNAME;
  END IF;

  INSERT INTO CORE_AUDITLOG (table_name, record_id, operation, changed_by, changed_on)
  VALUES ('AUT_USERS', l_usr_id, l_operation, l_username, SYSDATE);
EXCEPTION
  WHEN OTHERS THEN
    NULL;  -- Optional: Log errors or re-raise after handling.
END;
/



create or replace TRIGGER "TRG_AUDIT_CORE_MEMBERSHIP" 
AFTER INSERT OR UPDATE OR DELETE ON CORE_MEMBERSHIP
FOR EACH ROW
DECLARE
  l_operation  VARCHAR2(10);
  l_mem_id     NUMBER;
  l_user       VARCHAR2(50);
BEGIN
  IF INSERTING THEN
    l_operation := 'INSERT';
    l_mem_id    := :NEW.MEMBERSHIP_ID;
  ELSIF UPDATING THEN
    l_operation := 'UPDATE';
    l_mem_id    := :NEW.MEMBERSHIP_ID;
  ELSIF DELETING THEN
    l_operation := 'DELETE';
    l_mem_id    := :OLD.MEMBERSHIP_ID;
  END IF;
  
  -- Get the current user from APEX if available, otherwise use the database user
  l_user := NVL(v('APP_USER'), user);

  INSERT INTO CORE_AUDITLOG (table_name, record_id, operation, changed_by, changed_on)
  VALUES ('CORE_MEMBERSHIP', l_mem_id, l_operation, l_user, SYSDATE);
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END;
/



create or replace TRIGGER "TRG_SET_MEMBERSHIP_DATES"
BEFORE INSERT OR UPDATE ON CORE_MEMBERSHIP
FOR EACH ROW
DECLARE
    l_current_user_id AUT_USERS.USR_ID%TYPE;
    l_app_user        VARCHAR2(50);
BEGIN
  IF INSERTING THEN
    -- If USR_ID is not supplied, try to automatically fill it
    IF :NEW.USR_ID IS NULL THEN
      l_app_user := NVL(v('APP_USER'), user);
      BEGIN
         SELECT usr_id 
           INTO l_current_user_id
           FROM aut_users
          WHERE UPPER(usr_username) = UPPER(l_app_user)
            AND ROWNUM = 1;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            BEGIN
               SELECT usr_id 
                 INTO l_current_user_id
                 FROM aut_users
                WHERE UPPER(usr_email) = UPPER(v('APP_USER_EMAIL'))
                  AND ROWNUM = 1;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  RAISE_APPLICATION_ERROR(-20002, 
                     'No matching user found for membership trigger. Check APP_USER or APP_USER_EMAIL.');
            END;
      END;
      :NEW.USR_ID := l_current_user_id;
    END IF;

    -- Set membership dates if the status is Active
    IF :NEW.STATUS = 'Active' THEN
      :NEW.START_DATE := NVL(:NEW.START_DATE, SYSDATE);
      :NEW.END_DATE   := NVL(:NEW.END_DATE, SYSDATE) + 30;
    END IF;
  
  ELSIF UPDATING THEN
    -- If status changes from non-Active to Active, set the dates accordingly
    IF (:OLD.STATUS <> 'Active' AND :NEW.STATUS = 'Active') THEN
      :NEW.START_DATE := NVL(:NEW.START_DATE, SYSDATE);
      :NEW.END_DATE   := NVL(:NEW.END_DATE, SYSDATE) + 30;
    END IF;
  END IF;
END;
/




create or replace TRIGGER "UPDATE_APPARAAT_STATUS" 
AFTER INSERT ON "CORE_ONDERHOUD_LOGBOEK"
FOR EACH ROW
BEGIN
    UPDATE CORE_APPARAAT
    SET beschikbaarheid = 'Under maintenance'
    WHERE apparaat_id = :NEW.apparaat_id;
END;
/

create or replace TRIGGER reset_apparaat_status
AFTER DELETE ON CORE_onderhoud_logboek
FOR EACH ROW
BEGIN
    UPDATE CORE_APPARAAT
    SET beschikbaarheid = 'Avaiable'
    WHERE apparaat_id = :OLD.apparaat_id;
END;
/