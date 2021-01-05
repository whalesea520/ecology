CREATE TABLE HrmMessagerTempMsg ( 
    id integer not null,
    loginid varchar(20),
    fromJid varchar(200),
	body varchar(1000),
    receiveTime varchar(20)
) 
/
create sequence HrmMessagerTempMsg_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmMessagerTempMsg_id_trigger
before insert on HrmMessagerTempMsg
for each row
begin
select HrmMessagerTempMsg_id.nextval into :new.id from dual;
end;
/
