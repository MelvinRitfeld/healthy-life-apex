create or replace trigger aut_usr_biur
  before insert or update on aut_users for each row
declare
  -- start custom declare
  -- end custom declare
begin
  --
  if    inserting
  then
    --
    :new.usr_created_by     := nvl( v('APP_USER'), user);
    :new.usr_created_date   := sysdate;
    --
    null;
    --
    -- start custom inserting
    -- end custom inserting
    --
  elsif updating
  then
    --
    :new.usr_modified_by    := nvl( v('APP_USER'), user);
    :new.usr_modified_date  := sysdate;
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
end aut_usr_biur;
/
