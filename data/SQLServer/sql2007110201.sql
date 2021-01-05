delete from HtmlLabelIndex where id=21013 
GO
delete from HtmlLabelInfo where indexid=21013 
GO
INSERT INTO HtmlLabelIndex values(21013,'待收公文') 
GO
INSERT INTO HtmlLabelInfo VALUES(21013,'待收公文',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21013,'Pending Document',8) 
GO

