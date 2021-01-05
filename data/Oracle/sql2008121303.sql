create table worktask_requestlog(
	logid integer,
	requestid integer null,
	fieldid integer null,
	oldvalue varchar(2000) null,
	newvalue varchar(2000) null,
	ipaddress varchar(20) null,
	optuserid integer null,
	optdate varchar(10) null,
	opttime varchar(10) null
)
/
create sequence worktask_requestlog_logid
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger worktask_requestlog_logid_Tri
before insert on worktask_requestlog
for each row
begin
select worktask_requestlog_logid.nextval into :new.logid from dual;
end;
/
