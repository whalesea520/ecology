create or replace trigger HrmProvince_TRIGGER
  before insert on HrmProvince
  for each row
begin
  select HrmProvince_id.nextval into :new.id from dual;
end;
/
create or replace trigger HrmCity_TRIGGER
  before insert on HrmCity
  for each row
begin
  select HrmCity_id.nextval into :new.id from dual;
end;
/
