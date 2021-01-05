delete from HtmlLabelIndex where id=21699 
GO
delete from HtmlLabelInfo where indexid=21699 
GO
INSERT INTO HtmlLabelIndex values(21699,'未处理任务') 
GO
INSERT INTO HtmlLabelInfo VALUES(21699,'未处理任务',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21699,'Pending Tasks',8) 
GO
