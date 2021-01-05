delete from HtmlLabelIndex where id=33298 
GO
delete from HtmlLabelInfo where indexid=33298 
GO
INSERT INTO HtmlLabelIndex values(33298,'超出字符数限制，无法保存。') 
GO
INSERT INTO HtmlLabelInfo VALUES(33298,'超出字符数限制，无法保存。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(33298,'character num beyond,can not be saved.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(33298,'超出字符數限制，無法保存。',9) 
GO
