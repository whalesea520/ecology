delete from HtmlLabelIndex where id=126679 
GO
delete from HtmlLabelInfo where indexid=126679 
GO
INSERT INTO HtmlLabelIndex values(126679,'报销金额合计 = 冲销金额合计 + 收款金额合计') 
GO
INSERT INTO HtmlLabelInfo VALUES(126679,'报销金额合计 = 冲销金额合计 + 收款金额合计',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126679,'The total amount of the total amount of reimbursement = offset + receivables total amount',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126679,'報銷金額合計 = 沖銷金額合計 + 收款金額合計',9) 
GO

delete from HtmlLabelIndex where id=126680 
GO
delete from HtmlLabelInfo where indexid=126680 
GO
INSERT INTO HtmlLabelIndex values(126680,'还款金额合计 必须等于 冲销金额合计') 
GO
INSERT INTO HtmlLabelInfo VALUES(126680,'还款金额合计 必须等于 冲销金额合计',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126680,'The total amount of the total amount of repayment must be equal to the offset',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126680,'還款金額合計 必須等于 沖銷金額合計',9) 
GO