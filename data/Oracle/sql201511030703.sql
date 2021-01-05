alter table FnaSystemSet add fnaBackgroundValidator int default 0
/
CREATE TABLE FnaMobileErrorMsg(
	id integer primary key not null,
	userid integer,
	requestid integer,
	msg varchar2(2000)
)
/

create sequence seq_FnaMobileErrorMsg_ID minvalue 1 maxvalue 999999999999999999999999999 start with 1 increment by 1 cache 20
/

create or replace trigger FnaMobileErrorMsg_Trigger
before insert 
on FnaMobileErrorMsg
for each row 
begin 
	select seq_FnaMobileErrorMsg_ID.nextval into :new.id from dual; 
end;
/