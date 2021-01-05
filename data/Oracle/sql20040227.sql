drop trigger HrmAwardInfo_Trigger
/
create or replace trigger HrmAwardInfo_Trigger
before insert on HrmAwardInfo
for each row
begin
select HrmAwardInfo_id.nextval into :new.id from dual;
end;
/
