delete from HtmlLabelIndex where id=21636 
go
delete from HtmlLabelInfo where indexid=21636 
go
INSERT INTO HtmlLabelIndex values(21636,'对不起，由于您未设置期间，所以暂时不能对预算进行设置，请先设置期间') 
go
INSERT INTO HtmlLabelInfo VALUES(21636,'对不起，由于您未设置期间，所以暂时不能对预算进行设置，请先设置期间',7) 
go
INSERT INTO HtmlLabelInfo VALUES(21636,'Sorry,because do not set period,so the budget can not be temporarily set,please set period!',8) 
go