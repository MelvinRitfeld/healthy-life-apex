create or replace package aut_authentication
is
/*
  This package contains functions and procedures relating to managing user authentication
*/
  function is_login_valid 
    ( p_username  in aut_users.usr_username%type
    , p_password  in aut_users.usr_password%type  
    )
  return boolean;

end aut_authentication;
/