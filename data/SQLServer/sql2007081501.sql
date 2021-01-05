delete from HtmlLabelIndex where id=20805
go
delete from HtmlLabelInfo  where indexid=20805
go
INSERT INTO HtmlLabelIndex values(20805,'关闭工资单后将无法再编辑和重新生成此月工资单') 
GO
INSERT INTO HtmlLabelInfo VALUES(20805,'关闭工资单后将无法再编辑和重新生成此月工资单',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20805,'Closed payroll will not be able to regenerate and reedit',8) 
GO
