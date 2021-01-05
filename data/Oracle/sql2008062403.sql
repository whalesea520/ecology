CREATE TABLE Workflow_DocProp ( 
    id integer NOT NULL ,
    workflowId integer NULL,
    selectItemId integer NULL,
    secCategoryId integer NULL
)  
/

create sequence Workflow_DocProp_id
start with 1
increment by 1
nomaxvalue
nocycle
/


create or replace trigger Workflow_DocProp_Tri
before insert on Workflow_DocProp
for each row
begin
select Workflow_DocProp_id.nextval into :new.id from dual;
end;
/

CREATE TABLE Workflow_DocPropDetail ( 
    id integer NOT NULL ,
    docPropId integer NULL,
    docPropFieldId integer NULL,
    workflowFieldId integer NULL
)  
/

create sequence Workflow_DocPropDetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/


create or replace trigger Workflow_DocPropDetail_Tri
before insert on Workflow_DocPropDetail
for each row
begin
select Workflow_DocPropDetail_id.nextval into :new.id from dual;
end;
/
