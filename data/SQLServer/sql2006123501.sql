delete from HtmlLabelIndex where id=20118
go
delete from HtmlLabelInfo where indexid=20118
go

INSERT INTO HtmlLabelIndex values(20118,'请选择参会人员！') 
GO
INSERT INTO HtmlLabelInfo VALUES(20118,'请选择参会人员！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20118,'Please,select attends!',8) 
GO