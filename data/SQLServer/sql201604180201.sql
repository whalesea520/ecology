delete from HtmlLabelIndex where id=127216 
GO
delete from HtmlLabelInfo where indexid=127216 
GO
INSERT INTO HtmlLabelIndex values(127216,'条形码功能尚未开启，请在后台开启条形码功能') 
GO
INSERT INTO HtmlLabelInfo VALUES(127216,'条形码功能尚未开启，请在后台开启条形码功能',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(127216,'barcode is not used, please open',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(127216,'條形碼功能尚未開啟，請在後臺開啟條形碼功能',9) 
GO