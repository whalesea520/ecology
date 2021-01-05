CREATE TABLE wx_scanlog(
	id			integer NULL,
	type		integer NULL,
	othertypes	integer NULL,
	reourceid	integer NULL,
	otherid		integer NULL,
	scantime	varchar(20) NULL
)
/
create sequence WX_SCANLOG_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger WX_SCANLOG_id_trigger
before insert on wx_scanlog
for each row
begin
select WX_SCANLOG_id.nextval into :new.id from dual;
end;
/
create table wx_initclass (
   id                   integer				null,
   classpath			varchar(500)		null
)
/
create sequence WX_INITCLASS_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger WX_INITCLASS_id_trigger
before insert on wx_initclass
for each row
begin
select WX_INITCLASS_id.nextval into :new.id from dual;
end;
/
