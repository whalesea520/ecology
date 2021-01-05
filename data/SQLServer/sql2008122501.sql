delete from HtmlLabelIndex where id=20319 
GO
delete from HtmlLabelInfo where indexid=20319 
GO
INSERT INTO HtmlLabelIndex values(20319,'车牌号') 
GO
INSERT INTO HtmlLabelInfo VALUES(20319,'车牌号',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20319,'Car License',8) 
GO

delete from HtmlLabelIndex where id=22230 
GO
delete from HtmlLabelInfo where indexid=22230 
GO
INSERT INTO HtmlLabelIndex values(22230,'班车维护') 
GO
INSERT INTO HtmlLabelInfo VALUES(22230,'班车维护',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22230,'Frequency car maintance',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22230,'',9) 
GO
delete from HtmlLabelIndex where id=22233 
GO
delete from HtmlLabelInfo where indexid=22233 
GO
INSERT INTO HtmlLabelIndex values(22233,'班车信息') 
GO
INSERT INTO HtmlLabelInfo VALUES(22233,'班车信息',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22233,'Frequencycar info',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22233,'',9) 
GO