alter table workflow_base add istemplate char(1)
/
alter table workflow_base add templateid integer
/ 
INSERT INTO HtmlLabelIndex values(18167,'模板选择') 
/
INSERT INTO HtmlLabelInfo VALUES(18167,'模板选择',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18167,'TemplateSelect',8) 
/
INSERT INTO HtmlLabelIndex values(18334,'流程模板') 
/
INSERT INTO HtmlLabelInfo VALUES(18334,'流程模板',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18334,'Workflow Template',8) 
/
INSERT INTO HtmlLabelIndex values(18369,'列字段规则') 
/
INSERT INTO HtmlLabelIndex values(18368,'行字段规则') 
/
INSERT INTO HtmlLabelInfo VALUES(18368,'行字段规则',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18368,'Row Field Rule',8) 
/
INSERT INTO HtmlLabelInfo VALUES(18369,'列字段规则',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18369,'Col Field Rule',8) 
/
INSERT INTO HtmlLabelIndex values(18411,'表单类型') 
/
INSERT INTO HtmlLabelInfo VALUES(18411,'表单类型',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18411,'Form Type',8) 
/
delete from HtmlLabelIndex where id=18412
/
delete from HtmlLabelinfo where indexid=18412
/
INSERT INTO HtmlLabelIndex values(18412,'组合查询') 
/
INSERT INTO HtmlLabelIndex values(18413,'按流程类型') 
/
INSERT INTO HtmlLabelInfo VALUES(18412,'组合查询',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18412,'Condition Search',8) 
/
INSERT INTO HtmlLabelInfo VALUES(18413,'按流程类型',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18413,'WorkFlow Type',8) 
/
INSERT INTO HtmlLabelIndex values(18418,'存为模板') 
/
INSERT INTO HtmlLabelInfo VALUES(18418,'存为模板',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18418,'Save Template',8) 
/
call MMConfig_U_ByInfoInsert (4,8)
/
call MMInfo_Insert (460,18334,'流程模板','/workflow/workflow/managewf_frm.jsp?isTemplate=1','mainFrame',4,1,8,0,'',0,'',0,'','',0,'','',3)
/
delete from MainMenuInfo where id=121
/
delete FROM MainMenuConfig WHERE infoId = 121
/