create sequence HrmProvince_ID
minvalue 1
maxvalue 999999999999999999999999999
start with 693431
increment by 1
cache 50
order
/
create or replace trigger HrmProvince_TRIGGER
  before insert on HrmProvince
  for each row
begin
  select HrmProvince_id.nextval into :new.id from dual;
end
/
create sequence HrmCity_ID
minvalue 1
maxvalue 999999999999999999999999999
start with 693431
increment by 1
cache 50
order
/
create or replace trigger HrmCity_TRIGGER
  before insert on HrmCity
  for each row
begin
  select HrmCity_id.nextval into :new.id from dual;
end
/