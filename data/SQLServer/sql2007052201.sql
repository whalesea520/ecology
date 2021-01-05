delete from HtmlLabelIndex where id=18568
GO
delete from HtmlLabelInfo where indexid=18568
GO
INSERT INTO HtmlLabelIndex values(18568,'已分配/汇总下级预算') 
GO
INSERT INTO HtmlLabelInfo VALUES(18568,'已分配/汇总下级预算',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18568,'Budget Alloted or Collected',8) 
GO

delete from HtmlLabelIndex where id=18502
GO
delete from HtmlLabelInfo where indexid=18502
GO
INSERT INTO HtmlLabelIndex values(18502,'已分配/汇总预算') 
Go
INSERT INTO HtmlLabelInfo VALUES(18502,'已分配/汇总预算',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18502,'Budget Alloted or Collected',8) 
GO