delete from HtmlLabelIndex where id in (20267, 20266, 20265)
go
delete from HtmlLabelInfo where indexid in (20267, 20266, 20265)
go

INSERT INTO HtmlLabelIndex values(20267,'进入我的邮件收取') 
GO
INSERT INTO HtmlLabelIndex values(20266,'错误！请检查您的邮件帐户设置。') 
GO
INSERT INTO HtmlLabelIndex values(20265,'正在读取邮件服务器上的新邮件') 
GO
INSERT INTO HtmlLabelInfo VALUES(20265,'正在读取邮件服务器上的新邮件',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20265,'Searching unread mails',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20266,'错误！请检查您的邮件帐户设置。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20266,'Error! Please check your setting.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20267,'进入我的邮件收取',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20267,'Get',8) 
GO

update hpextElement set extshow='Mail.jsp' where id=16
go


delete from HtmlLabelIndex where id in (20265)
go
delete from HtmlLabelInfo where indexid in (20265)
go
INSERT INTO HtmlLabelIndex values(20265,'邮件服务器上的新邮件') 
GO
INSERT INTO HtmlLabelInfo VALUES(20265,'邮件服务器上的新邮件',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20265,'Unread mails',8) 
GO