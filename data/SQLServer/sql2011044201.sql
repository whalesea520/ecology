delete from HtmlLabelIndex where id=26150 
GO
delete from HtmlLabelInfo where indexid=26150 
GO
INSERT INTO HtmlLabelIndex values(26150,'对不起，该省份不能封存！') 
GO
INSERT INTO HtmlLabelInfo VALUES(26150,'对不起，该省份不能封存！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(26150,'Sorry, the province can not be sealed!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(26150,'對不起，該省份不能封存！',9) 
GO

delete from HtmlLabelIndex where id=26151 
GO
delete from HtmlLabelInfo where indexid=26151 
GO
INSERT INTO HtmlLabelIndex values(26151,'对不起，该国家不能封存！') 
GO
INSERT INTO HtmlLabelInfo VALUES(26151,'对不起，该国家不能封存！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(26151,'Sorry, could not seal the country!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(26151,'對不起，該國家不能封存！',9) 
GO

delete from HtmlLabelIndex where id=26152 
GO
delete from HtmlLabelInfo where indexid=26152 
GO
INSERT INTO HtmlLabelIndex values(26152,'该城市不能解封，请先解封上级省份！') 
GO
INSERT INTO HtmlLabelInfo VALUES(26152,'该城市不能解封，请先解封上级省份！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(26152,'The city can not be re-opened, please re-opened superior provinces!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(26152,'該城市不能解封，請先解封上級省份！',9) 
GO

delete from HtmlLabelIndex where id=26153 
GO
delete from HtmlLabelInfo where indexid=26153 
GO
INSERT INTO HtmlLabelIndex values(26153,'该省份不能解封，请先解封上级国家！') 
GO
INSERT INTO HtmlLabelInfo VALUES(26153,'该省份不能解封，请先解封上级国家！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(26153,'The province can not be re-opened, please re-opened higher state!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(26153,'該省份不能解封，請先解封上級國家！',9) 
GO
