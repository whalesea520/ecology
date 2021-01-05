create table mode_DataBatchImport
(
    ID INT primary key,
    modeid int,
    interfacepath varchar(200),
    isuse int
)
/
create sequence mode_DataBatchImport_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger mode_DataBatchImport_id_Tri
before insert on mode_DataBatchImport
for each row
begin
select mode_DataBatchImport_id.nextval into :new.id from dual;
end;
/