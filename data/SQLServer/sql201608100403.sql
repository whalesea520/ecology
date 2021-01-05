delete from HtmlLabelIndex where id=128284 
GO
delete from HtmlLabelInfo where indexid=128284 
GO
INSERT INTO HtmlLabelIndex values(128284,'结转超额费用') 
GO
INSERT INTO HtmlLabelInfo VALUES(128284,'结转超额费用',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128284,'Carry over cost',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128284,'結轉超額費用',9) 
GO


alter table FnaSystemSet add autoMoveMinusAmt int
GO
