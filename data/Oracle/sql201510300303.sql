create table HistoryMsg(
	id int,
	fromUserId varchar(100),
	targetId varchar(100),
	targetType varchar(100),
	GroupId varchar(100),
	classname varchar(100),
	msgContent clob,
	extra clob,
	type varchar(100),
	imageUri varchar(100),
	dateTime varchar(100)
)
/
create sequence HistoryMsg_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger HistoryMsg_id_tri
before insert on HistoryMsg
for each row
begin
select HistoryMsg_id.nextval into :new.id from dual;
end;
/