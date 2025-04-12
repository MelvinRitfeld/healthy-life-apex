create or replace package body aut_authorisation
as
  -- check if user has authorization for a certain page/component
  function has_user_privilege
    ( p_username        in aut_users.usr_username%type                  default null
    , p_role            in aut_roles.rle_name%type                      default null
    , p_privilege       in aut_privileges.pve_name%type                 default null
    , p_page            in aut_privileges.pve_apex_page%type            default null
    , p_component       in aut_privileges.pve_apex_component_name%type  default null
    , p_read            in aut_privileges.pve_read%type                 default null
    , p_write           in aut_privileges.pve_write%type                default null
    , p_usr_id          in aut_users.usr_id%type                        default null
    , p_rle_id          in aut_roles.rle_id%type                        default null
    , p_pve_id          in aut_privileges.pve_id%type                   default null
    , p_component_type  in varchar2                                     default null
    )
  return boolean
  is

    -- check user privs
    cursor c_user_privs
      ( b_username        in aut_users.usr_username%type                  
      , b_role            in aut_roles.rle_name%type                      
      , b_privilege       in aut_privileges.pve_name%type                 
      , b_page            in aut_privileges.pve_apex_page%type            
      , b_component       in aut_privileges.pve_apex_component_name%type  
      , b_read            in aut_privileges.pve_read%type                 
      , b_write           in aut_privileges.pve_write%type                
      , b_usr_id          in aut_users.usr_id%type                        
      , b_rle_id          in aut_roles.rle_id%type                        
      , b_pve_id          in aut_privileges.pve_id%type                   
      )
    is
      select  *
      from    aut_user_privileges_vw usr
      where   (upper(usr.usr_username) = upper(b_username) or usr.usr_id = b_usr_id)
      and     (
                -- check if user has roles
                  coalesce(usr.usr_rle_id, 0)                     = coalesce(b_rle_id, usr.usr_rle_id, 0)
              and coalesce(usr.usr_rle_name, 'x')                 = coalesce(b_role, usr.usr_rle_name, 'x')
              and (trunc(usr_rle_valid_from)                      <= trunc(sysdate) or usr_rle_valid_from is null)
              and (trunc(usr_rle_valid_until)                     >= trunc(sysdate) or usr_rle_valid_until is null)
              -- check if user role has privs
              and coalesce(usr.usr_pve_id, 0)                     = coalesce(b_pve_id, usr.usr_pve_id, 0)
              and coalesce(usr.usr_pve_name, 'x')                 = coalesce(b_privilege, usr.usr_pve_name,'x')
              and coalesce(usr.usr_pve_apex_page, 0)              = coalesce(b_page, usr.usr_pve_apex_page, 0)
              and coalesce(usr.usr_pve_apex_component_name,'x')   = coalesce(b_component, usr.usr_pve_apex_component_name, 'x')
              and coalesce(usr.usr_pve_read,'x')                  = coalesce(b_read, usr.usr_pve_read, 'x')
              and coalesce(usr.usr_pve_write,'x')                 = coalesce(b_write, usr.usr_pve_write, 'x')
              and (trunc(usr.usr_pve_valid_from)                  <= trunc(sysdate) or usr.usr_pve_valid_from is null)
              and (trunc(usr_pve_valid_until)                     >= trunc(sysdate) or usr_pve_valid_until is null)              
            );  

    -- variables
    lr_usr_privs  c_user_privs%rowtype;
    lb_retval     boolean := false;                     
  begin
    -- Debug messages
    apex_debug.message('> aut_authorisation.has_user_privilege ');
    apex_debug.message('p_username = '||p_username);
    apex_debug.message('p_role = '||p_role);
    apex_debug.message('p_privilege = '||p_privilege);
    apex_debug.message('p_page = '||p_page);
    apex_debug.message('p_component = '||p_component);
    apex_debug.message('p_read = '||p_read);
    apex_debug.message('p_write = '||p_write);
    apex_debug.message('p_usr_id = '||p_usr_id);
    apex_debug.message('p_rle_id = '||p_rle_id);
    apex_debug.message('p_pve_id = '||p_pve_id);
    apex_debug.message('p_component_type = '||p_component_type);  

    -- check privs
    open c_user_privs(b_username    => p_username    
                    , b_role        => p_role    
                    , b_privilege   => p_privilege    
                    , b_page        => p_page    
                    , b_component   => p_component    
                    , b_read        => p_read    
                    , b_write       => p_write    
                    , b_usr_id      => p_usr_id    
                    , b_rle_id      => p_rle_id    
                    , b_pve_id      => p_pve_id    
                    );
    fetch c_user_privs
    into  lr_usr_privs;
    -- set return value
    lb_retval := c_user_privs%found;
    close c_user_privs;                    
    
    -- Debug messages
    apex_debug.message('< aut_authorisation.has_user_privilege ');
    -- return val
    return lb_retval;
  end has_user_privilege;
      
end aut_authorisation;
/