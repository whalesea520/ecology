create table mode_excelField(
    id int primary key,
    modeid int,
    formid int,
    note varchar(2000)
)
/
create sequence mode_excelField_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mode_excelField_id_Tri
before insert on mode_excelField
for each row
begin
select mode_excelField_id.nextval into :new.id from dual;
end;
/
create table mode_excelFieldDetail(
    id int primary key,
    mainid int,
    fieldid Blob,
    selectids varchar(1000),
    selectvalue int
)
/
create sequence mode_excelFieldDetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mode_excelFieldDetail_id_Tri
before insert on mode_excelFieldDetail
for each row
begin
select mode_excelFieldDetail_id.nextval into :new.id from dual;
end;
/
alter table mode_DataBatchImport add validateid int
/




