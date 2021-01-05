
delete from HtmlLabelIndex where id=20807
GO

delete from HtmlLabelInfo where indexid=20807
GO

INSERT INTO HtmlLabelIndex values(20807,'移动短信服务方式') 
GO
INSERT INTO HtmlLabelInfo VALUES(20807,'移动短信服务方式',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20807,'mobile message',8) 
GO