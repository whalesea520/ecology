delete from HtmlLabelIndex where id=24005 
GO
delete from HtmlLabelInfo where indexid=24005 
GO
INSERT INTO HtmlLabelIndex values(24005,'被沟通人已提交') 
GO
INSERT INTO HtmlLabelInfo VALUES(24005,'被沟通人已提交',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(24005,'The operator has submit the workflow',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(24005,'被溝通人已提交',9) 
GO

delete from HtmlLabelIndex where id=24012 
GO
delete from HtmlLabelInfo where indexid=24012 
GO
INSERT INTO HtmlLabelIndex values(24012,'已被退回，请知悉！') 
GO
INSERT INTO HtmlLabelInfo VALUES(24012,'已被退回，请知悉！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(24012,'Has been returned, please check out!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(24012,'已被退回，請知悉！',9) 
GO
