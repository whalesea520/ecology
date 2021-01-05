delete from HtmlLabelIndex where id in (19516)
go
delete from HtmlLabelInfo where indexid in (19516)
go
delete from HtmlLabelIndex where id in (20151)
go
delete from HtmlLabelInfo where indexid in (20151)
go

INSERT INTO HtmlLabelIndex values(19516,'自定义') 
GO
INSERT INTO HtmlLabelInfo VALUES(19516,'自定义',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19516,'user-defined',8) 
GO
INSERT INTO HtmlLabelIndex values(20151,'包含被引用的记录，不能删除。') 
GO
INSERT INTO HtmlLabelInfo VALUES(20151,'包含被引用的记录，不能删除。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20151,'can not delete.',8) 
GO