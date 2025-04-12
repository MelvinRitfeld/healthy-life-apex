--Vews

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "AUT_USER_PRIVILEGES_VW" ("USR_ID", "USR_RLE_ID", "USR_PVE_ID", "USR_USERNAME", "USR_EMAIL", "USR_RLE_NAME", "USR_RLE_DESCRIPTION", "USR_RLE_VALID_FROM", "USR_RLE_VALID_UNTIL", "USR_PVE_NAME", "USR_PVE_APEX_PAGE", "USR_PVE_APEX_COMPONENT_NAME", "USR_PVE_READ", "USR_PVE_WRITE", "USR_PVE_VALID_FROM", "USR_PVE_VALID_UNTIL") AS 
  select  usr.usr_id                  usr_id              
  ,       rle.rle_id                  usr_rle_id              
  ,       pve.pve_id                  usr_pve_id              
  -- user details         
  ,       usr.usr_username            usr_username            
  ,       usr.usr_email               usr_email
  -- user role details    
  ,       rle.rle_name                usr_rle_name                
  ,       rle.rle_description         usr_rle_description                
  ,       ure.ure_valid_from          usr_rle_valid_from
  ,       ure.ure_valid_until         usr_rle_valid_until
  -- priv details
  ,       pve.pve_name                usr_pve_name              
  ,       pve.pve_apex_page           usr_pve_apex_page      
  ,       pve.pve_apex_component_name usr_pve_apex_component_name                  
  ,       pve.pve_read                usr_pve_read  
  ,       pve.pve_write               usr_pve_write  
  ,       rpe.rpe_valid_from          usr_pve_valid_from
  ,       rpe.rpe_valid_until         usr_pve_valid_until
  from    aut_users         usr
  join    aut_usr_rle       ure on usr.usr_id = ure.ure_usr_id
  join    aut_roles         rle on rle.rle_id = ure.ure_rle_id
  join    aut_rle_pve       rpe on rle.rle_id = rpe.rpe_rle_id
  join    aut_privileges    pve on pve.pve_id = rpe.rpe_pve_id;




    CREATE OR REPLACE FORCE EDITIONABLE VIEW "VW_ACTIVE_USERS_PER_MONTH" ("LABEL", "VALUE") AS 
  SELECT 
  TO_CHAR(usr_created_date, 'MON-YYYY') AS label,
  COUNT(*)                           AS value
FROM aut_users
WHERE usr_status = 'Active'
GROUP BY TO_CHAR(usr_created_date, 'MON-YYYY');


  CREATE OR REPLACE FORCE EDITIONABLE VIEW "VW_MEMBERSHIP_USAGE" ("LABEL", "VALUE") AS 
  SELECT 
  membership_type AS label,
  COUNT(*)        AS value
FROM core_membership
GROUP BY membership_type;


  CREATE OR REPLACE FORCE EDITIONABLE VIEW "VW_PAYMENTS_PER_MONTH" ("LABEL", "VALUE") AS 
  SELECT 
  TO_CHAR(payment_date, 'MON-YYYY') AS label,
  SUM(amount)                       AS value
FROM core_payment
GROUP BY TO_CHAR(payment_date, 'MON-YYYY');