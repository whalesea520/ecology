delete from HtmlLabelIndex where id=32323 
GO
delete from HtmlLabelInfo where indexid=32323 
GO
INSERT INTO HtmlLabelIndex values(32323,'标识已存在，请重新填写') 
GO
INSERT INTO HtmlLabelInfo VALUES(32323,'标识已存在，请重新填写',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32323,'Code Name already exists, please re-fill',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32323,'标識已存在，請重新填寫',9) 
GO