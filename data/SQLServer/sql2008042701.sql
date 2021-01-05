delete from HtmlLabelIndex where id=21423 
GO
delete from HtmlLabelInfo where indexid=21423 
GO
INSERT INTO HtmlLabelIndex values(21423,'未填写') 
GO
INSERT INTO HtmlLabelInfo VALUES(21423,'未填写！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21423,'is empty',8) 
GO

delete from HtmlLabelIndex where id=21430 
GO
delete from HtmlLabelInfo where indexid=21430 
GO
INSERT INTO HtmlLabelIndex values(21430,'流程处理成功') 
GO
INSERT INTO HtmlLabelInfo VALUES(21430,'流程处理成功',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21430,'flow submit sucess',8) 
GO
