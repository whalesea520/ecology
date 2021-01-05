delete from HtmlLabelIndex where id=22593 
GO
delete from HtmlLabelInfo where indexid=22593 
GO
INSERT INTO HtmlLabelIndex values(22593,'借用日期') 
GO
INSERT INTO HtmlLabelInfo VALUES(22593,'借用日期',7) 
GO

delete from HtmlLabelIndex where id=22674 
GO
delete from HtmlLabelInfo where indexid=22674 
GO
INSERT INTO HtmlLabelIndex values(22674,'退回日期') 
GO
INSERT INTO HtmlLabelInfo VALUES(22674,'退回日期',7) 
GO