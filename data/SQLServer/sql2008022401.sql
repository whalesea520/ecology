delete from HtmlLabelIndex where id=21262 
go
delete from HtmlLabelInfo where indexid=21262 
go
INSERT INTO HtmlLabelIndex values(21262,'对应流程紧急程度设置') 
go
INSERT INTO HtmlLabelInfo VALUES(21262,'对应流程紧急程度设置',7) 
go
INSERT INTO HtmlLabelInfo VALUES(21262,'Related Request Level',8) 
go

delete from HtmlLabelIndex where id=21264 
go
delete from HtmlLabelInfo where indexid=21264 
go
INSERT INTO HtmlLabelIndex values(21264,'小写') 
go
delete from HtmlLabelIndex where id=21263 
go
delete from HtmlLabelInfo where indexid=21263 
go
INSERT INTO HtmlLabelIndex values(21263,'大写') 
go
INSERT INTO HtmlLabelInfo VALUES(21263,'大写',7) 
go
INSERT INTO HtmlLabelInfo VALUES(21263,'Upper Case',8) 
go
INSERT INTO HtmlLabelInfo VALUES(21264,'小写',7) 
go
INSERT INTO HtmlLabelInfo VALUES(21264,'Lower Case',8) 
go

delete from HtmlLabelIndex where id=21268 
go
delete from HtmlLabelInfo where indexid=21268 
go
INSERT INTO HtmlLabelIndex values(21268,'按分部设定') 
go
delete from HtmlLabelIndex where id=21267 
go
delete from HtmlLabelInfo where indexid=21267 
go
INSERT INTO HtmlLabelIndex values(21267,'按部门设定') 
go
INSERT INTO HtmlLabelInfo VALUES(21267,'按部门设定',7) 
go
INSERT INTO HtmlLabelInfo VALUES(21267,'Setting By Department',8) 
go
INSERT INTO HtmlLabelInfo VALUES(21268,'按分部设定',7) 
go
INSERT INTO HtmlLabelInfo VALUES(21268,'Setting By SubCompany',8) 
go

delete from HtmlLabelIndex where id=21271 
go
delete from HtmlLabelInfo where indexid=21271 
go
INSERT INTO HtmlLabelIndex values(21271,'日期显示类型') 
go
INSERT INTO HtmlLabelInfo VALUES(21271,'日期显示类型',7) 
go
INSERT INTO HtmlLabelInfo VALUES(21271,'Date Show Type',8) 
go