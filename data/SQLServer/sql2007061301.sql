
delete from HtmlLabelIndex where id=20477
go
delete from HtmlLabelInfo where indexid=20477
go


INSERT INTO HtmlLabelIndex values(20477,'不得删除') 
go
INSERT INTO HtmlLabelInfo VALUES(20477,'不得删除',7) 
go
INSERT INTO HtmlLabelInfo VALUES(20477,'can not delete',8) 
go

