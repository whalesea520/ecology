create table hpinfo_workflow (
	id int not null,
	infoname varchar(1000),
	styleid varchar(1000),
	layoutid int,
	isuse char(1),
	islocked int,
	creatortype int,
	creatorid int,
	menustyleid varchar(1000),
	wfid int,
	wfnid int,
	hpid int
)
/
create sequence hpinfo_workflow_seq increment by 1 start with 1 nomaxvalue nocycle cache 10
/
create or replace trigger hpinfo_workflow_trigger
before insert on hpinfo_workflow for each row
begin
select hpinfo_workflow_seq.nextval into :new.id from dual;
end
/
