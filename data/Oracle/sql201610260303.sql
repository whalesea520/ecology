alter table workflow_base add traceFieldId integer
/
alter table workflow_base add traceSaveSecId integer
/
alter table workflow_base add traceCategoryType char(1)
/
alter table workflow_base add traceCategoryFieldId integer
/

alter table workflow_base add traceDocOwnerType integer 
/
alter table workflow_base add traceDocOwnerFieldId integer 
/
alter table workflow_base add traceDocOwner integer 
/

create table traceprop (
    id integer  not null,
    workflowid integer null,
    seccategoryid integer null
)  
/

create sequence traceprop_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger traceprop_id_tri
before insert on traceprop
for each row
begin
select traceprop_id.nextval into :new.id from dual;
end;
/


create table tracepropdetail ( 
    id integer  not null,
    docpropid integer null,
    docpropfieldid integer null,
    workflowfieldid integer null
)  
/

create sequence tracepropdetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger tracepropdetail_id_tri
before insert on tracepropdetail
for each row
begin
select tracepropdetail_id.nextval into :new.id from dual;
end;
/