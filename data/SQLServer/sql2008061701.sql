delete from HtmlLabelIndex where id=21555 
GO
delete from HtmlLabelInfo where indexid=21555 
GO
INSERT INTO HtmlLabelIndex values(21555,'当资产为单独核算资产时，数量为1') 
GO
INSERT INTO HtmlLabelInfo VALUES(21555,'当资产为单独核算资产时，数量为1',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21555,'The amount is 1 when the capital is accounted alone',8) 
GO


delete from HtmlLabelIndex where id=21541 
GO
delete from HtmlLabelInfo where indexid=21541 
GO
INSERT INTO HtmlLabelIndex values(21541,'资产报废单据') 
GO
INSERT INTO HtmlLabelInfo VALUES(21541,'资产报废单据',7) 
GO

delete from HtmlLabelIndex where id=21545 
GO
delete from HtmlLabelInfo where indexid=21545 
GO
INSERT INTO HtmlLabelIndex values(21545,'报废资产') 
GO
INSERT INTO HtmlLabelInfo VALUES(21545,'报废资产',7) 
GO