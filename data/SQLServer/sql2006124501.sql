delete from HtmlLabelIndex where id=20150
go
delete from HtmlLabelInfo where indexid=20150
go

INSERT INTO HtmlLabelIndex values(20150,'多图显示方式') 
GO
INSERT INTO HtmlLabelInfo VALUES(20150,'多图显示方式',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20150,'Show Mode In More Images',8) 
GO