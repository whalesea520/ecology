CREATE TABLE mobile_ding (
	id integer  not null,
	sendid integer NOT NULL,
	content varchar(1000),
	scopeid varchar(100),
	messageid varchar(100),
	udid varchar(100),
	operate_date varchar(20) NOT NULL
)
/
create sequence mobile_ding_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mobile_ding_id_trigger
before insert on mobile_ding
for each row
begin
select mobile_ding_id.nextval into :new.id from dual;
end;
/


CREATE TABLE mobile_dingReciver (
	id integer  not null,
	dingid integer NOT NULL,
	userid integer NOT NULL,
	confirm varchar(20) NOT NULL
)
/
create sequence mobile_dingReciver_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mobile_dingReciver_id_trigger
before insert on mobile_dingReciver
for each row
begin
select mobile_dingReciver_id.nextval into :new.id from dual;
end;
/


CREATE TABLE mobile_dingReply (
	id integer  not null,
	dingid integer NOT NULL,
	userid integer NOT NULL,
	content varchar(1000),
	operate_date varchar(20) NOT NULL
)
/
create sequence mobile_dingReply_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mobile_dingReply_id_trigger
before insert on mobile_dingReply
for each row
begin
select mobile_dingReply_id.nextval into :new.id from dual;
end;
/


CREATE TABLE mobile_rongGroup (
	id integer  not null,
	userid integer NOT NULL,
	group_id varchar(200)
)
/
create sequence mobile_rongGroup_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mobile_rongGroup_id_trigger
before insert on mobile_rongGroup
for each row
begin
select mobile_rongGroup_id.nextval into :new.id from dual;
end;
/