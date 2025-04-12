create or replace package body aut_authentication
is
/*
  This package contains functions and procedures relating to managing user authentication
*/
  -- validate user credentials
  function is_login_valid 
    ( p_username  in aut_users.usr_username%type
    , p_password  in aut_users.usr_password%type  
    )
  return boolean
  is
    cursor c_usr(b_username in aut_users.usr_username%type)
      is
        select  *
        from    aut_users usr
        where   upper(usr.usr_username) = upper(b_username)
        ;
    
    lr_user         c_usr%rowtype;
    ln_hash_method  pls_integer;
    lb_usr_found    boolean := false;
    lb_login_valid  boolean := false;
  begin
    -- get user credentials
    open  c_usr(b_username => p_username);
    fetch c_usr into lr_user;
    lb_usr_found := c_usr%found;
    close c_usr;

    if lb_usr_found
    then
      lb_login_valid := lr_user.usr_password = p_password;
    end if;

    return lb_login_valid;
  end is_login_valid;

end aut_authentication;
/