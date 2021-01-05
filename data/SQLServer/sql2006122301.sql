delete from HtmlLabelIndex where id=20046
GO
delete from HtmlLabelInfo where indexid=20046
GO

INSERT INTO HtmlLabelIndex values(20046,'原拥有者') 
GO
INSERT INTO HtmlLabelInfo VALUES(20046,'原拥有者',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20046,'Original Owner',8) 
GO