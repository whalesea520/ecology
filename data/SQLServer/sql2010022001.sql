delete from HtmlLabelIndex where id=24302 
GO
delete from HtmlLabelInfo where indexid=24302 
GO
INSERT INTO HtmlLabelIndex values(24302,'该收（发）文单位不能封存,请先封存下级收（发）文单位!') 
GO
delete from HtmlLabelIndex where id=24303 
GO
delete from HtmlLabelInfo where indexid=24303 
GO
INSERT INTO HtmlLabelIndex values(24303,'该收（发）文单位不能解封,请先解封上级收（发）文单位!') 
GO
INSERT INTO HtmlLabelInfo VALUES(24302,'该收（发）文单位不能封存,请先封存下级收（发）文单位!',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(24302,'The receive(dispatch) unit can not be sealed, please seal lower receive(dispatch) units!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(24302,'該收（發）文單位不能封存,請先封存下級收（發）文單位!',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(24303,'该收（发）文单位不能解封,请先解封上级收（发）文单位!',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(24303,'The receive(dispatch) unit can not be re-opened, please re-opened higher receive(dispatch) units!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(24303,'該收（發）文單位不能解封,請先解封上級收（發）文單位!',9) 
GO
