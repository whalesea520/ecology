alter table DocChangeFieldConfig add sn integer
/
alter table DocChangeFieldConfig add id integer 
/
create sequence DocChangeFieldConfig_Id
       start with 1
       increment by 1
       nomaxvalue
       nocycle
/
CREATE OR REPLACE TRIGGER DocChange_F_C_Id_Trigger
  before insert on DocChangeFieldConfig
  for each row
  begin
  select DocChangeFieldConfig_Id.nextval into :new.id from dual;
  end;
/
