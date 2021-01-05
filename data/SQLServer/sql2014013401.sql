delete from HtmlLabelIndex where id=32587 
GO
delete from HtmlLabelInfo where indexid=32587 
GO
INSERT INTO HtmlLabelIndex values(32587,'是否转换为PDF格式') 
GO
delete from HtmlLabelIndex where id=32588 
GO
delete from HtmlLabelInfo where indexid=32588 
GO
INSERT INTO HtmlLabelIndex values(32588,'PDF文件转换后存储目录') 
GO
delete from HtmlLabelIndex where id=32589 
GO
delete from HtmlLabelInfo where indexid=32589 
GO
INSERT INTO HtmlLabelIndex values(32589,'水印模板') 
GO
INSERT INTO HtmlLabelInfo VALUES(32587,'是否转换为PDF格式',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32587,'Whether to convert to PDF format',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32587,'是否轉換爲PDF格式',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(32588,'PDF文件转换后存储目录',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32588,'After converting PDF files storage directory',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32588,'PDF文件轉換後存儲目錄',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(32589,'水印模板',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32589,'Watermark template',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32589,'水印模闆',9) 
GO

delete from HtmlLabelIndex where id=32603 
GO
delete from HtmlLabelInfo where indexid=32603 
GO
INSERT INTO HtmlLabelIndex values(32603,'如勾选，则当流程正文套红时，文件会自动转换为PDF格式保存') 
GO
delete from HtmlLabelIndex where id=32604 
GO
delete from HtmlLabelInfo where indexid=32604 
GO
INSERT INTO HtmlLabelIndex values(32604,'会按照选定目录存放转换后的PDF文件') 
GO
delete from HtmlLabelIndex where id=32605 
GO
delete from HtmlLabelInfo where indexid=32605 
GO
INSERT INTO HtmlLabelIndex values(32605,'转换为PDF文件前会套用所选水印模板') 
GO
INSERT INTO HtmlLabelInfo VALUES(32603,'如勾选，则当流程正文套红时，文件会自动转换为PDF格式保存',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32603,'If checked, then when Using Templet, files are automatically converted to PDF format saved',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32603,'如勾選，則當流程正文套紅時，文件會自動轉換爲PDF格式保存',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(32604,'会按照选定目录存放转换后的PDF文件',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32604,'Will be stored in the selected directory after converting PDF files',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32604,'會按照選定目錄存放轉換後的PDF文件',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(32605,'转换为PDF文件前会套用所选水印模板',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32605,'Selected watermark template will be applied before the convert PDF file',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32605,'轉換爲PDF文件前會套用所選水印模闆',9) 
GO

