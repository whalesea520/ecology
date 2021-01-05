create or replace trigger mode_batchSet_Tri
before insert on mode_batchSet
for each row
begin
select mode_batchSet_id.nextval into :new.id from dual;
end;
/