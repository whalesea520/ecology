delete from HtmlLabelIndex where id=20988 
GO
delete from HtmlLabelInfo where indexid=20988 
GO
INSERT INTO HtmlLabelIndex values(20988,'格式为：86-010-1234567-123') 
GO
INSERT INTO HtmlLabelInfo VALUES(20988,'格式为：86-010-1234567-123',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20988,'',8) 
GO

delete from HtmlLabelIndex where id=20989 
GO
delete from HtmlLabelInfo where indexid=20989 
GO
INSERT INTO HtmlLabelIndex values(20989,'传真格式：86-010-1234567-123') 
GO
INSERT INTO HtmlLabelInfo VALUES(20989,'传真格式：86-010-1234567-123',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20989,'',8) 
GO

delete from HtmlLabelIndex where id=21010 
GO
delete from HtmlLabelInfo where indexid=21010 
GO
INSERT INTO HtmlLabelIndex values(21010,'不填表示长期合作') 
GO
INSERT INTO HtmlLabelInfo VALUES(21010,'不填表示长期合作',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21010,'Empty Means Long Cooperator',8) 
GO
