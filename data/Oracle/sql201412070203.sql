create or replace trigger workflow_reqlogAtInfo_tri
before insert on workflow_requestlogAtInfo
for each row
begin
select workflow_requestlogAtInfo_seq.nextval into :new.id from dual;
end;
/