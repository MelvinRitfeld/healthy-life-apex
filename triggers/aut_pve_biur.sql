create or replace trigger aut_pve_biur
  before insert or update on aut_privileges for each row
declare
  -- start custom declare
  -- end custom declare
begin
  --
  if    inserting
  then
    --
    :new.pve_created_by     := nvl( v('APP_USER'), user);
    :new.pve_created_date   := sysdate;
    --
    null;
    --
    -- start custom inserting
    -- end custom inserting
    --
  elsif updating
  then
    --
    :new.pve_modified_by    := nvl( v('APP_USER'), user);
    :new.pve_modified_date  := sysdate;
    --
    null;
    --
    -- start custom updating
    -- end custom updating
    --
  end if;
  --
  -- start custom body
  -- end custom body
  --
end aut_pve_biur;
/
