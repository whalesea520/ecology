delete from HtmlLabelIndex where id=20997 
GO
delete from HtmlLabelInfo where indexid=20997 
GO
INSERT INTO HtmlLabelIndex values(20997,'文档日志查看') 
GO
INSERT INTO HtmlLabelInfo VALUES(20997,'文档日志查看',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20997,'Document Log View',8) 
GO
 
delete from HtmlLabelIndex where id=20999 
GO
delete from HtmlLabelInfo where indexid=20999 
GO
INSERT INTO HtmlLabelIndex values(20999,'仅管理员能查看') 
GO
delete from HtmlLabelIndex where id=20998 
GO
delete from HtmlLabelInfo where indexid=20998 
GO
INSERT INTO HtmlLabelIndex values(20998,'按文档权限查看') 
GO
INSERT INTO HtmlLabelInfo VALUES(20998,'按文档权限查看',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20998,'View By Document Right',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20999,'仅管理员能查看',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20999,'View By Admin Only',8) 
GO
