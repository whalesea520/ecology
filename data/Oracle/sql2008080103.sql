create table workflow_specialfield(
    id integer not null,
    fieldid integer null,
    displayname varchar2(1000),
    linkaddress varchar2(1000),
    descriptivetext varchar2(4000),
    isbill integer null,
    isform integer null
)
/
create sequence workflow_specialfield_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger workflow_specialfield_Trigger
before insert on workflow_specialfield
for each row
begin
select workflow_specialfield_id.nextval into :new.id from dual;
end;
/
