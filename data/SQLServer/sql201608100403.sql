delete from HtmlLabelIndex where id=128284 
GO
delete from HtmlLabelInfo where indexid=128284 
GO
INSERT INTO HtmlLabelIndex values(128284,'��ת�������') 
GO
INSERT INTO HtmlLabelInfo VALUES(128284,'��ת�������',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128284,'Carry over cost',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128284,'�Y�D���~�M��',9) 
GO


alter table FnaSystemSet add autoMoveMinusAmt int
GO