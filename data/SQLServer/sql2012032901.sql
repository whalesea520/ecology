delete from HtmlLabelIndex where id=28008 
GO
delete from HtmlLabelInfo where indexid=28008 
GO
INSERT INTO HtmlLabelIndex values(28008,'流程移交') 
GO
INSERT INTO HtmlLabelInfo VALUES(28008,'流程移交',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(28008,'Process transfer',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(28008,'流程移交',9) 
GO

delete from HtmlLabelIndex where id=28009 
GO
delete from HtmlLabelInfo where indexid=28009 
GO
INSERT INTO HtmlLabelIndex values(28009,'移交接收人') 
GO
INSERT INTO HtmlLabelInfo VALUES(28009,'移交接收人',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(28009,'Transfer receiver',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(28009,'移交接收人',9) 
GO

delete from HtmlLabelIndex where id=28010 
GO
delete from HtmlLabelInfo where indexid=28010 
GO
INSERT INTO HtmlLabelIndex values(28010,'是否允许待办事宜移交') 
GO
INSERT INTO HtmlLabelInfo VALUES(28010,'是否允许待办事宜移交',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(28010,'Whether to allow a to-do list moved to do',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(28010,'是否允許待辦事宜移交',9) 
GO