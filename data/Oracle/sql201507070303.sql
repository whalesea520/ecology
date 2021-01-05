create or replace trigger DataCenterUserSetting_trigger
before insert on DataCenterUserSetting for each row
begin
select increase_seq.nextval into :new.id from dual;
end;
/