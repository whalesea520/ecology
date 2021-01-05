CREATE TABLE Social_WithdrawMsg(
	id int primary key,
	msgid varchar2(50),
	userid int,
	targetid varchar2(50)
)
/
create index social_wdmsgid_index on Social_WithdrawMsg(msgid)
/

create or replace trigger social_withdraw_trigger 
before insert on Social_WithdrawMsg
for each row 
begin 
	select social_withdraw_seq.nextval into:new.id from dual;
end;
/
create sequence social_withdraw_seq 
start with 1 
increment by 1 
nomaxvalue 
nocycle
/

create or replace trigger social_filedlog_trigger 
before insert on Social_FileDownloadLog
for each row 
begin 
	select social_filedlog_seq.nextval into:new.id from dual;
end;
/
create sequence social_filedlog_seq 
start with 1 
increment by 1 
nomaxvalue 
nocycle
/