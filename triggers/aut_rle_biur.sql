create or replace trigger aut_rle_biur
  before insert or update on aut_roles for each row
declare
  -- start custom declare
  -- end custom declare
begin
  --
  if    inserting
  then
    --
    :new.rle_created_by     := nvl( v('APP_USER'), user);
    :new.rle_created_date   := sysdate;
    --
    null;
    --
    -- start custom inserting
    -- end custom inserting
    --
  elsif updating
  then
    --
    :new.rle_modified_by    := nvl( v('APP_USER'), user);
    :new.rle_modified_date  := sysdate;
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
end aut_rle_biur;
/
