delete from HtmlLabelIndex where id=32661 
GO
delete from HtmlLabelInfo where indexid=32661 
GO
INSERT INTO HtmlLabelIndex values(32661,'是否正文转PDF') 
GO
INSERT INTO HtmlLabelInfo VALUES(32661,'是否正文转PDF',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32661,'Whether the text is converted to PDF',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32661,'是否正文轉PDF',9) 
GO

delete from HtmlLabelIndex where id=32662 
GO
delete from HtmlLabelInfo where indexid=32662 
GO
INSERT INTO HtmlLabelIndex values(32662,'转换后存放目录') 
GO
INSERT INTO HtmlLabelInfo VALUES(32662,'转换后存放目录',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32662,'After conversion store directory',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32662,'轉換後存放目錄',9) 
GO
