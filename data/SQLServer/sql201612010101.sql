delete from HtmlLabelIndex where id=15880 
GO
delete from HtmlLabelInfo where indexid=15880 
GO
INSERT INTO HtmlLabelIndex values(15880,'考勤') 
GO
INSERT INTO HtmlLabelInfo VALUES(15880,'考勤',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(15880,'Schedule',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(15880,'Schedule',9) 
GO

delete from HtmlNoteIndex where id=4680 
GO
delete from HtmlNoteInfo where indexid=4680 
GO
INSERT INTO HtmlNoteIndex values(4680,'今天是工作日，现在要签到吗？') 
GO
INSERT INTO HtmlNoteInfo VALUES(4680,'今天是工作日，现在要签到吗？',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(4680,'IsWorkday,SignIn?',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(4680,'今天是工作日，現在要簽到嗎？',9) 
GO

delete from HtmlLabelIndex where id=21974 
GO
delete from HtmlLabelInfo where indexid=21974 
GO
INSERT INTO HtmlLabelIndex values(21974,'上班') 
GO
INSERT INTO HtmlLabelInfo VALUES(21974,'上班',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21974,'On Duty',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21974,'On Duty',9) 
GO

delete from HtmlLabelIndex where id=21975 
GO
delete from HtmlLabelInfo where indexid=21975 
GO
INSERT INTO HtmlLabelIndex values(21975,'下班') 
GO
INSERT INTO HtmlLabelInfo VALUES(21975,'下班',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21975,'Off Duty',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21975,'Off Duty',9) 
GO

delete from HtmlLabelIndex where id=129011 
GO
delete from HtmlLabelInfo where indexid=129011 
GO
INSERT INTO HtmlLabelIndex values(129011,'已签到') 
GO
INSERT INTO HtmlLabelInfo VALUES(129011,'已签到',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(129011,'Signed',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(129011,'已簽到',9) 
GO

delete from HtmlLabelIndex where id=129013 
GO
delete from HtmlLabelInfo where indexid=129013 
GO
INSERT INTO HtmlLabelIndex values(129013,'已签退') 
GO
INSERT INTO HtmlLabelInfo VALUES(129013,'已签退',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(129013,'Signed',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(129013,'已簽退',9) 
GO
