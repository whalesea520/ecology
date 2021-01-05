delete from HtmlLabelIndex where id=131016 
GO
delete from HtmlLabelInfo where indexid=131016 
GO
INSERT INTO HtmlLabelIndex values(131016,'打印水印') 
GO
INSERT INTO HtmlLabelInfo VALUES(131016,'打印水印',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(131016,'Print the watermark',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(131016,'打印水印',9) 
GO


delete from HtmlLabelIndex where id=131024 
GO
delete from HtmlLabelInfo where indexid=131024 
GO
INSERT INTO HtmlLabelIndex values(131024,'请先选择图片') 
GO
INSERT INTO HtmlLabelInfo VALUES(131024,'请先选择图片',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(131024,'Please select the picture first',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(131024,'請先選擇圖片',9) 
GO

delete from HtmlLabelIndex where id=131025 
GO
delete from HtmlLabelInfo where indexid=131025 
GO
INSERT INTO HtmlLabelIndex values(131025,'只允许上传一个图片') 
GO
INSERT INTO HtmlLabelInfo VALUES(131025,'只允许上传一个图片',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(131025,'Only one image is allowed to be uploaded',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(131025,'只允許上傳一個圖片',9) 
GO