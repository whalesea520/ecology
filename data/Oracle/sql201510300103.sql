create or replace trigger selectItemLog_trigger
before insert on selectItemLog
for each row
begin
select selectItemLog_id.nextval into :new.id from dual;
end;
/