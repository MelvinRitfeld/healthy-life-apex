create or replace trigger aut_ure_biur
  before insert or update on aut_usr_rle for each row
declare
  -- start custom declare
  -- end custom declare
begin
  --
  if    inserting
  then
    --
    :new.ure_created_by     := nvl( v('APP_USER'), user);
    :new.ure_created_date   := sysdate;
    --
    null;
    --
    -- start custom inserting
    -- end custom inserting
    --
  elsif updating
  then
    --
    :new.ure_modified_by    := nvl( v('APP_USER'), user);
    :new.ure_modified_date  := sysdate;
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
end aut_ure_biur;
/
