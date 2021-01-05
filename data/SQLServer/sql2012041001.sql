delete from HtmlLabelIndex where id=28061 
GO
delete from HtmlLabelInfo where indexid=28061 
GO
INSERT INTO HtmlLabelIndex values(28061,'未上传图片，不允许提交！') 
GO
INSERT INTO HtmlLabelInfo VALUES(28061,'未上传图片，不允许提交！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(28061,'Upload a picture, to allow the author!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(28061,'未上傳圖片，不允許提交！',9) 
GO