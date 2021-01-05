create table social_IMHistoryLog(
	id  int,
	historyhour varchar(20)
)
/
create sequence social_IMHistoryLog_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger social_IMHistoryLog_id_tri
before insert on social_IMHistoryLog
for each row
begin
select social_IMHistoryLog_id.nextval into :new.id from dual;
end;
/