create table mode_impexp_log
(
	id integer NOT NULL,
	creator int not null,
	createdate varchar2(10),
	createtime varchar2(8),
	type int not null,
	datatype int not null,
	fileid int,
	objid int
)
/
create sequence mode_impexp_log_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mode_impexp_log_Tri
before insert on mode_impexp_log
for each row
begin
select mode_impexp_log_id.nextval into :new.id from dual;
end;
/
create table mode_impexp_logdetail
(
	id integer NOT NULL,
	logid int not null,
	tablename varchar2(50),
	logtype int not null,
	message varchar2(1000)
)
/
create sequence mode_impexp_logdetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mode_impexp_logdetail_Tri
before insert on mode_impexp_logdetail
for each row
begin
select mode_impexp_logdetail_id.nextval into :new.id from dual;
end;
/
create table mode_impexp_recorddetail
(
	id integer NOT NULL,
	tablename varchar2(50) not null,
	columnname varchar2(50) not null,
	columnvalue varchar2(100),
	requestid varchar2(32) not null,
	rollbackid varchar2(32),
	ptype integer not null
)
/
create sequence mode_impexp_recorddetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mode_impexp_recorddetail_Tri
before insert on mode_impexp_recorddetail
for each row
begin
select mode_impexp_recorddetail_id.nextval into :new.id from dual;
end;
/