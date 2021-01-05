delete from HtmlLabelIndex where id=22268 
GO
delete from HtmlLabelInfo where indexid=22268 
GO
INSERT INTO HtmlLabelIndex values(22268,'对不起，该收（发）文单位不能封存！') 
GO
INSERT INTO HtmlLabelInfo VALUES(22268,'对不起，该收（发）文单位不能封存！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22268,'Sorry that the receive(dispatch) unit can not be sealed!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22268,'對不起，該收（發）文單位不能封存！',9) 
GO