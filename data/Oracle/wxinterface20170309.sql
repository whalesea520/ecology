CREATE TABLE WX_SETMSGLOG(
	id			integer		NULL,
	userstrs	clob		NULL,
	requestid	integer		NULL,
	workflowid	integer		NULL,
	msgcode		varchar(10) NULL,
	errormsg	clob		NULL,
	createtime	varchar(20) NULL
)
/
create sequence WX_SETMSGLOG_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger WX_SETMSGLOG_id_trigger
before insert on WX_SETMSGLOG
for each row
begin
select WX_SETMSGLOG_id.nextval into :new.id from dual;
end;
/
create index WX_SETMSGLOG_Index_1 on WX_SETMSGLOG (
requestid ASC
)
/
create index WX_SETMSGLOG_Index_2 on WX_SETMSGLOG (
workflowid ASC
)
/