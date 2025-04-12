create or replace package aut_authorisation
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
  return boolean;
      
end aut_authorisation;
/