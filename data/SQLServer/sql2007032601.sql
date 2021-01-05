
delete from HtmlLabelIndex where id=20271
go

delete from HtmlLabelInfo where indexid=20271
go

INSERT INTO HtmlLabelIndex values(20271,'所有已处理事宜') 
GO
INSERT INTO HtmlLabelInfo VALUES(20271,'所有已处理事宜',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20271,'all dealed request',8) 
GO