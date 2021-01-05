CREATE TABLE WorkflowToDocProp ( 
    id integer NOT NULL ,
    workflowId integer NULL,
    secCategoryId integer NULL
)  
/
create sequence WorkflowToDocProp_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger WorkflowToDocProp_Tri
before insert on WorkflowToDocProp
for each row
begin
select WorkflowToDocProp_id.nextval into :new.id from dual;
end;
/

CREATE TABLE WorkflowToDocPropDetail ( 
    id integer NOT NULL ,
    docPropId integer NULL,
    docPropFieldId integer NULL,
    workflowFieldId integer NULL
)  
/
create sequence WorkflowToDocPropDetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger WorkflowToDocPropDetail_Tri
before insert on WorkflowToDocPropDetail
for each row
begin
select WorkflowToDocPropDetail_id.nextval into :new.id from dual;
end;
/

alter table workflow_base add keepsign integer
/
alter table docdetail add fromworkflow integer
/
alter table workflow_base add secCategoryId int
/
