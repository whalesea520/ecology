delete from HtmlLabelIndex where id in (20494,20495,20496)
go
delete from HtmlLabelInfo where indexid in (20494,20495,20496)
go

INSERT INTO HtmlLabelIndex values(20494,'重新解析') 
GO
INSERT INTO HtmlLabelIndex values(20495,'正在解析邮件，请稍候...') 
GO
INSERT INTO HtmlLabelInfo VALUES(20494,'重新解析',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20494,'Re-Parse',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20495,'正在解析邮件，请稍候...',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20495,'Parsing, Please wait...',8) 
GO
INSERT INTO HtmlLabelIndex values(20496,'确定重新解析邮件吗？') 
GO
INSERT INTO HtmlLabelInfo VALUES(20496,'确定重新解析邮件吗？',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20496,'Do you confirm re-parse the mail?',8) 
GO