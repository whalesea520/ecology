delete from HtmlLabelIndex where id=21096 
GO
delete from HtmlLabelInfo where indexid=21096 
GO
INSERT INTO HtmlLabelIndex values(21096,'转发人转发') 
GO
INSERT INTO HtmlLabelInfo VALUES(21096,'转发人转发',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21096,'Forward',8) 
GO

delete from HtmlLabelIndex where id=21097 
GO
delete from HtmlLabelInfo where indexid=21097 
GO
INSERT INTO HtmlLabelIndex values(21097,'被转发人批注') 
GO
INSERT INTO HtmlLabelInfo VALUES(21097,'被转发人批注',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21097,'Be Forwarded',8) 
GO
