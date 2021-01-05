delete from HtmlLabelIndex where id=128581 
GO
delete from HtmlLabelInfo where indexid=128581 
GO
INSERT INTO HtmlLabelIndex values(128581,'冻结预付款') 
GO
delete from HtmlLabelIndex where id=128582 
GO
delete from HtmlLabelInfo where indexid=128582 
GO
INSERT INTO HtmlLabelIndex values(128582,'冲销预付款') 
GO
delete from HtmlLabelIndex where id=128583 
GO
delete from HtmlLabelInfo where indexid=128583 
GO
INSERT INTO HtmlLabelIndex values(128583,'释放冻结（冲销）预付款') 
GO
INSERT INTO HtmlLabelInfo VALUES(128583,'释放冻结（冲销）预付款',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128583,'The release of frozen (sterilisation) advance',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128583,'釋放凍結（沖銷）預付款',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(128582,'冲销预付款',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128582,'Reversal of prepayment',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128582,'沖銷預付款',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(128581,'冻结预付款',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128581,'Freeze advance',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128581,'凍結預付款',9) 
GO
