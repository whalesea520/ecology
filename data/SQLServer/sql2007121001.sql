delete from HtmlLabelIndex where id=21152 
GO
delete from HtmlLabelInfo where indexid=21152 
GO
INSERT INTO HtmlLabelIndex values(21152,'见最下面说明') 
GO
INSERT INTO HtmlLabelInfo VALUES(21152,'见最下面说明',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21152,'See the bottom note',8) 
GO
delete from HtmlLabelIndex where id=21154 
GO
delete from HtmlLabelInfo where indexid=21154 
GO
INSERT INTO HtmlLabelIndex values(21154,'合同终止日期不能小于开业年月') 
GO
delete from HtmlLabelIndex where id=21153 
GO
delete from HtmlLabelInfo where indexid=21153 
GO
INSERT INTO HtmlLabelIndex values(21153,'开业年月不能大于合同终止日期') 
GO
INSERT INTO HtmlLabelInfo VALUES(21153,'开业年月不能大于合同终止日期',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21153,'Opening date can not be greater than the contract termination date',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21154,'合同终止日期不能小于开业年月',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21154,'Contract expiry date can not be less than opening date',8) 
GO
