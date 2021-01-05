create table worktask_monitorlog(
	id integer,
	requestid integer,
	taskcontent varchar(500),
	requeststatus integer,
	opter integer,
	optdate varchar(10),
	opttime varchar(10),
	opttype integer
)
/

create sequence wt_monitorlog_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger wt_monitorlog_id_Tri
before insert on worktask_monitorlog
for each row
begin
select wt_monitorlog_id.nextval into :new.id from dual;
end;
/
