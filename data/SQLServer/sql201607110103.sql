alter table fnaFeeWfInfoField add isWfFieldLinkage int
GO

update fnaFeeWfInfoField set isWfFieldLinkage = 0
GO

delete from HtmlLabelIndex where id=127850 
GO
delete from HtmlLabelInfo where indexid=127850 
GO
INSERT INTO HtmlLabelIndex values(127850,'字段联动实现') 
GO
INSERT INTO HtmlLabelInfo VALUES(127850,'字段联动实现',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(127850,'Field linkage implementation',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(127850,'字段聯動實現',9) 
GO
