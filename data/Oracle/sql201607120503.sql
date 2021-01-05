create table social_sysremind(
	id int primary key,
  	remindtype int,
  	requestid int,
  	requesttitle varchar2(100),
  	requestdetails varchar(2000),
  	sendtime char(20),
  	extra varchar(1000)
)
/
create table social_sysremindreceiver(
	id int primary key,
  	remindid int,
  	receiverid int
)
/
create sequence social_sysremind_seq 
start with 1 
increment by 1 
nomaxvalue 
nocycle
/
create or replace trigger social_sysremind_trigger 
before insert on social_sysremind
for each row 
begin 
	select social_sysremind_seq.nextval into:new.id from sys.dual;
end;
/

create sequence social_sr_receiver_seq 
start with 1 
increment by 1 
nomaxvalue 
nocycle
/
create or replace trigger social_sr_receiver_trigger 
before insert on social_sysremindreceiver
for each row 
begin 
	select social_sr_receiver_seq.nextval into:new.id from sys.dual;
end;
/
create table social_sysremindtype(
	id int primary key,
  	remindtype int,
  	remindname varchar(100),
  	surl varchar2(200)
)
/
create sequence social_sr_type_seq 
start with 1 
increment by 1 
nomaxvalue 
nocycle
/
create or replace trigger social_sr_type_trigger 
before insert on social_sysremindtype
for each row 
begin 
	select social_sr_type_seq.nextval into:new.id from sys.dual;
end;
/

create index social_receiverid_index on social_sysremindreceiver(receiverid)
/

create index social_sysrtypeid_index on social_sysremindtype(remindtype)
/

create table social_sysremindsetting(
	id int primary key,
  	remindtype int,
  	userid int,
  	ifon char(1),
  	ifDeskRemind char(1)
)
/
create index social_settingtype_index on social_sysremindsetting(remindtype)
/
create sequence social_sr_set_seq 
start with 1 
increment by 1 
nomaxvalue 
nocycle
/
create or replace trigger social_sr_set_trigger 
before insert on social_sysremindsetting
for each row 
begin 
	select social_sr_set_seq.nextval into:new.id from sys.dual;
end;
/