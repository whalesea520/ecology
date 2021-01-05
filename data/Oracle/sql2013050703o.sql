create or replace trigger workflowcssdetail_id_Tri
before insert on workflow_cssdetail
for each row
begin
select workflowcssdetail_id.nextval into :new.detailid from dual;
end;
/