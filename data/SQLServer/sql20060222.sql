insert into SysPoppupInfo values (2,'/system/sysRemindWfLink.jsp?flag=birthWf','生日提醒','y','生日提醒')
go
create table HrmBirthRemindMsg(id int IDENTITY,
                               title varchar(200),
                               resources varchar(500),
                               reminddate char(10))
go
create index index_hrmbirthremind on HrmBirthRemindMsg(id);
go
INSERT INTO HtmlLabelIndex values(18352,'生日祝词')
GO
INSERT INTO HtmlLabelInfo VALUES(18352,'生日祝词',7)
GO
INSERT INTO HtmlLabelInfo VALUES(18352,'congratuation',8)
GO


insert into SysPoppupInfo values (6,'/system/sysRemindWfLink.jsp?flag=chgPassWf','密码变更提醒','n','密码变更提醒')
go
INSERT INTO HtmlLabelIndex values(18355,'更改密码')
GO
INSERT INTO HtmlLabelIndex values(18354,'更改密码提醒')
GO
INSERT INTO HtmlLabelInfo VALUES(18354,'基于安全的原因，请定期更改您的密码.',7)
GO
INSERT INTO HtmlLabelInfo VALUES(18354,'please change you password frequently',8)
GO
INSERT INTO HtmlLabelInfo VALUES(18355,'更改密码',7)
GO
INSERT INTO HtmlLabelInfo VALUES(18355,'change password',8)
GO

