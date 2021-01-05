insert into SysPoppupInfo values (2,'/system/sysRemindWfLink.jsp?flag=birthWf','生日提醒','y','生日提醒')
/
create table HrmBirthRemindMsg
(id integer ,
title varchar2(200),
resources varchar2(500),
reminddate char(10))
/
create sequence HrmBirthRemindMsg_id
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HBhRemindMsg_Trigger
before insert on HrmBirthRemindMsg
for each row
begin
select HrmBirthRemindMsg_id.nextval into :new.id from dual;
end;
/

create index index_hrmbirthremind on HrmBirthRemindMsg(id)
/
INSERT INTO HtmlLabelIndex values(18352,'生日祝词')
/
INSERT INTO HtmlLabelInfo VALUES(18352,'生日祝词',7)
/
INSERT INTO HtmlLabelInfo VALUES(18352,'congratuation',8)
/


insert into SysPoppupInfo values (6,'/system/sysRemindWfLink.jsp?flag=chgPassWf','密码变更提醒','n','密码变更提醒')
/
INSERT INTO HtmlLabelIndex values(18355,'更改密码')
/
INSERT INTO HtmlLabelIndex values(18354,'更改密码提醒')
/
INSERT INTO HtmlLabelInfo VALUES(18354,'基于安全的原因，请定期更改您的密码.',7)
/
INSERT INTO HtmlLabelInfo VALUES(18354,'please change you password frequently',8)
/
INSERT INTO HtmlLabelInfo VALUES(18355,'更改密码',7)
/
INSERT INTO HtmlLabelInfo VALUES(18355,'change password',8)
/

