create or replace trigger workflow_viewlog_Trigger
before insert on workflow_viewlog
for each row
begin
select WORKFLOW_LOG_SEQ.nextval into :new.id from dual;
end;
/