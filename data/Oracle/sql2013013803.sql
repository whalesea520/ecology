CREATE TABLE PluginMessages (
	id int NOT NULL,
	fromUid varchar(50) NOT NULL,
	sendTo varchar(50) NOT NULL,
	msg varchar(1000) NULL,
	receiveTime varchar(22) NOT NULL
)
/

create sequence PluginMessages_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger PluginMessages_Trigger
before insert on PluginMessages
for each row
begin
select PluginMessages_id.nextval into :new.id from dual;
end;
/
