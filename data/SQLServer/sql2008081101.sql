delete from HtmlLabelIndex where id=21763 
GO
delete from HtmlLabelInfo where indexid=21763 
GO
INSERT INTO HtmlLabelIndex values(21763,'“requestid”、“billformid”、“billid”为系统字段，不能使用。') 
GO
INSERT INTO HtmlLabelInfo VALUES(21763,'“requestid”、“billformid”、“billid”为系统字段，不能使用。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21763,'requestid,billformid and billid cann''t be uesed,as they are the fields of the system.',8) 
GO

delete from HtmlLabelIndex where id=21764 
GO
delete from HtmlLabelInfo where indexid=21764 
GO
INSERT INTO HtmlLabelIndex values(21764,'“id”、“requestid”、“groupId”为系统字段，不能使用。') 
GO
INSERT INTO HtmlLabelInfo VALUES(21764,'“id”、“requestid”、“groupId”为系统字段，不能使用。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21764,'id,requestid and groupId cann''t be uesed,as they are the fields of the system.',8) 
GO