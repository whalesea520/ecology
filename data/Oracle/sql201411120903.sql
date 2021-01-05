 create table mode_remindjob(
	id int primary key ,
	name varchar2(200),
	isenable int,
	remindtype int,
	formid int,
	modeid int,
	appid int,
	createtime varchar2(20),
	creator int,
	remindtimetype int,
	reminddatefield int,
	remindtimefield int,
	reminddate varchar2(20),
	remindtime varchar2(20),
	incrementway int,
	incrementtype int,
	incrementfield int,
	incrementnum int,
	incrementunit int,
	remindway int,
	sendertype int,
	senderfield int,
	subject varchar2(200),
	reminddml varchar2(200),
	remindjava varchar2(200),
	conditionstype int,
	conditionsfield varchar2(4000),
	conditionsfieldcn varchar2(4000),
	conditionssql varchar2(4000),
	conditionsjava varchar2(200),
	remindcontenttype int,
	remindcontenttext varchar2(4000),
	remindcontentjava varchar2(200),
	receivertype int,
	receiverdetail varchar2(4000),
	receiverfieldtype int,
	receiverfield varchar2(4000),
	receiverlevel int,
	triggerway int,
	triggertype int,
	triggerexpression varchar2(200),
	triggercycletime int,
	weeks varchar2(200),
	months varchar2(200),
	days varchar2(200)
 )
/
 
create table mode_reminddata(
	id int primary key ,
	billid int,
	modeid int,
	remindjobid int,
	reminddate varchar2(10),
	remindtime varchar2(10),
	status int
)
/

create table mode_reminddata_log(
	id int primary key ,
	remindjobid int,
	lastreminddate varchar2(10),
	lastremindtime varchar2(10)
)
/
 
create sequence mode_remindjob_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger mode_remindjob_id_Tri
before insert on mode_remindjob
for each row
begin
select mode_remindjob_id.nextval into :new.id from dual;
end;
/

create sequence mode_reminddata_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger mode_reminddata_id_Tri
before insert on mode_reminddata
for each row
begin
select mode_reminddata_id.nextval into :new.id from dual;
end;
/

create sequence mode_reminddata_log_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger mode_reminddata_log_id_Tri
before insert on mode_reminddata_log
for each row
begin
select mode_reminddata_log_id.nextval into :new.id from dual;
end;
/