CREATE TABLE workflow_nodelinkOTField(
    id integer NOT NULL ,
    overTimeId integer NULL,
    toFieldId integer NULL,
    toFieldName varchar2(4000) NULL,
    toFieldGroupId integer NULL,
    fromFieldId integer NULL
)
/

create sequence workflow_nodelinkOTField_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger workflow_nodelinkOTField_Tri
before insert on workflow_nodelinkOTField
for each row
begin
select workflow_nodelinkOTField_id.nextval into :new.id from dual;
end;
/