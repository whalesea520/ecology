delete from HtmlLabelIndex where id=20762
go
delete from HtmlLabelInfo where indexid=20762
go

INSERT INTO HtmlLabelIndex values(20762,'是否允许已办及办结事宜转发') 
GO
INSERT INTO HtmlLabelInfo VALUES(20762,'是否允许已办及办结事宜转发',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20762,'requested can remark',8) 
GO
