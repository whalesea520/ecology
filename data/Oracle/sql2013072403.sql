CREATE TABLE PluginMessageRecent(
	id NUMBER NOT NULL,
	fromUid VARCHAR2(50) NOT NULL,
	toUid VARCHAR2(50) NOT NULL,
	RecentTime VARCHAR2(22) NOT NULL,
	source VARCHAR2(1) NOT NULL
)
/

CREATE SEQUENCE PluginMessageRecent_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger PluginMessageRecent_Trigger
before insert on PluginMessageRecent
for each row
begin
select PluginMessageRecent_id.nextval into :new.id from dual;
end;
/
