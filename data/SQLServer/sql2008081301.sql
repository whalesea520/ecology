delete from HtmlLabelIndex where id=21769 
GO
delete from HtmlLabelInfo where indexid=21769 
GO
INSERT INTO HtmlLabelIndex values(21769,'折旧信息与资产价值有关，资产价值计算方法如下：') 
GO
INSERT INTO HtmlLabelInfo VALUES(21769,'折旧信息与资产价值有关，资产价值计算方法如下：',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21769,'Information and depreciation of the value of the assets, the value of assets calculated as follows:',8) 
GO



delete from HtmlLabelIndex where id=21770 
GO
delete from HtmlLabelInfo where indexid=21770 
GO
INSERT INTO HtmlLabelIndex values(21770,'对单独核算资产采用"年限平均法"计算资产折旧：') 
GO
INSERT INTO HtmlLabelInfo VALUES(21770,'对单独核算资产采用"年限平均法"计算资产折旧：',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21770,'The separate accounting of assets of "average life" depreciation of assets:',8) 
GO


delete from HtmlLabelIndex where id=21771 
GO
delete from HtmlLabelInfo where indexid=21771 
GO
INSERT INTO HtmlLabelIndex values(21771,'未超过折旧年限：单独核算资产现值＝资产原值- 资产原值×(1- 残值率)×已用年限/折旧年限') 
GO
INSERT INTO HtmlLabelInfo VALUES(21771,'未超过折旧年限：单独核算资产现值＝资产原值- 资产原值×(1- 残值率)×已用年限/折旧年限',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21771,'Did not exceed the depreciation period: the present value of assets alone accounting = actual value of assets - assets at cost × (1 - residual rate) × have spent years / depreciation period',8) 
GO


delete from HtmlLabelIndex where id=21772 
GO
delete from HtmlLabelInfo where indexid=21772 
GO
INSERT INTO HtmlLabelIndex values(21772,'已经超过折旧年限：单独核算资产现值＝资产原值×残值率') 
GO
INSERT INTO HtmlLabelInfo VALUES(21772,'已经超过折旧年限：单独核算资产现值＝资产原值×残值率',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21772,'Has exceeded the depreciation life: the present value of assets alone accounting = residual value of assets at cost',8) 
GO


delete from HtmlLabelIndex where id=21773 
GO
delete from HtmlLabelInfo where indexid=21773 
GO
INSERT INTO HtmlLabelIndex values(21773,'对非单独核算资产，仅计算未领用的资产现值：') 
GO
INSERT INTO HtmlLabelInfo VALUES(21773,'对非单独核算资产，仅计算未领用的资产现值：',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21773,'Non-alone accounting for assets, not only calculate the present value of the assets of recipients:',8) 
GO

delete from HtmlLabelIndex where id=21774 
GO
delete from HtmlLabelInfo where indexid=21774 
GO
INSERT INTO HtmlLabelIndex values(21774,'非单独核算资产现值＝资产数量×采购价格') 
GO
INSERT INTO HtmlLabelInfo VALUES(21774,'非单独核算资产现值＝资产数量×采购价格',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21774,'Individual non-accounting of the present value of assets = assets × the number of purchase prices',8) 
GO


delete from HtmlLabelIndex where id=21777 
GO
delete from HtmlLabelInfo where indexid=21777 
GO
INSERT INTO HtmlLabelIndex values(21777,'折旧信息说明：') 
GO
INSERT INTO HtmlLabelInfo VALUES(21777,'折旧信息说明：',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21777,'Depreciation information:',8) 
GO