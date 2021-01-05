create or replace trigger mode_t_workflowsetdetail_Tri
before insert on mode_triggerworkflowsetdetail
for each row
begin
select mode_t_workflowsetdetail_id.nextval into :new.id from dual;
end;
/
