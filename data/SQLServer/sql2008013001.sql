delete from HtmlLabelIndex where id=21251 
GO
delete from HtmlLabelInfo where indexid=21251 
GO
INSERT INTO HtmlLabelIndex values(21251,'签批意见') 
GO
INSERT INTO HtmlLabelInfo VALUES(21251,'签批意见',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21251,'sign & attitude',8) 
GO

delete from HtmlLabelIndex where id=21252 
GO
delete from HtmlLabelInfo where indexid=21252 
GO
INSERT INTO HtmlLabelIndex values(21252,'请先执行套红操作！') 
GO
INSERT INTO HtmlLabelInfo VALUES(21252,'请先执行套红操作！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21252,'Please Use Templet First!',8) 
GO
