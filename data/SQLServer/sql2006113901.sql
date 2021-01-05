delete from HtmlLabelIndex where id=19921
GO
INSERT INTO HtmlLabelIndex values(19921,'主文档编码') 
GO

delete from HtmlLabelInfo where indexid=19921
GO
INSERT INTO HtmlLabelInfo VALUES(19921,'主文档编码',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19921,'Main Document Code',8) 
GO

delete from HtmlLabelIndex where id=19922
GO
INSERT INTO HtmlLabelIndex values(19922,'子文档编码') 
GO

delete from HtmlLabelInfo where indexid=19922
GO
INSERT INTO HtmlLabelInfo VALUES(19922,'子文档编码',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19922,'Sec Document Code',8) 
GO
