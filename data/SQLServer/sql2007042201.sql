delete from HtmlLabelIndex where id=20304
go
delete from HtmlLabelInfo where indexid=20304
go

INSERT INTO HtmlLabelIndex values(20304,'无主题') 
GO
INSERT INTO HtmlLabelInfo VALUES(20304,'无主题',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20304,'No Subject',8) 
GO


UPDATE license set cversion = '4.000'
go