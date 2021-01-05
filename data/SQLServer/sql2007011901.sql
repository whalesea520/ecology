delete HtmlLabelIndex where id=20098
go
delete HtmlLabelInfo where indexid=20098
go
INSERT INTO HtmlLabelIndex values(20098,'工作人员') 
go
INSERT INTO HtmlLabelInfo VALUES(20098,'工作人员',7) 
go
INSERT INTO HtmlLabelInfo VALUES(20098,'employee',8) 
go
