create or replace trigger bill_returncpt_Tri1
before insert on bill_returncpt
for each row
begin
select bill_returncpt_id.nextval into :new.id from dual;
end;
/
