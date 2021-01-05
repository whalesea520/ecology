DELETE FROM HtmlLabelIndex WHERE id=20890
GO
INSERT INTO HtmlLabelIndex values(20890,'必须上传Excel格式的文件') 
GO

DELETE FROM HtmlLabelInfo WHERE indexid=20890
GO
INSERT INTO HtmlLabelInfo VALUES(20890,'必须上传Excel格式的文件',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20890,'Must upload Excel format file',8) 
GO