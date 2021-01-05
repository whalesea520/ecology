alter table fnaFeeWfInfoField add fieldValueWfSys INTeger
/
alter table fnaFeeWfInfoField add tabIndex INTeger
/

CREATE TABLE FnaCostStandardErrorMsg(
	id integer PRIMARY KEY NOT NULL,
	userid integer ,
	requestid integer ,
	msg VARCHAR2(2000)
)
/
create sequence FnaCostStandardErrorMsg_id minvalue 1 maxvalue 999999999999999999999999999 start with 1 increment by 1 cache 20
/

create or replace trigger FnaCSErrorMsg_Trigger before insert on FnaCostStandardErrorMsg for each row 
begin select FnaCostStandardErrorMsg_id.nextval INTO :new.id from dual; end