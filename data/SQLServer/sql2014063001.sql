delete from HtmlLabelIndex where id=33290 
GO
delete from HtmlLabelInfo where indexid=33290 
GO
INSERT INTO HtmlLabelIndex values(33290,'您输入的名称长度超过200字符的限制，无法保存。') 
GO
INSERT INTO HtmlLabelInfo VALUES(33290,'您输入的名称长度超过200字符的限制，无法保存。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(33290,'name is longer than 200,can not be saved.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(33290,'您輸入的名稱長度超過200字符的限制，無法保存。',9) 
GO

delete from HtmlLabelIndex where id=33291 
GO
delete from HtmlLabelInfo where indexid=33291 
GO
INSERT INTO HtmlLabelIndex values(33291,'您输入的描述长度超过300字符的限制，无法保存。') 
GO
INSERT INTO HtmlLabelInfo VALUES(33291,'您输入的描述长度超过300字符的限制，无法保存。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(33291,'desc is longer than 300,can not be saved.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(33291,'您輸入的描述長度超過300字符的限制，無法保存。',9) 
GO
 

