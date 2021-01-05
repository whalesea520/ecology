delete from HtmlLabelIndex where id=21672 
GO
delete from HtmlLabelInfo where indexid=21672 
GO
INSERT INTO HtmlLabelIndex values(21672,'流程来源') 
GO
INSERT INTO HtmlLabelInfo VALUES(21672,'流程来源',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21672,'Workflow From',8) 
GO

delete from HtmlLabelIndex where id=21674 
GO
delete from HtmlLabelInfo where indexid=21674 
GO
INSERT INTO HtmlLabelIndex values(21674,'流程结构体系') 
GO
INSERT INTO HtmlLabelInfo VALUES(21674,'流程结构体系',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21674,'workflow structure',8) 
GO

delete from HtmlLabelIndex where id=19225 
GO
delete from HtmlLabelInfo where indexid=19225 
GO
INSERT INTO HtmlLabelIndex values(19225,'创建人部门') 
GO
INSERT INTO HtmlLabelInfo VALUES(19225,'创建人部门',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19225,'Creator Department',8) 
GO
