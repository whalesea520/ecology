
delete from HtmlLabelIndex where id=20159
/
delete from HtmlLabelInfo where indexid=20159
/
INSERT INTO HtmlLabelIndex values(20159,'计划被修改提醒') 
/
INSERT INTO HtmlLabelInfo VALUES(20159,'计划被修改提醒',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20159,'modify plan alter',8) 
/
insert into SysPoppupInfo values (13,'/workplan/plan/PlanModify.jsp','20159','y','20159')
/ 
