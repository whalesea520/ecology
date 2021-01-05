delete from HtmlLabelIndex where id=20191
GO
delete from HtmlLabelInfo where indexid=20191
GO
INSERT INTO HtmlLabelIndex values(20191,'请选择普通供应商') 
GO
INSERT INTO HtmlLabelInfo VALUES(20191,'请选择普通供应商',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20191,'choose normal provider please.',8) 
GO

delete from HtmlLabelIndex where id=20192
GO
delete from HtmlLabelInfo where indexid=20192
GO
INSERT INTO HtmlLabelIndex values(20192,'实报金额不能大于申报金额') 
GO
INSERT INTO HtmlLabelInfo VALUES(20192,'实报金额不能大于申报金额',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20192,'wipeamount could not bigger than applyamount',8) 
GO