delete from HtmlLabelIndex where id=21610 
GO
delete from HtmlLabelInfo where indexid=21610 
GO
INSERT INTO HtmlLabelIndex values(21610,'不超过300个字') 
GO
INSERT INTO HtmlLabelInfo VALUES(21610,'不超过300个字',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21610,'No more than 300 words',8) 
GO
delete from HtmlLabelIndex where id=21613 
GO
delete from HtmlLabelInfo where indexid=21613 
GO
INSERT INTO HtmlLabelIndex values(21613,'回复1批准，回复0退回') 
GO
INSERT INTO HtmlLabelInfo VALUES(21613,'回复1批准，回复0退回',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21613,'Repeat 1 to authorize, repeat 0 to untread',8) 
GO
