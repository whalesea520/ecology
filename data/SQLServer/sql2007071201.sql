
delete from HtmlLabelIndex where id=20561
go
delete from HtmlLabelInfo where indexid=20561
go

INSERT INTO HtmlLabelIndex values(20561,'本周原工作计划') 
GO
INSERT INTO HtmlLabelInfo VALUES(20561,'本周原工作计划',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20561,'plan of this week',8) 
GO