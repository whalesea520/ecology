delete from HtmlLabelIndex where id=23084 
GO
delete from HtmlLabelInfo where indexid=23084 
GO
INSERT INTO HtmlLabelIndex values(23084,'不存在') 
GO
INSERT INTO HtmlLabelInfo VALUES(23084,'不存在',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(23084,'not exist',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(23084,'不存在',9) 
GO
