create or replace trigger hpinfo_workflow_trigger
before insert on hpinfo_workflow for each row
begin
select hpinfo_workflow_seq.nextval into :new.id from dual;
end;
/