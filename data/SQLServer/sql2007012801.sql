delete from HtmlLabelIndex where id in (20205,20206,20207)
go
delete from HtmlLabelInfo where indexid in (20205,20206,20207)
go

INSERT INTO HtmlLabelIndex values(20205,'上一张') 
GO
INSERT INTO HtmlLabelIndex values(20206,'下一张') 
GO
INSERT INTO HtmlLabelInfo VALUES(20205,'上一张',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20205,'previous',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20206,'下一张',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20206,'next',8) 
GO
INSERT INTO HtmlLabelIndex values(20207,'相册管理') 
GO
INSERT INTO HtmlLabelInfo VALUES(20207,'相册管理',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20207,'Album Maint',8) 
GO