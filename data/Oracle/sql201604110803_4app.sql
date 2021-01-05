create table mode_impexp_log4app
(
	id integer NOT NULL,
	logid int,
	appno varchar2(10)
)
/
create sequence mode_impexp_log4app_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mode_impexp_log4app_Tri
before insert on mode_impexp_log4app
for each row
begin
select mode_impexp_log4app_id.nextval into :new.id from dual;
end;
/