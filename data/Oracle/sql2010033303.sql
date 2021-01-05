CREATE TABLE HrmMessagerGroup (
	groupname  int  NOT NULL,
	groupdesc  varchar(1000)  NOT NULL 
) 
/
create sequence HrmMessagerGroup_seq
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmMessagerGroup_Trigger
before insert on HrmMessagerGroup
for each row
begin
select HrmMessagerGroup_seq.nextval into :new.id from dual;
end;
/ 

CREATE TABLE HrmMessagerGroupUsers (
	id int  NOT NULL,
	userloginid  varchar(100) NOT NULL ,
	groupname  int NOT NULL ,
	isadmin  char(1) NOT NULL 
) 
/

create sequence HrmMessagerGroupUsers_seq
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmMessagerGroupUsers_Trigger
before insert on HrmMessagerGroupUsers
for each row
begin
select HrmMessagerGroupUsers_seq.nextval into :new.id from dual;
end;
/ 

CREATE TABLE HrmMessagerContact (
	id int  NOT NULL,
	loginid varchar(50) not null,
	contactLoginid  varchar(50) not null,
	lastContactTime varchar(20) not null
) 
/
create sequence HrmMessagerContact_seq
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmMessagerContact_Trigger
before insert on HrmMessagerContact
for each row
begin
select HrmMessagerContact_seq.nextval into :new.id from dual;
end;
/ 

alter table hrmresource  add messagerurl  varchar2(100) 
/

CREATE TABLE HrmMessagerMsg (
	id int  NOT NULL,
	jidCurrent varchar(50) not null,
	sendTo  varchar(50) not null,
	msg varchar(1000)  null,
	strTime varchar(22) not null
) 
/

create sequence HrmMessagerMsg_seq
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmMessagerMsg_Trigger
before insert on HrmMessagerMsg
for each row
begin
select HrmMessagerMsg_seq.nextval into :new.id from dual;
end;
/ 

create index i_msgJid on HrmMessagerMsg(jidCurrent)
/

CREATE TABLE HrmMessagerSetting (
	id int  NOT NULL,
	name varchar(50) not null,
	value  varchar(50) not null
) 
/

create sequence HrmMessagerSetting_seq
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmMessagerSetting_Trigger
before insert on HrmMessagerSetting
for each row
begin
select HrmMessagerSetting_seq.nextval into :new.id from dual;
end;
/
