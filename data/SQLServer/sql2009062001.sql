delete from HtmlLabelIndex where id=23158 
GO
delete from HtmlLabelInfo where indexid=23158 
GO
INSERT INTO HtmlLabelIndex values(23158,'申请支付佣金额') 
GO
INSERT INTO HtmlLabelInfo VALUES(23158,'申请支付佣金额',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(23158,'apply money',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(23158,'申請支付傭金額',9) 
GO
delete from HtmlLabelIndex where id=22733 
GO
delete from HtmlLabelInfo where indexid=22733 
GO
INSERT INTO HtmlLabelIndex values(22733,'服务费总额') 
GO
INSERT INTO HtmlLabelInfo VALUES(22733,'服务费总额',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22733,'amount of commission',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22733,'服務費總額',9) 
GO

delete from HtmlLabelIndex where id=22739 
GO
delete from HtmlLabelInfo where indexid=22739 
GO
INSERT INTO HtmlLabelIndex values(22739,'未付服务费') 
GO
INSERT INTO HtmlLabelInfo VALUES(22739,'未付服务费',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22739,'unpayed commission',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22739,'未付服務費',9) 
GO

delete from HtmlLabelIndex where id=22738 
GO
delete from HtmlLabelInfo where indexid=22738 
GO
INSERT INTO HtmlLabelIndex values(22738,'已付服务费') 
GO
INSERT INTO HtmlLabelInfo VALUES(22738,'已付服务费',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22738,'payed commission',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22738,'已付服務費',9) 
GO
