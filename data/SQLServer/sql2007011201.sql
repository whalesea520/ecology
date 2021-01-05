
delete from HtmlLabelIndex where id=20159
go
delete from HtmlLabelInfo where indexid=20159
go
INSERT INTO HtmlLabelIndex values(20159,'计划被修改提醒') 
GO
INSERT INTO HtmlLabelInfo VALUES(20159,'计划被修改提醒',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20159,'modify plan alter',8) 
GO
insert into SysPoppupInfo values (13,'/workplan/plan/PlanModify.jsp','20159','y','20159')
go 
