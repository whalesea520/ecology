delete from HtmlLabelIndex where id=21917 
GO
delete from HtmlLabelInfo where indexid=21917 
GO
INSERT INTO HtmlLabelIndex values(21917,'开启失效') 
GO
INSERT INTO HtmlLabelInfo VALUES(21917,'开启失效',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21917,'Failure to open',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21917,'',9) 
GO