delete from HtmlLabelIndex where id=22410 
GO
delete from HtmlLabelInfo where indexid=22410 
GO
INSERT INTO HtmlLabelIndex values(22410,'被公式引用的字段不能被删除') 
GO
INSERT INTO HtmlLabelInfo VALUES(22410,'被公式引用的字段不能被删除',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22410,'Feild used by formula can''t be deleted',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22410,'被公式引用的字段不能被刪除',9) 
GO
