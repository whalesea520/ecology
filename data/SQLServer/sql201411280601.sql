delete from HtmlLabelIndex where id=81688 
GO
delete from HtmlLabelInfo where indexid=81688 
GO
INSERT INTO HtmlLabelIndex values(81688,'可用预算') 
GO
delete from HtmlLabelIndex where id=81689 
GO
delete from HtmlLabelInfo where indexid=81689 
GO
INSERT INTO HtmlLabelIndex values(81689,'已使用预算') 
GO
delete from HtmlLabelIndex where id=81690 
GO
delete from HtmlLabelInfo where indexid=81690 
GO
INSERT INTO HtmlLabelIndex values(81690,'总预算') 
GO
INSERT INTO HtmlLabelInfo VALUES(81688,'可用预算',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(81688,'AvailAmount',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(81688,'可用預算',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(81689,'已使用预算',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(81689,'DistributedAmount',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(81689,'已使用預算',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(81690,'总预算',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(81690,'TotalAmount',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(81690,'總預算',9) 
GO