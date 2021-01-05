delete from HtmlLabelIndex where id in(19972,19973,19975,19978,19980,19979,19974,19977,19976,19993,20047)
GO
INSERT INTO HtmlLabelIndex values(19972,'恒安其他报销单') 
GO
INSERT INTO HtmlLabelIndex values(19973,'申请事由') 
GO
INSERT INTO HtmlLabelIndex values(19975,'付款期限') 
GO
INSERT INTO HtmlLabelIndex values(19978,'本次申报金额') 
GO
INSERT INTO HtmlLabelIndex values(19980,'是否最终付款') 
GO
INSERT INTO HtmlLabelIndex values(19979,'本次实报金额') 
GO
INSERT INTO HtmlLabelIndex values(19974,'说明文档') 
GO
INSERT INTO HtmlLabelIndex values(19977,'已报销金额') 
GO
INSERT INTO HtmlLabelIndex values(19976,'是否多次付款') 
GO
INSERT INTO HtmlLabelIndex values(19993,'采购类型') 
GO
INSERT INTO HtmlLabelIndex values(20047,'分摊金额') 
GO

delete from HtmlLabelInfo where indexid in(19972,19973,19975,19978,19980,19979,19974,19977,19976,19993,20047)
GO
INSERT INTO HtmlLabelInfo VALUES(19972,'恒安其他报销单',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19973,'申请事由',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19974,'说明文档',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19975,'付款期限',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19976,'是否多次付款',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19977,'已报销金额',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19978,'本次申报金额',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19979,'本次实报金额',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19980,'是否最终付款',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19993,'采购类型',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20047,'分摊金额',7) 
GO


INSERT INTO HtmlLabelInfo VALUES(19972,'HengAn OtherWipe apply',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19973,'apply reason',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19974,'description file',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19975,'pay deadline',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19976,'is multipay',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19977,'wipedone amount',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19978,'apply wipe amount',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19979,'real wipe amount',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19980,'is lastpay',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19993,'stock type',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20047,'cost apportion amount',8) 
GO
