delete from HtmlLabelIndex where  id=20247
go
delete from HtmlLabelIndex where id=20246
go
delete from HtmlLabelInfo where indexid=20247
go
delete from HtmlLabelInfo where indexid=20246
go
INSERT INTO HtmlLabelIndex values(20247,'1个中文字符等于2个长度') 
GO
INSERT INTO HtmlLabelIndex values(20246,'文本长度不能超过') 
GO
INSERT INTO HtmlLabelInfo VALUES(20246,'文本长度不能超过',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20246,'text length can not exceed',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20247,'1个中文字符等于2个长度',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20247,'one gb2312 char equals tow char',8) 
GO
