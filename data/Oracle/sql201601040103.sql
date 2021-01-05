create table carbasic
(
    id int primary key,
    workflowid int,
	workflowname varchar(100),
	typeid int,
	wtype int,
	formid int,
	isuse int,
	modifydate varchar(20)
)
/
create sequence carbasic_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger carbasic_id_Tri
before insert on carbasic
for each row
begin
select carbasic_id.nextval into :new.id from dual;
end;
/

create table mode_carrelatemode
(
    id int primary key,
    mainid int,
    carfieldid int,
    modefieldid int
)
/
create sequence mode_carrelatemode_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mode_carrelatemode_id_Tri
before insert on mode_carrelatemode
for each row
begin
select mode_carrelatemode_id.nextval into :new.id from dual;
end;
/