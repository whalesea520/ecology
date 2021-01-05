delete from HtmlLabelIndex where id=130439 
GO
delete from HtmlLabelInfo where indexid=130439 
GO
INSERT INTO HtmlLabelIndex values(130439,'不同步') 
GO
INSERT INTO HtmlLabelInfo VALUES(130439,'不同步',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(130439,'Out of sync',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(130439,'不同步',9) 
GO