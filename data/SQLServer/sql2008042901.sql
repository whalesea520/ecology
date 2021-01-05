delete from HtmlLabelIndex where id=21415 
GO
delete from HtmlLabelInfo where indexid=21415 
GO
INSERT INTO HtmlLabelIndex values(21415,'今天是工作日，现在要签到吗？') 
GO
INSERT INTO HtmlLabelInfo VALUES(21415,'今天是工作日，现在要签到吗？',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21415,'IsWorkday,SignIn?',8) 
GO