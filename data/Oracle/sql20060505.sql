insert into SysPoppupInfo values (7,'/system/sysRemindWfLink.jsp?flag=contractExpWf','合同到期提醒','y','合同到期提醒')
/

create table HrmRemindMsg
	(id integer ,
	remindtype integer,
	resourceid integer,
	reminddate char(10) ,
	relatedid integer
	)
/
create sequence HrmRemindMsg_id
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmRemindMsg_Tri
before insert on HrmRemindMsg
for each row
begin
select HrmRemindMsg_id.nextval into :new.id from dual;
end;
/

create index index_hrmremind on HrmRemindMsg(id)
/

INSERT INTO HtmlLabelIndex values(18884,'试用期')
/
INSERT INTO HtmlLabelInfo VALUES(18884,'试用期',7)
/
INSERT INTO HtmlLabelInfo VALUES(18884,'probation period',8)
/