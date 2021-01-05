delete from HtmlLabelIndex where id=21556 
GO
delete from HtmlLabelInfo where indexid=21556 
GO
INSERT INTO HtmlLabelIndex values(21556,'流程草稿') 
GO
INSERT INTO HtmlLabelInfo VALUES(21556,'流程草稿',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21556,'Workflow Draft',8) 
GO

delete from HtmlLabelIndex where id=21569 
GO
delete from HtmlLabelInfo where indexid=21569 
GO
INSERT INTO HtmlLabelIndex values(21569,'文档属性页设置') 
GO
delete from HtmlLabelIndex where id=21570 
GO
delete from HtmlLabelInfo where indexid=21570 
GO
INSERT INTO HtmlLabelIndex values(21570,'文档属性页字段') 
GO
INSERT INTO HtmlLabelInfo VALUES(21569,'文档属性页设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21569,'Document Properties Setting',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21570,'文档属性页字段',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21570,'Document Properties Field',8) 
GO
