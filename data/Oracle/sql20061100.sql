create or replace trigger Workflow_SubwfSetDetail_Tri
before insert on Workflow_SubwfSetDetail
for each row
begin
select Workflow_SubwfSetDetail_Id.nextval into :new.id from dual;
end;
/