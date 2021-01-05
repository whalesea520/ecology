delete from HtmlLabelIndex where id=17895 
GO
delete from HtmlLabelInfo where indexid=17895 
GO
INSERT INTO HtmlLabelIndex values(17895,'申请人部门') 
GO
INSERT INTO HtmlLabelInfo VALUES(17895,'申请人部门',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17895,'Department Of Application',8) 
GO

delete from HtmlLabelIndex where id=18671 
GO
delete from HtmlLabelInfo where indexid=18671 
GO
INSERT INTO HtmlLabelIndex values(18671,'报销金额') 
GO
INSERT INTO HtmlLabelInfo VALUES(18671,'报销金额',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18671,'Amount Of Expense',8) 
GO

delete from HtmlLabelIndex where id=18672 
GO
delete from HtmlLabelInfo where indexid=18672 
GO
INSERT INTO HtmlLabelIndex values(18672,'借款余额') 
GO
INSERT INTO HtmlLabelInfo VALUES(18672,'借款余额',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18672,'Balance Of Loan',8) 
GO