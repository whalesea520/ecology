delete from HtmlLabelIndex where id=20903 
GO
delete from HtmlLabelInfo where indexid=20903 
GO
INSERT INTO HtmlLabelIndex values(20903,'确定删除该项目模板吗？') 
GO
INSERT INTO HtmlLabelInfo VALUES(20903,'确定删除该项目模板吗？',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20903,'Are you sure you want to delete it',8) 
GO