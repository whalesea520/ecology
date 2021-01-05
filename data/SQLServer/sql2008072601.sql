delete from HtmlLabelIndex where id=21700 
GO
delete from HtmlLabelInfo where indexid=21700 
GO
INSERT INTO HtmlLabelIndex values(21700,'该页面为查看页面') 
GO
delete from HtmlLabelIndex where id=21701 
GO
delete from HtmlLabelInfo where indexid=21701 
GO
INSERT INTO HtmlLabelIndex values(21701,'修改内容不能被保存') 
GO
INSERT INTO HtmlLabelInfo VALUES(21700,'该页面为查看页面',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21700,'The Page is View Page',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21701,'修改内容不能被保存',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21701,'It couldn''t be saved',8) 
GO
